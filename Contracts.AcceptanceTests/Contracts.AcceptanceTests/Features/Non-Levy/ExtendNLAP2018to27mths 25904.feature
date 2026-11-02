Feature: ExtendNLAP2018to27mths 25904

@AcceptanceTest @Withdrawn20220201
Scenario: A308 Create but dont approve a 15mth NLAP2018 contract. Bulk update draft adding 12mths to contract. Check docs. Approve. Check CRM. Amend to add another 12mths (to Mar-21). Check docs. Approve. Check CRM
    Given there is no Contract, Task or Workflow data for UKPRN '10017308' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 
	
	# Remove all trace of NLAP config values for NewStarts for a specific UKPRN (DocumentsDomain.NLAPFundingConfig) (28766)
    And   there is no NLAP NewStarts profile data in config for UKPRN '10017308'


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017308' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017308 Co Ltd' with UKPRN '10017308' and OrgId 'ORG0017308' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017308' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017308 | 117308 | 10017308 Co Ltd | 0              | Active                | Yes           | AA017308      | ?             | 8 Blackpool Rd         | Fleetwood Hill         | ?                      | ?                      | Fleetwood              | Lancashire             | BL19 1SD  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017308 |




    # Change the date 
    Given the override date is '22/12/2017'     

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017308 | 10017308 Co Ltd      | ESFA-308             | NLAP-308       | 1                     | 01/01/2018        | 31/03/2019      | 35262.00      | Contract for Services | 2018   | New          | ORG0017308 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode | AllocationDescription | CRMIntent    |
    | 10017308 | NLAP-308       | ANLP-308      | ANLAP             | NONLEVY                 | 01/01/2018          | 31/03/2019        | 17574.00        |         |         |                       | New          |
    | 10017308 | NLAP-308       | YNLP-308      | 16-18NLAP         | NONLEVY                 | 01/01/2018          | 31/03/2019        | 17688.00        |         |         |                       | New          |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total    | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | DeliverableDescription                        | CRMIntent    |
    | 10017308 | NLAP-308       | ANLP-308      | 1               | 0                     | 17574.00 | 476.00   | 1710.00  | 1869.00  | 1535.00  | 1956.00  | 404.00   | 2020.00  | 506.00   | 2392.00  | 164.00   | 153.00   | 1983.00  | 949.00   | 1159.00  | 298.00   | Total 16-18 Non-Levy Apprenticeships Funding  | New          |
    | 10017308 | NLAP-308       | YNLP-308      | 1               | 0                     | 17688.00 | 569.00   | 1548.00  | 1225.00  | 1702.00  | 2217.00  | 926.00   | 756.00   | 732.00   | 375.00   | 1325.00  | 558.00   | 1461.00  | 909.00   | 2190.00  | 1195.00  | Total Adult Non-Levy Apprenticeships Funding  | New          |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Check that the deliverables have all been created in CRM
	Then  there are '30' deliverable period rows in CRM linked to the latest version of contract 'NLAP-308'
    And   there are '15' deliverable periods in CRM linked to the latest version of contract 'NLAP-308' and allocation 'ANLP-308'
    And   there are '15' deliverable periods in CRM linked to the latest version of contract 'NLAP-308' and allocation 'YNLP-308'
 



    # Change the date
    And   the override date is '05/09/2018'

    # Bulk update draft to add a further 12 months up to Mar-20
    Given there are no files prefixed '10017308_NLAP-308' in the Sharepoint 'NLA-2018-Input-Appendices' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 25022019072426 v3_A308' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 25022019072426 v3_A308' in the Sharepoint 'Reports' folder
#   When  a copy of 'NLA NONLEVY 2018 15032018164718 v2_A308.xlsx' from 'DataFiles' is put in the Sharepoint 'Input' folder
    And   spreadsheet 'NLA NONLEVY 2018 25022019072426 v3_A308.xlsx' exists in the Datafiles folder and UKPRN '10017308' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Retrieve parameters
   #And   I retrieve the latest EFA contract details from CRM for provider '10017308' for FundingType 'NLA' and period '2018' and Delivery Organisation '11730801'
    And   I retrieve the latest contract details from CRM for provider '10017308' for FundingType 'NLA' and period '2018'

	# Check the contents of the Appendices. As there is no config in DocumentsDomain.NLAPFundingConfig for this UKPRN, the 'old' template' should be used
	And   the file named '10017308_' & 'NLAP-308' & '_v1.pdf' created in Sharepoint location 'NLA-2018-Input-Appendices' contains the following lines in order
    """
    APPENDIX 1 – SUMMARY OF FUNDING
    Organisation Name: 10017308 Co Ltd UKPRN: 10017308
    Master Contract Number: ESFA-308
    Allocation
    Contract Ref Jan 18 – Mar 18 Apr 18 – Mar 19 Apr 19 – Mar 20 Total
    16-18 Non-Levy Apprenticeships YNLP-308 £11,981 £54,757 £38,104 £104,842
    Adult Non-Levy Apprenticeships ANLP-308 £14,278 £51,848 £42,739 £108,865
    Total Funding for this contract: £213,707   

    Funding Agreement 16-18 Non-Levy Apprenticeships
    Provider: 10017308 Co Ltd UKPRN: 10017308
    Master Contract Ref: ESFA-308 Start Date: 01/01/2018 End Date: 31/03/2020
    Contract Ref: YNLP-308
    Cash (£) Apr 2017 May 2017 Jun 2017 Jul 2017 Aug 2017 Sep 2017 Oct 2017 Nov 2017 Dec 2017 Jan 2018 Feb 2018 Mar 2018
    16-18 Non-Levy Apprenticeships £104,842 £5,017 £4,358 £2,606
    Total Funding £104,842 £5,017 £4,358 £2,606
    Ref (for internal use only):  NLAP-308 v1
    Page 1 of 3 of this Funding Agreement

    Funding Agreement 16-18 Non-Levy Apprenticeships
    Provider: 10017308 Co Ltd UKPRN: 10017308
    Master Contract Ref: ESFA-308 Start Date: 01/01/2018 End Date: 31/03/2020
    Contract Ref: YNLP-308
    Apr 2018 May 2018 Jun 2018 Jul 2018 Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019
    16-18 Non-Levy Apprenticeships £5,749 £4,273 £2,861 £4,984 £6,566 £3,933 £3,880 £1,927 £7,787 £3,997 £7,415 £1,385
    Total Funding £5,749 £4,273 £2,861 £4,984 £6,566 £3,933 £3,880 £1,927 £7,787 £3,997 £7,415 £1,385
    Ref (for internal use only):  NLAP-308 v1
    Page 2 of 3 of this Funding Agreement

    Funding Agreement 16-18 Non-Levy Apprenticeships
    Provider: 10017308 Co Ltd UKPRN: 10017308
    Master Contract Ref: ESFA-308 Start Date: 01/01/2018 End Date: 31/03/2020
    Contract Ref: YNLP-308
    Apr 2019 May 2019 Jun 2019 Jul 2019 Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020
    16-18 Non-Levy Apprenticeships £3,573 £738 £3,403 £1,248 £1,874 £5,834 £4,018 £3,626 £2,691 £5,494 £5,037 £568
    Total Funding £3,573 £738 £3,403 £1,248 £1,874 £5,834 £4,018 £3,626 £2,691 £5,494 £5,037 £568
    Ref (for internal use only):  NLAP-308 v1
    Page 3 of 3 of this Funding Agreement

    Funding Agreement Adult Non-Levy Apprenticeships
    Provider: 10017308 Co Ltd UKPRN: 10017308
    Master Contract Ref: ESFA-308 Start Date: 01/01/2018 End Date: 31/03/2020
    Contract Ref: ANLP-308
    Cash (£) Apr 2017 May 2017 Jun 2017 Jul 2017 Aug 2017 Sep 2017 Oct 2017 Nov 2017 Dec 2017 Jan 2018 Feb 2018 Mar 2018
    Adult Non-Levy Apprenticeships £108,865 £1,954 £5,711 £6,613
    Total Funding £108,865 £1,954 £5,711 £6,613
    Ref (for internal use only):  NLAP-308 v1
    Page 1 of 3 of this Funding Agreement

    Funding Agreement Adult Non-Levy Apprenticeships
    Provider: 10017308 Co Ltd UKPRN: 10017308
    Master Contract Ref: ESFA-308 Start Date: 01/01/2018 End Date: 31/03/2020
    Contract Ref: ANLP-308
    Apr 2018 May 2018 Jun 2018 Jul 2018 Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019
    Adult Non-Levy Apprenticeships £6,019 £7,802 £340 £2,601 £5,881 £6,104 £7,547 £1,105 £308 £4,809 £7,208 £2,124
    Total Funding £6,019 £7,802 £340 £2,601 £5,881 £6,104 £7,547 £1,105 £308 £4,809 £7,208 £2,124
    Ref (for internal use only):  NLAP-308 v1
    Page 2 of 3 of this Funding Agreement

    Funding Agreement Adult Non-Levy Apprenticeships
    Provider: 10017308 Co Ltd UKPRN: 10017308
    Master Contract Ref: ESFA-308 Start Date: 01/01/2018 End Date: 31/03/2020
    Contract Ref: ANLP-308
    Apr 2019 May 2019 Jun 2019 Jul 2019 Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020
    Adult Non-Levy Apprenticeships £5,202 £191 £7,272 £5,658 £2,548 £3,928 £4,013 £3,758 £4,522 £2,229 £1,157 £2,261
    Total Funding £5,202 £191 £7,272 £5,658 £2,548 £3,928 £4,013 £3,758 £4,522 £2,229 £1,157 £2,261
    Ref (for internal use only):  NLAP-308 v1
    Page 3 of 3 of this Funding Agreement
    """


    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017308 | NLAP-308           | 1                     | 1                        | Draft            | Awaiting Documentation    | True          | False               | 01/01/2018        | 31/03/2020      | ?             |
    | 10017308 | NLAP-308           | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/01/2018        | 31/03/2019      | ?             |
    | 10017308 | ESFA-308           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/01/2018        | 31/03/2019      | ?             |

    # Change the date 
    And   the override date is '07/09/2018' 
 
    # Publish the contract 
    And  the latest version of contract 'NLAP-308' is in a state of 'Published to Provider' 
 
    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-308' and actual ContractNumber 'NLAP-308' 
 
    # Check that v2 of the contract is now approved 
    Then  the latest version of contract 'NLAP-308' is in status 'Approved' 

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017308 | NLAP-308           | 1                     | 1                        | Approved         | Approved                  | True          | True                | 01/01/2018        | 31/03/2020      | ?             |
    | 10017308 | NLAP-308           | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/01/2018        | 31/03/2019      | ?             |
    | 10017308 | ESFA-308           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/01/2018        | 31/03/2019      | ?             |




	# Amend the contract to add yet another 12 months, up to Mar-21 

    # Change the date
    Given the override date is '05/02/2020'

    # Set the provider config values for NLAP NewStarts for a specific UKPRN (DocumentsDomain.NLAPFundingConfig) (28766)
    And   the following NLAP NewStarts profile values exist in config
	| UKPRN    | 16-18NewStarts2021 | AdultNewStarts2021 | 16-18NewStartsEstimatedFutureFunding | AdultNewStartsEstimatedFutureFunding |
    | 10017308 | 657.00             | 2150.00            | 14750.00                             | 11620.00                             |

    # Bulk amend to add 12 months to the contract
    And   there are no files prefixed '10017308_NLAP-308' in the Sharepoint 'NLA-2018-Input-Appendices' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 25022019072433 v3_A308_1' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 25022019072433 v3_A308_1' in the Sharepoint 'Reports' folder
    And   spreadsheet 'NLA NONLEVY 2018 25022019072433 v3_A308_1.xlsx' exists in the Datafiles folder and UKPRN '10017308' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Retrieve parameters
   #And   I retrieve the latest EFA contract details from CRM for provider '10017308' for FundingType 'NLA' and period '2018' and Delivery Organisation '11730801'
    And   I retrieve the latest contract details from CRM for provider '10017308' for FundingType 'NLA' and period '2018'

	# Check the contents of the Appendices. As there is config in DocumentsDomain.NLAPFundingConfig for this UKPRN, the 'new' template' should be used
	And   the file named '10017308_' & 'NLAP-308' & '_v2.pdf' created in Sharepoint location 'NLA-2018-Input-Appendices' contains the following lines in order
    """
    APPENDIX 1 – SUMMARY OF FUNDING
    Organisation Name: 10017308 Co Ltd UKPRN: 10017308
    Master Contract Number: ESFA-308
    Allocation
    Contract Ref Jan 18 to Mar 18 Apr 18 to Mar 19 Apr 19 to Mar 20 Apr 20 to Mar 21 Apr 21 to Mar 22 Apr 22 to Mar 23 Total
    16-18 Non-Levy Apprenticeships YNLP-308 £11,981 £54,757 £38,104 £55,281 £160,123
    of which New Starts £657 £657
    Adult Non-Levy Apprenticeships ANLP-308 £14,278 £51,848 £42,739 £51,576 £160,441
    of which New Starts £2,150 £2,150
    Total: £320,564

    Funding Agreement 16-18 Non-Levy Apprenticeships
    Provider: 10017308 Co Ltd UKPRN: 10017308
    Master Contract Ref: ESFA-308 Start Date: 01/01/2018 End Date: 31/03/2021
    Contract Ref: YNLP-308
    Cash (£) Apr 2017 May 2017 Jun 2017 Jul 2017 Aug 2017 Sep 2017 Oct 2017 Nov 2017 Dec 2017 Jan 2018 Feb 2018 Mar 2018
    16-18 Non-Levy Apprenticeships £160,123 £5,017 £4,358 £2,606
    Total Funding £160,123 £5,017 £4,358 £2,606
    Ref (for internal use only):  NLAP-308 v2
    Page 1 of 4 of this Funding Agreement

    Funding Agreement 16-18 Non-Levy Apprenticeships
    Provider: 10017308 Co Ltd UKPRN: 10017308
    Master Contract Ref: ESFA-308 Start Date: 01/01/2018 End Date: 31/03/2021
    Contract Ref: YNLP-308
    Apr 2018 May 2018 Jun 2018 Jul 2018 Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019
    16-18 Non-Levy Apprenticeships £5,749 £4,273 £2,861 £4,984 £6,566 £3,933 £3,880 £1,927 £7,787 £3,997 £7,415 £1,385
    Total Funding £5,749 £4,273 £2,861 £4,984 £6,566 £3,933 £3,880 £1,927 £7,787 £3,997 £7,415 £1,385
    Ref (for internal use only):  NLAP-308 v2
    Page 2 of 4 of this Funding Agreement

    Funding Agreement 16-18 Non-Levy Apprenticeships
    Provider: 10017308 Co Ltd UKPRN: 10017308
    Master Contract Ref: ESFA-308 Start Date: 01/01/2018 End Date: 31/03/2021
    Contract Ref: YNLP-308
    Apr 2019 May 2019 Jun 2019 Jul 2019 Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020
    16-18 Non-Levy Apprenticeships £3,573 £738 £3,403 £1,248 £1,874 £5,834 £4,018 £3,626 £2,691 £5,494 £5,037 £568
    Total Funding £3,573 £738 £3,403 £1,248 £1,874 £5,834 £4,018 £3,626 £2,691 £5,494 £5,037 £568
    Ref (for internal use only):  NLAP-308 v2
    Page 3 of 4 of this Funding Agreement

    Funding Agreement 16-18 Non-Levy Apprenticeships
    Provider: 10017308 Co Ltd UKPRN: 10017308
    Master Contract Ref: ESFA-308 Start Date: 01/01/2018 End Date: 31/03/2021
    Contract Ref: YNLP-308
    Apr 2020 May 2020 Jun 2020 Jul 2020 Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021
    16-18 Non-Levy Apprenticeships £5,875 £4,298 £2,995 £4,825 £6,707 £3,855 £3,980 £2,094 £7,761 £4,116 £7,400 £1,375
    Total Funding £5,875 £4,298 £2,995 £4,825 £6,707 £3,855 £3,980 £2,094 £7,761 £4,116 £7,400 £1,375
    Ref (for internal use only):  NLAP-308 v2
    Page 4 of 4 of this Funding Agreement

    Funding Agreement Adult Non-Levy Apprenticeships
    Provider: 10017308 Co Ltd UKPRN: 10017308
    Master Contract Ref: ESFA-308 Start Date: 01/01/2018 End Date: 31/03/2021
    Contract Ref: ANLP-308
    Cash (£) Apr 2017 May 2017 Jun 2017 Jul 2017 Aug 2017 Sep 2017 Oct 2017 Nov 2017 Dec 2017 Jan 2018 Feb 2018 Mar 2018
    Adult Non-Levy Apprenticeships £160,441 £1,954 £5,711 £6,613
    Total Funding £160,441 £1,954 £5,711 £6,613
    Ref (for internal use only):  NLAP-308 v2
    Page 1 of 4 of this Funding Agreement

    Funding Agreement Adult Non-Levy Apprenticeships
    Provider: 10017308 Co Ltd UKPRN: 10017308
    Master Contract Ref: ESFA-308 Start Date: 01/01/2018 End Date: 31/03/2021
    Contract Ref: ANLP-308
    Apr 2018 May 2018 Jun 2018 Jul 2018 Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019
    Adult Non-Levy Apprenticeships £6,019 £7,802 £340 £2,601 £5,881 £6,104 £7,547 £1,105 £308 £4,809 £7,208 £2,124
    Total Funding £6,019 £7,802 £340 £2,601 £5,881 £6,104 £7,547 £1,105 £308 £4,809 £7,208 £2,124
    Ref (for internal use only):  NLAP-308 v2
    Page 2 of 4 of this Funding Agreement

    Funding Agreement Adult Non-Levy Apprenticeships
    Provider: 10017308 Co Ltd UKPRN: 10017308
    Master Contract Ref: ESFA-308 Start Date: 01/01/2018 End Date: 31/03/2021
    Contract Ref: ANLP-308
    Apr 2019 May 2019 Jun 2019 Jul 2019 Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020
    Adult Non-Levy Apprenticeships £5,202 £191 £7,272 £5,658 £2,548 £3,928 £4,013 £3,758 £4,522 £2,229 £1,157 £2,261
    Total Funding £5,202 £191 £7,272 £5,658 £2,548 £3,928 £4,013 £3,758 £4,522 £2,229 £1,157 £2,261
    Ref (for internal use only):  NLAP-308 v2
    Page 3 of 4 of this Funding Agreement

    Funding Agreement Adult Non-Levy Apprenticeships
    Provider: 10017308 Co Ltd UKPRN: 10017308
    Master Contract Ref: ESFA-308 Start Date: 01/01/2018 End Date: 31/03/2021
    Contract Ref: ANLP-308
    Apr 2020 May 2020 Jun 2020 Jul 2020 Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021
    Adult Non-Levy Apprenticeships £4,910 £7,219 £2,234 £5,090 £189 £7,145 £5,594 £2,680 £3,917 £4,106 £3,805 £4,687
    Total Funding £4,910 £7,219 £2,234 £5,090 £189 £7,145 £5,594 £2,680 £3,917 £4,106 £3,805 £4,687
    Ref (for internal use only):  NLAP-308 v2
    Page 4 of 4 of this Funding Agreement
    """


#    # Publish the contract 
#    And  the latest version of contract 'NLAP-308' is in a state of 'Published to Provider' 
# 
#    # Inject an SFS approval message 
#    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-308' and actual ContractNumber 'NLAP-308' 
# 
#    # Check that v2 of the contract is now approved 
#    Then  the latest version of contract 'NLAP-308' is in status 'Approved' 
#
#    # Check the CONTRACT version, status and dates in CRM
#    Then  the following contract values are present in CRM
#    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
#    | 10017308 | NLAP-308           | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/01/2018        | 31/03/2021      | Variation     |
#    | 10017308 | NLAP-308           | 1                     | 1                        | Replaced         | Approved                  | False         | False               | 01/01/2018        | 31/03/2020      | ?             |
#    | 10017308 | NLAP-308           | 1                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/01/2018        | 31/03/2019      | ?             |
#    | 10017308 | ESFA-308           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/01/2018        | 31/03/2019      | ?             |


    # Tidy up
    And   there is no NLAP NewStarts profile data in config for UKPRN '10017308'
    And   the override date is reset
      
