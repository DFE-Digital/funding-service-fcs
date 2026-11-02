Feature: Create1618NlapContract

@AcceptanceTest @Complete
@Long2Run @Long2Run123
Scenario: AK050 Bulk load a 6-alloc NLAP2018 contract ending in Mar 24. Bulk Amend to extend by 12mths. Consume actuals. Cap. Bulk amend financials to adjust Cap. Payment Batch. Check docs, financials and feed

    # 1. Bulk load a six-alloc NLAP contract. Check docs. Publish and approve
    # 2. Bulk amend to extend 16-18NLAP2018 and ANLAP2018 by 12mths. Check docs. Publish and approve
    # 3. Consume actuals for 24/25 and Cap
    # 4. Payment batch for Jan 25 then check financials and feed 

    Given there is no Contract, Task or Workflow data for UKPRN '10010050' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10010050' 

    # Remove all trace of NLAP config values for NewStarts for a specific UKPRN (DocumentsDomain.NLAPFundingConfig) (28766)
    And   there is no NLAP NewStarts profile data in config for UKPRN '10010050'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | 16-18NLAP2018     |
    | 16-18NLAP-AS2019  |
    | 16-18NLAP-PRS2020 |
    | ANLAP2018         |
    | ANLAP-AS2019      |
    | ANLAP-PRS2020     |

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
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10010050'



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10010050' 
    And   there is no caseload advisor for UKPRN '10010050' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10010050 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10010050' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10010050 Co Ltd' with UKPRN '10010050' and OrgId 'ORG0010050' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10010050 | 110050 | 10010050 Co Ltd | 0              | Active                | Yes           | AA010050      | ?             | 43 Hill Avenue         | Torr Head              | ?                      | ?                      | Amersham               | Buckinghamshire        | HP6 5BX   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10010050 |





    # Part 1. Bulk load a six-alloc NLAP contract. Check docs. Publish and approve

    # Change the date
    Given the override date is '01/12/2017'

    # Set the provider config values for NLAP NewStarts for a specific UKPRN (DocumentsDomain.NLAPFundingConfig) (28766)
    And   the following NLAP NewStarts profile values exist in config
    | UKPRN    | 16-18NewStarts2021 | AdultNewStarts2021 | 16-18NewStartsEstimatedFutureFunding | AdultNewStartsEstimatedFutureFunding |
    | 10010050 | 750.00             | 1025.00            | 2050.00                              | 3175.00                              |


    # Bulk file
    And   there are no files prefixed '10010050' in the Sharepoint 'NLA-2018-Input-Appendices' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 01122023141343 v3_Ak055' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 01122023141343 v3_Ak055' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 01122023141343 v3_Ak055' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 01122023141343 v3_Ak055' in the Sharepoint 'Reports' folder
    And   spreadsheet 'NLA NONLEVY 2018 01122023141343 v3_Ak055.xlsx' exists in the Datafiles folder and UKPRN '10010050' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10010050' for FundingType 'NLA' and period '2018'
#
##    # Check the contents of the Appendices. No FA for 16-18NLAP-AS2019 or ANLAP-AS2019 (27004)
#    Then  the file named '10018041_[ContractNo]_v1.pdf' in Sharepoint location 'NLA-2018-Input-Appendices' contains the following lines in order
#    """
#    Organisation Name: 10010050 Co Ltd UKPRN: 10010050
#    Master Contract Number: [MasterContractNo]
#    Allocation
#    Contract Ref Jan 18 to Mar 18 Apr 18 to Mar 19 Apr 19 to Mar 20 Apr 20 to Mar 21 Apr 21 to Mar 22 Apr 22 to Mar 23 Apr 23 to Mar 24 Apr 24 to Mar 25 Apr 25 to Mar 26 Total
#    16-18 Non-Levy Apprenticeships [AllocRef_YNLP] £5,934 £46,470 £44,102 £36,886 £59,984 £45,442 £21,000 £259,818
#    of which New Starts £750 £750
#    16-18 Non-Levy Apprenticeships £24,683 £0 £24,683
#    (Employer on Apprenticeship
#    Service)
#    16-18 Non-Levy Provider Relief [AllocRef_YNLP] £99,903 £99,903
#    Schemes
#    of which Provider Relief £46,829 £46,829
#    Scheme 1 (April to June 2020)
#    of which Provider Relief £53,074 £53,074
#    Scheme 2 (July to October
#    2020)
#    Adult Non-Levy Apprenticeships [AllocRef_ANLP] £5,019 £46,428 £44,058 £39,576 £48,886 £55,460 £18,600 £258,027
#    of which New Starts £1,025 £1,025
#    Adult Non-Levy Apprenticeships £22,668 £0 £22,668
#    (Employer on Apprenticeship
#    Service)
#    Adult Non-Levy Provider Relief [AllocRef_ANLP] £121,920 £121,920
#    Schemes
#    of which Provider Relief £48,465 £48,465
#    Scheme 1 (April to June 2020)
#    of which Provider Relief £73,455 £73,455
#    Scheme 2 (July to October
#    2020)
#    Total: £787,019
#
#    Funding Agreement 16-18 Non-Levy Apprenticeships
#    Provider: 10010050 Co Ltd UKPRN: 10010050
#    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2024
#    Contract Ref: [AllocRef_YNLP]
#    Cash (£) Apr 2017 May 2017 Jun 2017 Jul 2017 Aug 2017 Sep 2017 Oct 2017 Nov 2017 Dec 2017 Jan 2018 Feb 2018 Mar 2018
#    16-18 Non-Levy Apprenticeships £259,818 £3,001 £2,342 £591
#    Total Funding £259,818 £3,001 £2,342 £591
#    Ref (for internal use only):  [ContractNo] v1
#    Page 1 of 7 of this Funding Agreement
#
#    Funding Agreement 16-18 Non-Levy Apprenticeships
#    Provider: 10010050 Co Ltd UKPRN: 10010050
#    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2024
#    Contract Ref: [AllocRef_YNLP]
#    Apr 2018 May 2018 Jun 2018 Jul 2018 Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019
#    16-18 Non-Levy Apprenticeships £3,733 £2,257 £845 £2,969 £4,550 £1,917 £1,865 £7,862 £5,771 £1,982 £5,399 £7,320
#    Total Funding £3,733 £2,257 £845 £2,969 £4,550 £1,917 £1,865 £7,862 £5,771 £1,982 £5,399 £7,320
#    Ref (for internal use only):  [ContractNo] v1
#    Page 2 of 7 of this Funding Agreement
#
#    Funding Agreement 16-18 Non-Levy Apprenticeships
#    Provider: 10010050 Co Ltd UKPRN: 10010050
#    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2024
#    Contract Ref: [AllocRef_YNLP]
#    Apr 2019 May 2019 Jun 2019 Jul 2019 Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020
#    16-18 Non-Levy Apprenticeships £1,557 £6,673 £1,387 £7,183 £7,809 £3,818 £2,002 £1,610 £676 £5,590 £5,133 £664
#    Total Funding £1,557 £6,673 £1,387 £7,183 £7,809 £3,818 £2,002 £1,610 £676 £5,590 £5,133 £664
#    Ref (for internal use only):  [ContractNo] v1
#    Page 3 of 7 of this Funding Agreement
#
#    Funding Agreement 16-18 Non-Levy Apprenticeships
#    Provider: 10010050 Co Ltd UKPRN: 10010050
#    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2024
#    Contract Ref: [AllocRef_YNLP]
#    Apr 2020 May 2020 Jun 2020 Jul 2020 Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021
#    16-18 Non-Levy Apprenticeships £4,008 £7,766 £717 £122 £1,906 £2,395 £4,656 £7,936 £207 £1,651 £3,159 £2,363
#    Total Funding £4,008 £7,766 £717 £122 £1,906 £2,395 £4,656 £7,936 £207 £1,651 £3,159 £2,363
#    Ref (for internal use only):  [ContractNo] v1
#    Page 4 of 7 of this Funding Agreement
#
#    Funding Agreement 16-18 Non-Levy Apprenticeships
#    Provider: 10010050 Co Ltd UKPRN: 10010050
#    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2024
#    Contract Ref: [AllocRef_YNLP]
#    Apr 2021 May 2021 Jun 2021 Jul 2021 Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022
#    16-18 Non-Levy Apprenticeships £6,864 £1,311 £4,178 £7,256 £2,245 £1,376 £7,713 £4,603 £5,982 £6,067 £5,812 £6,577
#    Total Funding £6,864 £1,311 £4,178 £7,256 £2,245 £1,376 £7,713 £4,603 £5,982 £6,067 £5,812 £6,577
#    Ref (for internal use only):  [ContractNo] v1
#    Page 5 of 7 of this Funding Agreement
#
#    Funding Agreement 16-18 Non-Levy Apprenticeships
#    Provider: 10010050 Co Ltd UKPRN: 10010050
#    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2024
#    Contract Ref: [AllocRef_YNLP]
#    Apr 2022 May 2022 Jun 2022 Jul 2022 Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023
#    16-18 Non-Levy Apprenticeships £4,284 £3,212 £4,316 £1,004 £2,989 £2,872 £5,335 £5,897 £6,322 £5,048 £919 £3,244
#    Total Funding £4,284 £3,212 £4,316 £1,004 £2,989 £2,872 £5,335 £5,897 £6,322 £5,048 £919 £3,244
#    Ref (for internal use only):  [ContractNo] v1
#    Page 6 of 7 of this Funding Agreement
#
#    Funding Agreement 16-18 Non-Levy Apprenticeships
#    Provider: 10010050 Co Ltd UKPRN: 10010050
#    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2024
#    Contract Ref: [AllocRef_YNLP]
#    Apr 2023 May 2023 Jun 2023 Jul 2023 Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024
#    16-18 Non-Levy Apprenticeships £1,200 £1,300 £1,400 £1,500 £1,600 £1,700 £1,800 £1,900 £2,000 £2,100 £2,200 £2,300
#    Total Funding £1,200 £1,300 £1,400 £1,500 £1,600 £1,700 £1,800 £1,900 £2,000 £2,100 £2,200 £2,300
#    Ref (for internal use only):  [ContractNo] v1
#    Page 7 of 7 of this Funding Agreement
#
#    Funding Agreement 16-18 Non-Levy Apprenticeships - Provider Relief Schemes
#    Provider: 10010050 Co Ltd UKPRN: 10010050
#    Master Contract Ref: [MasterContractNo] Start Date: 01/04/2020 End Date: 31/03/2021
#    Contract Ref: [AllocRef_YNLP]
#    Cash (£) Apr 2020 May 2020 Jun 2020 Jul 2020 Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021
#    16-18 Non-Levy Apprenticeships - Provider Relief £46,829 £114 £814 £3,067 £4,648 £7,855 £1,963 £7,960 £5,869 £2,080 £5,497 £5,307 £1,655
#    Scheme 1 (April to June 2020)
#    16-18 Non-Levy Apprenticeships - Provider Relief £53,074 £6,771 £1,485 £7,281 £7,908 £3,916 £7,940 £1,708 £774 £3,576 £3,119 £6,601 £1,995
#    Scheme 2 (July to October 2020)
#    Total Funding £99,903 £6,885 £2,299 £10,348 £12,556 £11,771 £9,903 £9,668 £6,643 £5,656 £8,616 £11,908 £3,650
#    Ref (for internal use only):  [ContractNo] v1
#    Page 1 of 1 of this Funding Agreement
#
#    Funding Agreement Adult Non-Levy Apprenticeships
#    Provider: 10010050 Co Ltd UKPRN: 10010050
#    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2024
#    Contract Ref: [AllocRef_ANLP]
#    Cash (£) Apr 2017 May 2017 Jun 2017 Jul 2017 Aug 2017 Sep 2017 Oct 2017 Nov 2017 Dec 2017 Jan 2018 Feb 2018 Mar 2018
#    Adult Non-Levy Apprenticeships £258,027 £1,270 £2,172 £1,577
#    Total Funding £258,027 £1,270 £2,172 £1,577
#    Ref (for internal use only):  [ContractNo] v1
#    Page 1 of 7 of this Funding Agreement
#
#    Funding Agreement Adult Non-Levy Apprenticeships
#    Provider: 10010050 Co Ltd UKPRN: 10010050
#    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2024
#    Contract Ref: [AllocRef_ANLP]
#    Apr 2018 May 2018 Jun 2018 Jul 2018 Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019
#    Adult Non-Levy Apprenticeships £3,361 £5,961 £271 £3,551 £1,662 £3,106 £6,725 £5,929 £2,479 £2,766 £7,745 £2,872
#    Total Funding £3,361 £5,961 £271 £3,551 £1,662 £3,106 £6,725 £5,929 £2,479 £2,766 £7,745 £2,872
#    Ref (for internal use only):  [ContractNo] v1
#    Page 2 of 7 of this Funding Agreement
#
#    Funding Agreement Adult Non-Levy Apprenticeships
#    Provider: 10010050 Co Ltd UKPRN: 10010050
#    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2024
#    Contract Ref: [AllocRef_ANLP]
#    Apr 2019 May 2019 Jun 2019 Jul 2019 Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020
#    Adult Non-Levy Apprenticeships £3,700 £4,942 £3,328 £218 £1,598 £1,683 £1,428 £2,192 £5,739 £6,778 £7,882 £4,570
#    Total Funding £3,700 £4,942 £3,328 £218 £1,598 £1,683 £1,428 £2,192 £5,739 £6,778 £7,882 £4,570
#    Ref (for internal use only):  [ContractNo] v1
#    Page 3 of 7 of this Funding Agreement
#
#    Funding Agreement Adult Non-Levy Apprenticeships
#    Provider: 10010050 Co Ltd UKPRN: 10010050
#    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2024
#    Contract Ref: [AllocRef_ANLP]
#    Apr 2020 May 2020 Jun 2020 Jul 2020 Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021
#    Adult Non-Levy Apprenticeships £6,556 £6,439 £950 £1,513 £1,937 £663 £4,485 £6,810 £5,674 £3,243 £473 £833
#    Total Funding £6,556 £6,439 £950 £1,513 £1,937 £663 £4,485 £6,810 £5,674 £3,243 £473 £833
#    Ref (for internal use only):  [ContractNo] v1
#    Page 4 of 7 of this Funding Agreement
#
#    Funding Agreement Adult Non-Levy Apprenticeships
#    Provider: 10010050 Co Ltd UKPRN: 10010050
#    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2024
#    Contract Ref: [AllocRef_ANLP]
#    Apr 2021 May 2021 Jun 2021 Jul 2021 Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022
#    Adult Non-Levy Apprenticeships £3,976 £388 £1,088 £3,211 £2,681 £7,999 £2,107 £5,993 £6,014 £2,224 £5,642 £7,563
#    Total Funding £3,976 £388 £1,088 £3,211 £2,681 £7,999 £2,107 £5,993 £6,014 £2,224 £5,642 £7,563
#    Ref (for internal use only):  [ContractNo] v1
#    Page 5 of 7 of this Funding Agreement
#
#    Funding Agreement Adult Non-Levy Apprenticeships
#    Provider: 10010050 Co Ltd UKPRN: 10010050
#    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2024
#    Contract Ref: [AllocRef_ANLP]
#    Apr 2022 May 2022 Jun 2022 Jul 2022 Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023
#    Adult Non-Levy Apprenticeships £3,911 £6,916 £3,741 £7,426 £2,213 £6,172 £2,245 £3,964 £3,030 £5,832 £3,264 £6,746
#    Total Funding £3,911 £6,916 £3,741 £7,426 £2,213 £6,172 £2,245 £3,964 £3,030 £5,832 £3,264 £6,746
#    Ref (for internal use only):  [ContractNo] v1
#    Page 6 of 7 of this Funding Agreement
#
#    Funding Agreement Adult Non-Levy Apprenticeships
#    Provider: 10010050 Co Ltd UKPRN: 10010050
#    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2024
#    Contract Ref: [AllocRef_ANLP]
#    Apr 2023 May 2023 Jun 2023 Jul 2023 Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024
#    Adult Non-Levy Apprenticeships £1,000 £1,100 £1,200 £1,300 £1,400 £1,500 £1,600 £1,700 £1,800 £1,900 £2,000 £2,100
#    Total Funding £1,000 £1,100 £1,200 £1,300 £1,400 £1,500 £1,600 £1,700 £1,800 £1,900 £2,000 £2,100
#    Ref (for internal use only):  [ContractNo] v1
#    Page 7 of 7 of this Funding Agreement
#
#    Funding Agreement Adult Non-Levy Apprenticeships - Provider Relief Schemes
#    Provider: 10010050 Co Ltd UKPRN: 10010050
#    Master Contract Ref: [MasterContractNo] Start Date: 01/04/2020 End Date: 31/03/2021
#    Contract Ref: [AllocRef_ANLP]
#    Cash (£) Apr 2020 May 2020 Jun 2020 Jul 2020 Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021
#    Adult Non-Levy Apprenticeships - Provider Relief Scheme £48,465 £3,628 £5,889 £7,058 £7,280 £773 £4,393 £3,596 £146 £433 £5,412 £6,378 £3,479
#    1 (April to June 2020)
#    Adult Non-Levy Apprenticeships - Provider Relief Scheme £73,455 £4,721 £3,107 £7,948 £7,216 £7,301 £7,046 £7,810 £5,517 £6,557 £7,661 £2,237 £6,334
#    2 (July to October 2020)
#    Total Funding £121,920 £8,349 £8,996 £15,006 £14,496 £8,074 £11,439 £11,406 £5,663 £6,990 £13,073 £8,615 £9,813
#    Ref (for internal use only):  [ContractNo] v1
#    Page 1 of 1 of this Funding Agreement
#    """
#
#    ## There should not be a ...
#    #And   the pdf file does not contain the following text
#    #"""
#    #Blah 
#    #"""

    # Copy\Save a named Sharepoint file to a named folder\filename
    Then Sharepoint file '10010050_[ContractNo]_v1.pdf' in 'NLA-2018-Input-Appendices' is copied to 'Datafiles/Downloads' as 'AK050v1.pdf'



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
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10010050 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/01/2018        | 31/03/2027      | ?             |
    | 10010050 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/01/2018        | 31/03/2027      | ?             |

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_YNLP] | 2240151          | Mar-26 | Reconciliation |
    | [AllocRef_YNLP] | 2240161          | Mar-26 | Reconciliation |
    | [AllocRef_YNLP] | 2240162          | Mar-26 | Reconciliation |
    | [AllocRef_ANLP] | 2340151          | Mar-26 | Reconciliation |
    | [AllocRef_ANLP] | 2340161          | Mar-26 | Reconciliation |
    | [AllocRef_ANLP] | 2340162          | Mar-26 | Reconciliation |


    

    # Part 2. Bulk amend to extend contract and both 2018 allocs by 12mths. Check docs. Publish and approve

    # Change the date
    Given the override date is '04/10/2026'

    # Set the provider config values for NLAP NewStarts for a specific UKPRN (DocumentsDomain.NLAPFundingConfig) (28766)
    And   the following NLAP NewStarts profile values exist in config
    | UKPRN    | 16-18NewStarts2021 | AdultNewStarts2021 | 16-18NewStartsEstimatedFutureFunding | AdultNewStartsEstimatedFutureFunding |
    | 10010050 | 750.00             | 1025.00            | 2050.00                              | 3175.00                              |


    # Bulk file to add 12mths to the contract and both of the 2018 allocs (Note: Bulk file includes [parameters])
    And   there are no files prefixed '10010050' in the Sharepoint 'NLA-2018-Input-Appendices' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 08022023141345 v3_AK050_1' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 08022023141345 v3_AK050_1' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 08022023141345 v3_AK050_1' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'NLA NONLEVY 2018 08022023141345 v3_AK050_1' in the Sharepoint 'Reports' folder
    And   spreadsheet 'NLA NONLEVY 2018 08022023141345 v3_AK050_1.xlsx' exists in the Datafiles folder and UKPRN '10010050' is present in cell 'A2' of the Contract tab
   #When  the file is copied to the Sharepoint 'Input' folder 
    When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10010050' for FundingType 'NLA' and period '2018'

##    # Check the contents of the Appendices. No FA for 16-18NLAP-AS2019 or ANLAP-AS2019 (27004)
    Then Sharepoint file '10010050_[ContractNo]_v2.pdf' in 'NLA-2018-Input-Appendices' is copied to 'Datafiles/Downloads' as 'AK050v2.pdf'
#    """
#    APPENDIX 1 – SUMMARY OF FUNDING
#    Organisation Name: 10010050 Co Ltd UKPRN: 10010050
#    Master Contract Number: [MasterContractNo]
#    Allocation
#    Contract Ref Jan 18 to Mar 18 Apr 18 to Mar 19 Apr 19 to Mar 20 Apr 20 to Mar 21 Apr 21 to Mar 22 Apr 22 to Mar 23 Apr 23 to Mar 24 Apr 24 to Mar 25 Apr 25 to Mar 26 Total
#    16-18 Non-Levy Apprenticeships [AllocRef_YNLP] £5,934 £46,470 £44,102 £36,886 £59,984 £45,442 £21,000 £44,117 £303,935
#    of which New Starts £750 £750
#    16-18 Non-Levy Apprenticeships £24,683 £0 £24,683
#    (Employer on Apprenticeship
#    Service)
#    16-18 Non-Levy Provider Relief [AllocRef_YNLP] £99,903 £99,903
#    Schemes
#    of which Provider Relief £46,829 £46,829
#    Scheme 1 (April to June 2020)
#    of which Provider Relief £53,074 £53,074
#    Scheme 2 (July to October
#    2020)
#    Adult Non-Levy Apprenticeships [AllocRef_ANLP] £5,019 £46,428 £44,058 £39,576 £48,886 £55,460 £18,600 £37,312 £295,339
#    of which New Starts £1,025 £1,025
#    Adult Non-Levy Apprenticeships £22,668 £0 £22,668
#    (Employer on Apprenticeship
#    Service)
#    Adult Non-Levy Provider Relief [AllocRef_ANLP] £121,920 £121,920
#    Schemes
#    of which Provider Relief £48,465 £48,465
#    Scheme 1 (April to June 2020)
#    of which Provider Relief £73,455 £73,455
#    Scheme 2 (July to October
#    2020)
#    Total: £868,448
#
#    Funding Agreement 16-18 Non-Levy Apprenticeships
#    Provider: 10010050 Co Ltd UKPRN: 10010050
#    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2025
#    Contract Ref: [AllocRef_YNLP]
#    Cash (£) Apr 2017 May 2017 Jun 2017 Jul 2017 Aug 2017 Sep 2017 Oct 2017 Nov 2017 Dec 2017 Jan 2018 Feb 2018 Mar 2018
#    16-18 Non-Levy Apprenticeships £303,935 £3,001 £2,342 £591
#    Total Funding £303,935 £3,001 £2,342 £591
#    Ref (for internal use only):  [ContractNo] v2
#    Page 1 of 8 of this Funding Agreement
#
#    Funding Agreement 16-18 Non-Levy Apprenticeships
#    Provider: 10010050 Co Ltd UKPRN: 10010050
#    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2025
#    Contract Ref: [AllocRef_YNLP]
#    Apr 2018 May 2018 Jun 2018 Jul 2018 Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019
#    16-18 Non-Levy Apprenticeships £3,733 £2,257 £845 £2,969 £4,550 £1,917 £1,865 £7,862 £5,771 £1,982 £5,399 £7,320
#    Total Funding £3,733 £2,257 £845 £2,969 £4,550 £1,917 £1,865 £7,862 £5,771 £1,982 £5,399 £7,320
#    Ref (for internal use only):  [ContractNo] v2
#    Page 2 of 8 of this Funding Agreement
#
#    Funding Agreement 16-18 Non-Levy Apprenticeships
#    Provider: 10010050 Co Ltd UKPRN: 10010050
#    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2025
#    Contract Ref: [AllocRef_YNLP]
#    Apr 2019 May 2019 Jun 2019 Jul 2019 Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020
#    16-18 Non-Levy Apprenticeships £1,557 £6,673 £1,387 £7,183 £7,809 £3,818 £2,002 £1,610 £676 £5,590 £5,133 £664
#    Total Funding £1,557 £6,673 £1,387 £7,183 £7,809 £3,818 £2,002 £1,610 £676 £5,590 £5,133 £664
#    Ref (for internal use only):  [ContractNo] v2
#    Page 3 of 8 of this Funding Agreement
#
#    Funding Agreement 16-18 Non-Levy Apprenticeships
#    Provider: 10010050 Co Ltd UKPRN: 10010050
#    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2025
#    Contract Ref: [AllocRef_YNLP]
#    Apr 2020 May 2020 Jun 2020 Jul 2020 Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021
#    16-18 Non-Levy Apprenticeships £4,008 £7,766 £717 £122 £1,906 £2,395 £4,656 £7,936 £207 £1,651 £3,159 £2,363
#    Total Funding £4,008 £7,766 £717 £122 £1,906 £2,395 £4,656 £7,936 £207 £1,651 £3,159 £2,363
#    Ref (for internal use only):  [ContractNo] v2
#    Page 4 of 8 of this Funding Agreement
#
#    Funding Agreement 16-18 Non-Levy Apprenticeships
#    Provider: 10010050 Co Ltd UKPRN: 10010050
#    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2025
#    Contract Ref: [AllocRef_YNLP]
#    Apr 2021 May 2021 Jun 2021 Jul 2021 Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022
#    16-18 Non-Levy Apprenticeships £6,864 £1,311 £4,178 £7,256 £2,245 £1,376 £7,713 £4,603 £5,982 £6,067 £5,812 £6,577
#    Total Funding £6,864 £1,311 £4,178 £7,256 £2,245 £1,376 £7,713 £4,603 £5,982 £6,067 £5,812 £6,577
#    Ref (for internal use only):  [ContractNo] v2
#    Page 5 of 8 of this Funding Agreement
#
#    Funding Agreement 16-18 Non-Levy Apprenticeships
#    Provider: 10010050 Co Ltd UKPRN: 10010050
#    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2025
#    Contract Ref: [AllocRef_YNLP]
#    Apr 2022 May 2022 Jun 2022 Jul 2022 Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023
#    16-18 Non-Levy Apprenticeships £4,284 £3,212 £4,316 £1,004 £2,989 £2,872 £5,335 £5,897 £6,322 £5,048 £919 £3,244
#    Total Funding £4,284 £3,212 £4,316 £1,004 £2,989 £2,872 £5,335 £5,897 £6,322 £5,048 £919 £3,244
#    Ref (for internal use only):  [ContractNo] v2
#    Page 6 of 8 of this Funding Agreement
#
#    Funding Agreement 16-18 Non-Levy Apprenticeships
#    Provider: 10010050 Co Ltd UKPRN: 10010050
#    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2025
#    Contract Ref: [AllocRef_YNLP]
#    Apr 2023 May 2023 Jun 2023 Jul 2023 Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024
#    16-18 Non-Levy Apprenticeships £1,200 £1,300 £1,400 £1,500 £1,600 £1,700 £1,800 £1,900 £2,000 £2,100 £2,200 £2,300
#    Total Funding £1,200 £1,300 £1,400 £1,500 £1,600 £1,700 £1,800 £1,900 £2,000 £2,100 £2,200 £2,300
#    Ref (for internal use only):  [ContractNo] v2
#    Page 7 of 8 of this Funding Agreement
#
#    Funding Agreement 16-18 Non-Levy Apprenticeships
#    Provider: 10010050 Co Ltd UKPRN: 10010050
#    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2025
#    Contract Ref: [AllocRef_YNLP]
#    Apr 2024 May 2024 Jun 2024 Jul 2024 Aug 2024 Sep 2024 Oct 2024 Nov 2024 Dec 2024 Jan 2025 Feb 2025 Mar 2025
#    16-18 Non-Levy Apprenticeships £1,056 £3,480 £2,590 £3,638 £6,524 £7,773 £6,211 £3,045 £2,350 £2,370 £2,192 £2,888
#    Total Funding £1,056 £3,480 £2,590 £3,638 £6,524 £7,773 £6,211 £3,045 £2,350 £2,370 £2,192 £2,888
#    Ref (for internal use only):  [ContractNo] v2
#    Page 8 of 8 of this Funding Agreement
#
#    Funding Agreement 16-18 Non-Levy Apprenticeships - Provider Relief Schemes
#    Provider: 10010050 Co Ltd UKPRN: 10010050
#    Master Contract Ref: [MasterContractNo] Start Date: 01/04/2020 End Date: 31/03/2021
#    Contract Ref: [AllocRef_YNLP]
#    Cash (£) Apr 2020 May 2020 Jun 2020 Jul 2020 Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021
#    16-18 Non-Levy Apprenticeships - Provider Relief £46,829 £114 £814 £3,067 £4,648 £7,855 £1,963 £7,960 £5,869 £2,080 £5,497 £5,307 £1,655
#    Scheme 1 (April to June 2020)
#    16-18 Non-Levy Apprenticeships - Provider Relief £53,074 £6,771 £1,485 £7,281 £7,908 £3,916 £7,940 £1,708 £774 £3,576 £3,119 £6,601 £1,995
#    Scheme 2 (July to October 2020)
#    Total Funding £99,903 £6,885 £2,299 £10,348 £12,556 £11,771 £9,903 £9,668 £6,643 £5,656 £8,616 £11,908 £3,650
#    Ref (for internal use only):  [ContractNo] v2
#    Page 1 of 1 of this Funding Agreement
#
#    Funding Agreement Adult Non-Levy Apprenticeships
#    Provider: 10010050 Co Ltd UKPRN: 10010050
#    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2025
#    Contract Ref: [AllocRef_ANLP]
#    Cash (£) Apr 2017 May 2017 Jun 2017 Jul 2017 Aug 2017 Sep 2017 Oct 2017 Nov 2017 Dec 2017 Jan 2018 Feb 2018 Mar 2018
#    Adult Non-Levy Apprenticeships £295,339 £1,270 £2,172 £1,577
#    Total Funding £295,339 £1,270 £2,172 £1,577
#    Ref (for internal use only):  [ContractNo] v2
#    Page 1 of 8 of this Funding Agreement
#
#    Funding Agreement Adult Non-Levy Apprenticeships
#    Provider: 10010050 Co Ltd UKPRN: 10010050
#    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2025
#    Contract Ref: [AllocRef_ANLP]
#    Apr 2018 May 2018 Jun 2018 Jul 2018 Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019
#    Adult Non-Levy Apprenticeships £3,361 £5,961 £271 £3,551 £1,662 £3,106 £6,725 £5,929 £2,479 £2,766 £7,745 £2,872
#    Total Funding £3,361 £5,961 £271 £3,551 £1,662 £3,106 £6,725 £5,929 £2,479 £2,766 £7,745 £2,872
#    Ref (for internal use only):  [ContractNo] v2
#    Page 2 of 8 of this Funding Agreement
#
#    Funding Agreement Adult Non-Levy Apprenticeships
#    Provider: 10010050 Co Ltd UKPRN: 10010050
#    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2025
#    Contract Ref: [AllocRef_ANLP]
#    Apr 2019 May 2019 Jun 2019 Jul 2019 Aug 2019 Sep 2019 Oct 2019 Nov 2019 Dec 2019 Jan 2020 Feb 2020 Mar 2020
#    Adult Non-Levy Apprenticeships £3,700 £4,942 £3,328 £218 £1,598 £1,683 £1,428 £2,192 £5,739 £6,778 £7,882 £4,570
#    Total Funding £3,700 £4,942 £3,328 £218 £1,598 £1,683 £1,428 £2,192 £5,739 £6,778 £7,882 £4,570
#    Ref (for internal use only):  [ContractNo] v2
#    Page 3 of 8 of this Funding Agreement
#
#    Funding Agreement Adult Non-Levy Apprenticeships
#    Provider: 10010050 Co Ltd UKPRN: 10010050
#    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2025
#    Contract Ref: [AllocRef_ANLP]
#    Apr 2020 May 2020 Jun 2020 Jul 2020 Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021
#    Adult Non-Levy Apprenticeships £6,556 £6,439 £950 £1,513 £1,937 £663 £4,485 £6,810 £5,674 £3,243 £473 £833
#    Total Funding £6,556 £6,439 £950 £1,513 £1,937 £663 £4,485 £6,810 £5,674 £3,243 £473 £833
#    Ref (for internal use only):  [ContractNo] v2
#    Page 4 of 8 of this Funding Agreement
#
#    Funding Agreement Adult Non-Levy Apprenticeships
#    Provider: 10010050 Co Ltd UKPRN: 10010050
#    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2025
#    Contract Ref: [AllocRef_ANLP]
#    Apr 2021 May 2021 Jun 2021 Jul 2021 Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022
#    Adult Non-Levy Apprenticeships £3,976 £388 £1,088 £3,211 £2,681 £7,999 £2,107 £5,993 £6,014 £2,224 £5,642 £7,563
#    Total Funding £3,976 £388 £1,088 £3,211 £2,681 £7,999 £2,107 £5,993 £6,014 £2,224 £5,642 £7,563
#    Ref (for internal use only):  [ContractNo] v2
#    Page 5 of 8 of this Funding Agreement
#
#    Funding Agreement Adult Non-Levy Apprenticeships
#    Provider: 10010050 Co Ltd UKPRN: 10010050
#    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2025
#    Contract Ref: [AllocRef_ANLP]
#    Apr 2022 May 2022 Jun 2022 Jul 2022 Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023
#    Adult Non-Levy Apprenticeships £3,911 £6,916 £3,741 £7,426 £2,213 £6,172 £2,245 £3,964 £3,030 £5,832 £3,264 £6,746
#    Total Funding £3,911 £6,916 £3,741 £7,426 £2,213 £6,172 £2,245 £3,964 £3,030 £5,832 £3,264 £6,746
#    Ref (for internal use only):  [ContractNo] v2
#    Page 6 of 8 of this Funding Agreement
#
#    Funding Agreement Adult Non-Levy Apprenticeships
#    Provider: 10010050 Co Ltd UKPRN: 10010050
#    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2025
#    Contract Ref: [AllocRef_ANLP]
#    Apr 2023 May 2023 Jun 2023 Jul 2023 Aug 2023 Sep 2023 Oct 2023 Nov 2023 Dec 2023 Jan 2024 Feb 2024 Mar 2024
#    Adult Non-Levy Apprenticeships £1,000 £1,100 £1,200 £1,300 £1,400 £1,500 £1,600 £1,700 £1,800 £1,900 £2,000 £2,100
#    Total Funding £1,000 £1,100 £1,200 £1,300 £1,400 £1,500 £1,600 £1,700 £1,800 £1,900 £2,000 £2,100
#    Ref (for internal use only):  [ContractNo] v2
#    Page 7 of 8 of this Funding Agreement
#
#    Funding Agreement Adult Non-Levy Apprenticeships
#    Provider: 10010050 Co Ltd UKPRN: 10010050
#    Master Contract Ref: [MasterContractNo] Start Date: 01/01/2018 End Date: 31/03/2025
#    Contract Ref: [AllocRef_ANLP]
#    Apr 2024 May 2024 Jun 2024 Jul 2024 Aug 2024 Sep 2024 Oct 2024 Nov 2024 Dec 2024 Jan 2025 Feb 2025 Mar 2025
#    Adult Non-Levy Apprenticeships £1,255 £2,268 £3,362 £5,900 £1,989 £1,901 £4,342 £2,868 £3,256 £2,001 £5,843 £2,327
#    Total Funding £1,255 £2,268 £3,362 £5,900 £1,989 £1,901 £4,342 £2,868 £3,256 £2,001 £5,843 £2,327
#    Ref (for internal use only):  [ContractNo] v2
#    Page 8 of 8 of this Funding Agreement
#
#    Funding Agreement Adult Non-Levy Apprenticeships - Provider Relief Schemes
#    Provider: 10010050 Co Ltd UKPRN: 10010050
#    Master Contract Ref: [MasterContractNo] Start Date: 01/04/2020 End Date: 31/03/2021
#    Contract Ref: [AllocRef_ANLP]
#    Cash (£) Apr 2020 May 2020 Jun 2020 Jul 2020 Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021
#    Adult Non-Levy Apprenticeships - Provider Relief Scheme £48,465 £3,628 £5,889 £7,058 £7,280 £773 £4,393 £3,596 £146 £433 £5,412 £6,378 £3,479
#    1 (April to June 2020)
#    Adult Non-Levy Apprenticeships - Provider Relief Scheme £73,455 £4,721 £3,107 £7,948 £7,216 £7,301 £7,046 £7,810 £5,517 £6,557 £7,661 £2,237 £6,334
#    2 (July to October 2020)
#    Total Funding £121,920 £8,349 £8,996 £15,006 £14,496 £8,074 £11,439 £11,406 £5,663 £6,990 £13,073 £8,615 £9,813
#    Ref (for internal use only):  [ContractNo] v2
#    Page 1 of 1 of this Funding Agreement
#    """


    # And   the contract exists in CRM
    # Contract is now at 'Draft\Awaiting Documentation'

    # Copy\Save a named Sharepoint file to a named folder\filename
    #Then Sharepoint file '10018050_[ContractNo]_v2.pdf' in 'NLA-2018-Input-Appendices' is copied to 'Datafiles/Downloads' as 'AK050v2.pdf'

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
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10010050 | [ContractNo]       | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/01/2018        | 31/03/2027      | Variation     |
    | 10010050 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/01/2018        | 31/03/2027      | ?             |
    | 10010050 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/01/2018        | 31/03/2027      | ?             |

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_YNLP] | 2240151          | Mar-26 | Reconciliation |
    | [AllocRef_YNLP] | 2240161          | Mar-26 | Reconciliation |
    | [AllocRef_YNLP] | 2240162          | Mar-26 | Reconciliation |
    | [AllocRef_ANLP] | 2340151          | Mar-26 | Reconciliation |
    | [AllocRef_ANLP] | 2340161          | Mar-26 | Reconciliation |
    | [AllocRef_ANLP] | 2340162          | Mar-26 | Reconciliation |

    ## Check the PLANNED VALUES in CRM for for NLAP2018 for Jan-22 onwards on the latest approved contract
    #And   the Planned Values are calculated as follows 
    #| ContractNumber | AllocationRef     | DeliverableCode | Total     | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   | Aug-24   | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   | 
    #| [ContractNo]   | [AllocRef_ANLP]   | 1               | 108201.00 | 2224.00  | 5642.00  | 7563.00  | 3911.00  | 6916.00  | 3741.00  | 7426.00  | 2213.00  | 6172.00  | 2245.00  | 3964.00  | 3030.00  | 5832.00  | 3264.00  | 6746.00  | 
    #| [ContractNo]   | [AllocRef_YNLP]   | 1               | 108015.00 | 6067.00  | 5812.00  | 6577.00  | 4284.00  | 3212.00  | 4316.00  | 1004.00  | 2989.00  | 2872.00  | 5335.00  | 5897.00  | 6322.00  | 5048.00  | 919.00   | 3244.00  | 
   




   
  # Part 3. Consume actuals for 24/25 and Cap payment6    # Change the date6    Given the override date is '06/05/2025'6    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId6    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0018041'6    # Clear down the stub6    And   there are no entries in the DCFS stub table6    # Month end is not running6    And   the PaaS MonthEndIsRunning indicator is set to 'False'6    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals6    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS6
    # Pull actuals from DC for Dec 2026
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR2018        | R05                  | ORG0010050     | CM             | 202508 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 2               | 0            | 2910.81     |
    | ILR2018        | R05                  | ORG0010050     | CM             | 202508 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 3               | 0            | 1327.20     |
    | ILR2018        | R05                  | ORG0010050     | CM             | 202508 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 4               | 0            | 2946.52     |
    | ILR2018        | R05                  | ORG0010050     | CM             | 202508 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 5               | 0            | 1395.62     |
    | ILR2018        | R05                  | ORG0010050     | CM             | 202509 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 2               | 0            | 2789.56     |
    | ILR2018        | R05                  | ORG0010050     | CM             | 202509 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 3               | 0            | 1396.59     |
    | ILR2018        | R05                  | ORG0010050     | CM             | 202509 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 4               | 0            | 2471.51     |
    | ILR2018        | R05                  | ORG0010050     | CM             | 202509 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 5               | 0            | 1571.21     |
    | ILR2018        | R05                  | ORG0010050     | CM             | 202510 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 2               | 0            | 3161.18     |
    | ILR2018        | R05                  | ORG0010050     | CM             | 202510 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 3               | 0            | 1336.55     |
    | ILR2018        | R05                  | ORG0010050     | CM             | 202510 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 4               | 0            | 2737.12     |
    | ILR2018        | R05                  | ORG0010050     | CM             | 202510 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 5               | 0            | 2267.88     |
    | ILR2018        | R05                  | ORG0010050     | CM             | 202511 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 2               | 0            | 1640.66     |
    | ILR2018        | R05                  | ORG0010050     | CM             | 202511 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 3               | 0            | 3139.64     |
    | ILR2018        | R05                  | ORG0010050     | CM             | 202511 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 4               | 0            | 2753.16     |
    | ILR2018        | R05                  | ORG0010050     | CM             | 202511 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 5               | 0            | 1893.71     |
    | ILR2018        | R05                  | ORG0010050     | CM             | 202512 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 2               | 0            | 1891.22     |
    | ILR2018        | R05                  | ORG0010050     | CM             | 202512 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 3               | 0            | 2553.72     |
    | ILR2018        | R05                  | ORG0010050     | CM             | 202512 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 4               | 0            | 1463.63     |
    | ILR2018        | R05                  | ORG0010050     | CM             | 202512 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 5               | 0            | 6054.27     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202601 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 2               | 0            | 7183.71     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202601 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 3               | 0            | 5803.75     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202601 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 4               | 0            | 8181.03     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202601 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 5               | 0            | 5149.45     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202602 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 2               | 0            | 6305.95     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202602 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 3               | 0            | 6863.77     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202602 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 4               | 0            | 7270.87     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202602 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 5               | 0            | 5720.34     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202603 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 2               | 0            | 8222.12     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202603 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 3               | 0            | 6178.67     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202603 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 4               | 0            | 9085.89     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202603 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 5               | 0            | 5746.14     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202604 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 2               | 0            | 8222.12     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202604 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 3               | 0            | 6178.67     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202604 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 4               | 0            | 9085.89     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202604 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 5               | 0            | 5746.14     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202605 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 2               | 0            | 8222.12     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202605 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 3               | 0            | 6178.67     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202605 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 4               | 0            | 9085.89     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202605 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 5               | 0            | 5746.14     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202606 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 2               | 0            | 8222.12     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202606 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 3               | 0            | 6178.67     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202606 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 4               | 0            | 9085.89     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202606 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 5               | 0            | 5746.14     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202607 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 2               | 0            | 8222.12     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202607 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 3               | 0            | 6178.67     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202607 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 4               | 0            | 9085.89     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202607 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 5               | 0            | 5746.14     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202608 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 2               | 0            | 8222.12     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202608 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 3               | 0            | 6178.67     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202608 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 4               | 0            | 9085.89     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202608 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 5               | 0            | 5746.14     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202609 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 2               | 0            | 8222.12     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202609 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 3               | 0            | 6178.67     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202609 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 4               | 0            | 9085.89     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202609 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 5               | 0            | 5746.14     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202610 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 2               | 0            | 8222.12     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202610 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 3               | 0            | 6178.67     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202610 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 4               | 0            | 9085.89     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202610 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 5               | 0            | 5746.14     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202611 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 2               | 0            | 8222.12     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202611 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 3               | 0            | 6178.67     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202611 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 4               | 0            | 9085.89     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202611 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 5               | 0            | 5746.14     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202612 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 2               | 0            | 8222.12     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202612 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 3               | 0            | 6178.67     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202612 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 4               | 0            | 9085.89     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202612 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 5               | 0            | 5746.14     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202701 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 2               | 0            | 8222.12     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202701 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 3               | 0            | 6178.67     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202701 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 4               | 0            | 9085.89     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202701 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 5               | 0            | 5746.14     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202702 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 2               | 0            | 8222.12     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202702 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 3               | 0            | 6178.67     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202702 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 4               | 0            | 9085.89     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202702 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 5               | 0            | 5746.14     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202703 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 2               | 0            | 8222.12     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202703 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 3               | 0            | 6178.67     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202703 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 4               | 0            | 9085.89     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202703 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 5               | 0            | 5746.14     |

    | ILR2627        | R05                  | ORG0010050     | CM             | 202601 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 2               | 0            | 8942.59     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202601 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 3               | 0            | 6212.32     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202601 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 4               | 0            | 6949.73     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202601 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 5               | 0            | 5210.21     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202602 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 2               | 0            | 1073.13     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202602 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 3               | 0            | 9363.82     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202602 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 4               | 0            | 8615.86     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202602 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 5               | 0            | 1199.85     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202603 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 2               | 0            | 1290.11     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202603 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 3               | 0            | 7305.24     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202603 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 4               | 0            | 8764.62     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202603 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 5               | 0            | 1184.59     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202604 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 2               | 0            | 1290.11     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202604 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 3               | 0            | 7305.24     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202604 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 4               | 0            | 8764.62     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202604 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 5               | 0            | 1184.59     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202605 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 2               | 0            | 1290.11     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202605 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 3               | 0            | 7305.24     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202605 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 4               | 0            | 8764.62     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202605 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 5               | 0            | 1184.59     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202606 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 2               | 0            | 8222.12     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202606 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 3               | 0            | 6178.67     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202606 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 4               | 0            | 9085.89     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202606 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 5               | 0            | 5746.14     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202607 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 2               | 0            | 8222.12     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202607 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 3               | 0            | 6178.67     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202607 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 4               | 0            | 9085.89     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202607 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 5               | 0            | 5746.14     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202608 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 2               | 0            | 8222.12     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202608 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 3               | 0            | 6178.67     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202608 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 4               | 0            | 9085.89     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202608 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 5               | 0            | 5746.14     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202609 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 2               | 0            | 8222.12     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202609 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 3               | 0            | 6178.67     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202609 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 4               | 0            | 9085.89     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202609 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 5               | 0            | 5746.14     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202610 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 2               | 0            | 8222.12     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202610 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 3               | 0            | 6178.67     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202610 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 4               | 0            | 9085.89     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202610 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 5               | 0            | 5746.14     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202611 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 2               | 0            | 8222.12     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202611 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 3               | 0            | 6178.67     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202611 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 4               | 0            | 9085.89     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202611 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 5               | 0            | 5746.14     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202612 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 2               | 0            | 8222.12     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202612 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 3               | 0            | 6178.67     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202612 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 4               | 0            | 9085.89     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202612 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 5               | 0            | 5746.14     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202701 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 2               | 0            | 8222.12     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202701 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 3               | 0            | 6178.67     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202701 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 4               | 0            | 9085.89     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202701 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 5               | 0            | 5746.14     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202702 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 2               | 0            | 8222.12     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202702 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 3               | 0            | 6178.67     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202702 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 4               | 0            | 9085.89     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202702 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 5               | 0            | 5746.14     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202703 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 2               | 0            | 8222.12     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202703 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 3               | 0            | 6178.67     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202703 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 4               | 0            | 9085.89     |
    | ILR2627        | R05                  | ORG0010050     | CM             | 202703 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 5               | 0            | 5746.14     |

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
#    | UKPRN    | ContractNumber | AllocationRef      | ReconciliationSubnominal | Dec-24    |
#    | 10010050 | [ContractNo]   | [AllocRef_ANLP]    | 2340151                  | 24040.84  | 
#    | 10010050 | [ContractNo]   | [AllocRef_ANLP]    | 2340161                  | 14893.94  | 
#    | 10010050 | [ContractNo]   | [AllocRef_ANLP]    | 2340162                  | 17673.56  | 
#    | 10010050 | [ContractNo]   | [AllocRef_YNLP]    | 2240151                  | 22147.13  | 
#    | 10010050 | [ContractNo]   | [AllocRef_YNLP]    | 2240161                  | 12371.94  | 
#    | 10010050 | [ContractNo]   | [AllocRef_YNLP]    | 2240162                  | 13182.69  | 
#
#    # Check the CAPPING subnominal aggregations in CRM
#    And   the Capping Subnominal Amounts are calculated as follows
#    | UKPRN    | ContractNumber | AllocationRef      | CappingSubnominal        | Dec-24    |
#    | 10010050 | [ContractNo]   | [AllocRef_ANLP]    | 2340151                  | -19296.34 | 
#    | 10010050 | [ContractNo]   | [AllocRef_YNLP]    | 2240151                  | -3584.76  | 
#
#


#
#    # Part 5. Payment batch for Apr 25
#
#    # Payment Batch stuff starts here for 16-18NLAP2018(PoA)
#
#    # Change the date
#    Given the override date is '09/05/2025 22:05'
#
#    # Month end is not running
#    And   the PaaS MonthEndIsRunning indicator is set to 'False'
#
#    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
#    And   there is no data in the Payment feed for FundingStreamPeriod '16-18NLAP2018' AccountingPaymentPeriod '202501' CensusEndDate '09/05/2025' and LinkCodeSuffix 'A'
#
#    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
#    And   the following allocation periods are present in the subnominal aggregation PaaS table
#    | ContractAllocationNumber | Period |
#    | [AllocRef_YNLP]          | 202504 |
#
#    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
#    And   the following configuration exists in the Payment Timetable
#    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
#    | 16-18NLAP2018              | 202504               |                      | A              | NotStarted |
#
#    When  the Payment Generation Batch run is started
#
#    # PaymentGeneration.PaymentTimetable
#    Then  there is an entry in the Payment Timetable
#    | Funding Stream Period Code | Calendar Year/Period | Status    |
#    | 16-18NLAP2018              | 202504               | Completed |
#
#    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
#    And   the Payment feed xml for FundingStreamPeriod '16-18NLAP2018' PaymentPeriod '202501' CensusEndDate '09/05/2025' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'S041_YNLP.xml'
#
##    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
##    And   the Payment feed xml for FundingStreamPeriod '16-18NLAP2018' PaymentPeriod '202409' CensusEndDate '09/01/2025' and LinkCodeSuffix 'A' includes the following values
##    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef     | AggregatedValue | PaymentType      | SubnominalDescription  | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
##    | YNLP                   | 2024          | 09             | 09          | ?       | [AllocRef_YNLP]   | -3584.76        | CAPPING          | 16-18 NLAP             | 2024-01-23 | 2018-01-01   | 2025-03-31 | ?              | 10010050 | 2240151    |
##    | YNLP                   | 2024          | 09             | 09          | ?       | [AllocRef_YNLP]   | 22147.13        | RECONCILIATION   | 16-18 NLAP             | 2024-01-23 | 2018-01-01   | 2025-03-31 | ?              | 10010050 | 2240151    |
##    | YNLP                   | 2024          | 09             | 09          | ?       | [AllocRef_YNLP]   | 12371.94        | RECONCILIATION   | 16-18 NLAP Employer    | 2024-01-23 | 2018-01-01   | 2025-03-31 | ?              | 10010050 | 2240161    |
##    | YNLP                   | 2024          | 09             | 09          | ?       | [AllocRef_YNLP]   | 13182.69        | RECONCILIATION   | 16-18NonLevy AppsInd   | 2024-01-23 | 2018-01-01   | 2025-03-31 | ?              | 10010050 | 2240162    |
##
#
#
#
#
#    # Payment Batch stuff starts here for ANLAP2018(PoA)
#
#    # Change the date
#    Given the override date is '09/05/2025 22:05'
#
#    # Month end is not running
#    And   the PaaS MonthEndIsRunning indicator is set to 'False'
#
#    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
#    And   there is no data in the Payment feed for FundingStreamPeriod 'ANLAP2018' AccountingPaymentPeriod '202501' CensusEndDate '09/05/2025' and LinkCodeSuffix 'A'
#
#    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
#    And   the following allocation periods are present in the subnominal aggregation PaaS table
#    | ContractAllocationNumber | Period |
#    | [AllocRef_ANLP]          | 202504 |
#
#    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
#    And   the following configuration exists in the Payment Timetable
#    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
#    | ANLAP2018                  | 202504               |                      | A              | NotStarted |
#
#    When  the Payment Generation Batch run is started
#
#    # PaymentGeneration.PaymentTimetable
#    Then  there is an entry in the Payment Timetable
#    | Funding Stream Period Code | Calendar Year/Period | Status    |
#    | ANLAP2018                  | 202504               | Completed |
#
#    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
#    And   the Payment feed xml for FundingStreamPeriod 'ANLAP2018' PaymentPeriod '202501' CensusEndDate '09/05/2025' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'S041_ANLP.xml'
#
#    ## Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
#    #And   the Payment feed xml for FundingStreamPeriod 'ANLAP2018' PaymentPeriod '202409' CensusEndDate '09/01/2025' and LinkCodeSuffix 'A' includes the following values
#    #| FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef     | AggregatedValue | PaymentType      | SubnominalDescription  | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
#    #| ANLP                   | 2024          | 09             | 09          | ?       | [AllocRef_ANLP]   | -19296.34       | CAPPING          | 19+ NLAP               | 2024-01-23 | 2018-01-01   | 2025-03-31 | ?              | 10010050 | 2340151    |
#    #| ANLP                   | 2024          | 09             | 09          | ?       | [AllocRef_ANLP]   | 24040.84        | RECONCILIATION   | 19+ NLAP               | 2024-01-23 | 2018-01-01   | 2025-03-31 | ?              | 10010050 | 2340151    |
#    #| ANLP                   | 2024          | 09             | 09          | ?       | [AllocRef_ANLP]   | 14893.94        | RECONCILIATION   | 19+ NLAP Employer      | 2024-01-23 | 2018-01-01   | 2025-03-31 | ?              | 10010050 | 2340161    |
#    #| ANLP                   | 2024          | 09             | 09          | ?       | [AllocRef_ANLP]   | 17673.56        | RECONCILIATION   | 19+NonLevy AppsInd     | 2024-01-23 | 2018-01-01   | 2025-03-31 | ?              | 10010050 | 2340162    |
#
#
#
#
#
#    # Part 10: Create Consolidated Payment Summary rpt
#   
#    # Set the override date, run the Consolidated Payment Summary Report and save output in Sharepoint (30759) J050)
#    #Given the override date is '06/01/2023 10:00'
#
#   # Change the date
#   Given the override date is '12/05/2025 22:05'
#   
#   Given there are no files prefixed '2025-05 Payments.xlsx' in the Sharepoint 'Consolidated Payment Summary' folder
#   
#   When  a Consolidated Payment Summary Report is created in Sharepoint for '12/05/2025'
#    # Check the above report manually
#
#        
#    
    # CDA
    
    # Run the CDA report
    Given the override date is '13/05/2026'
    Given there is no CDA report named 'CDA Latest Version AK050.csv'
    And   the following ADF Pipeline run
    And   the following CDA report is run
    | FundingStreamPeriod           | Version               | Suffix |
    | 16-18NLAP2018, ANLAP2018      | Latest Version        | AK050   |

    Then  a report named 'CDA Latest Version AK050.csv' is created
	# Check the above report manually

#
#
##
##
##    # Part 3. Consume actuals for 24/25 and Cap payment
##
##    # Change the date
##    Given the override date is '06/05/2025'
##
##    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
##    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0018041'
##
##    # Clear down the stub
##    And   there are no entries in the DCFS stub table
##
##    # Month end is not running
##    And   the PaaS MonthEndIsRunning indicator is set to 'False'
##
##    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
##    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS
##
##    # Pull actuals from DC for Dec 2024
##    And   the following closed collections are available in DCFS 
##    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202408 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 2               | 0            | 2910.81     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202408 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 3               | 0            | 1327.20     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202408 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 4               | 0            | 2946.52     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202408 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 5               | 0            | 1395.62     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202409 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 2               | 0            | 2789.56     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202409 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 3               | 0            | 1396.59     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202409 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 4               | 0            | 2471.51     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202409 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 5               | 0            | 1571.21     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202410 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 2               | 0            | 3161.18     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202410 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 3               | 0            | 1336.55     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202410 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 4               | 0            | 2737.12     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202410 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 5               | 0            | 2267.88     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202411 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 2               | 0            | 1640.66     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202411 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 3               | 0            | 3139.64     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202411 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 4               | 0            | 2753.16     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202411 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 5               | 0            | 1893.71     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202412 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 2               | 0            | 1891.22     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202412 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 3               | 0            | 2553.72     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202412 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 4               | 0            | 1463.63     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202412 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 5               | 0            | 6054.27     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202501 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 2               | 0            | 7183.71     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202501 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 3               | 0            | 5803.75     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202501 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 4               | 0            | 8181.03     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202501 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 5               | 0            | 5149.45     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202502 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 2               | 0            | 6305.95     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202502 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 3               | 0            | 6863.77     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202502 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 4               | 0            | 7270.87     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202502 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 5               | 0            | 5720.34     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202503 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 2               | 0            | 8222.12     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202503 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 3               | 0            | 6178.67     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202503 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 4               | 0            | 9085.89     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202503 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 5               | 0            | 5746.14     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202504 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 2               | 0            | 8222.12     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202504 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 3               | 0            | 6178.67     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202504 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 4               | 0            | 9085.89     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202504 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 5               | 0            | 5746.14     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202505 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 2               | 0            | 8222.12     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202505 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 3               | 0            | 6178.67     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202505 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 4               | 0            | 9085.89     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202505 | 16-18NLAP2018           | [AllocRef_YNLP]          | ?          | 5               | 0            | 5746.14     |
##
##
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202408 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 2               | 0            | 3064.81     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202408 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 3               | 0            | 1935.85     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202408 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 4               | 0            | 2598.53     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202408 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 5               | 0            | 3855.66     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202409 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 2               | 0            | 1211.23     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202409 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 3               | 0            | 1376.11     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202409 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 4               | 0            | 2949.17     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202409 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 5               | 0            | 1139.43     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202410 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 2               | 0            | 1102.83     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202410 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 3               | 0            | 3222.56     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202410 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 4               | 0            | 1396.12     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202410 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 5               | 0            | 2389.76     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202411 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 2               | 0            | 1128.38     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202411 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 3               | 0            | 1366.38     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202411 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 4               | 0            | 1653.27     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202411 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 5               | 0            | 1702.42     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202412 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 2               | 0            | 5488.01     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202412 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 3               | 0            | 4144.68     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202412 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 4               | 0            | 6296.85     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202412 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 5               | 0            | 8586.29     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202501 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 2               | 0            | 8942.59     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202501 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 3               | 0            | 6212.32     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202501 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 4               | 0            | 6949.73     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202501 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 5               | 0            | 5210.21     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202502 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 2               | 0            | 1073.13     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202502 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 3               | 0            | 9363.82     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202502 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 4               | 0            | 8615.86     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202502 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 5               | 0            | 1199.85     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202503 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 2               | 0            | 1290.11     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202503 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 3               | 0            | 7305.24     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202503 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 4               | 0            | 8764.62     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202503 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 5               | 0            | 1184.59     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202504 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 2               | 0            | 1290.11     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202504 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 3               | 0            | 7305.24     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202504 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 4               | 0            | 8764.62     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202504 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 5               | 0            | 1184.59     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202505 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 2               | 0            | 1290.11     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202505 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 3               | 0            | 7305.24     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202505 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 4               | 0            | 8764.62     |
##    | ILR2018        | R05                  | ORG0018041     | CM             | 202505 | ANLAP2018               | [AllocRef_ANLP]          | ?          | 5               | 0            | 1184.59     |
##
##
##
##    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
##   #When  the FCT system polls the DCFS DEDS service
##    When  the FCT system polls the SLD service
##
##    Then wait '30' seconds
##
###
###    # Check financials for Jan-22 to Mar-24
##
##    ## Check the ACTUAL VALUES in CRM on the latest approved contract
##    #Then  the Actuals Value Data is as follows
##    #| ContractNumber | AllocationRef      | DeliverableCode | Total     | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-22   | Jun-23   | Jul-23   | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   | Aug-24   | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   |
##    #| [ContractNo]   | [AllocRef_ANLP]    | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
##    #| [ContractNo]   | [AllocRef_ANLP]    | 2               | 11995.26  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 3064.81  | 1211.23  | 1102.83  | 1128.38  | 5488.01  | ?        | ?        | ?        | 
##    #| [ContractNo]   | [AllocRef_ANLP]    | 3               | 12045.58  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 1935.85  | 1376.11  | 3222.56  | 1366.38  | 4144.68  | ?        | ?        | ?        | 
##    #| [ContractNo]   | [AllocRef_ANLP]    | 4               | 14893.94  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 2598.53  | 2949.17  | 1396.12  | 1653.27  | 6296.85  | ?        | ?        | ?        | 
##    #| [ContractNo]   | [AllocRef_ANLP]    | 5               | 17673.56  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 3855.66  | 1139.43  | 2389.76  | 1702.42  | 8586.29  | ?        | ?        | ?        | 
##    ##
##    #| [ContractNo]   | [AllocRef_YNLP]    | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
##    #| [ContractNo]   | [AllocRef_YNLP]    | 2               | 12393.43  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 2910.81  | 2789.56  | 3161.18  | 1640.66  | 1891.22  | ?        | ?        | ?        | 
##    #| [ContractNo]   | [AllocRef_YNLP]    | 3               | 9753.70   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 1327.20  | 1396.59  | 1336.55  | 3139.64  | 2553.72  | ?        | ?        | ?        | 
##    #| [ContractNo]   | [AllocRef_YNLP]    | 4               | 12371.94  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 2946.52  | 2471.51  | 2737.12  | 2753.16  | 1463.63  | ?        | ?        | ?        | 
##    #| [ContractNo]   | [AllocRef_YNLP]    | 5               | 13182.69  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 1395.62  | 1571.21  | 2267.88  | 1893.71  | 6054.27  | ?        | ?        | ?        | 
##
###    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
###    And   the Reconciliation Data is calculated as follows 
###    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-22   | Jun-23   | Jul-23   | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   | Aug-24   | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   |
###    | [ContractNo]   | [AllocRef_ANLP]    | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
###    | [ContractNo]   | [AllocRef_ANLP]    | 2               | 11995.26  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 11995.26 | 0.00     | 0.00     | 0.00     | 
###    | [ContractNo]   | [AllocRef_ANLP]    | 3               | 12045.58  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 12045.58 | 0.00     | 0.00     | 0.00     | 
###    | [ContractNo]   | [AllocRef_ANLP]    | 4               | 14893.94  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 14893.94 | 0.00     | 0.00     | 0.00     | 
###    | [ContractNo]   | [AllocRef_ANLP]    | 5               | 17673.56  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 17673.56 | 0.00     | 0.00     | 0.00     | 
###    #
###    | [ContractNo]   | [AllocRef_YNLP]    | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
###    | [ContractNo]   | [AllocRef_YNLP]    | 2               | 12393.43  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 12393.43 | 0.00     | 0.00     | 0.00     | 
###    | [ContractNo]   | [AllocRef_YNLP]    | 3               | 9753.70   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 9753.70  | 0.00     | 0.00     | 0.00     | 
###    | [ContractNo]   | [AllocRef_YNLP]    | 4               | 12371.94  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 12371.94 | 0.00     | 0.00     | 0.00     | 
###    | [ContractNo]   | [AllocRef_YNLP]    | 5               | 13182.69  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 13182.69 | 0.00     | 0.00     | 0.00     | 
###
###    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
###    And   the Capping Amounts are calculated as follows 
###    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-22   | Jun-23   | Jul-23   | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   | Aug-24   | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   |
###    | [ContractNo]   | [AllocRef_ANLP]    | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
###    | [ContractNo]   | [AllocRef_ANLP]    | 2               | -9627.98  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -9627.98 | 0.00     | 0.00     | 0.00     | 
###    | [ContractNo]   | [AllocRef_ANLP]    | 3               | -9668.36  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -9668.36 | 0.00     | 0.00     | 0.00     | 
###    | [ContractNo]   | [AllocRef_ANLP]    | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
###    | [ContractNo]   | [AllocRef_ANLP]    | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
###    #
###    | [ContractNo]   | [AllocRef_YNLP]    | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
###    | [ContractNo]   | [AllocRef_YNLP]    | 2               | -2006.01  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -2006.01 | 0.00     | 0.00     | 0.00     | 
###    | [ContractNo]   | [AllocRef_YNLP]    | 3               | -1578.75  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | -1578.75 | 0.00     | 0.00     | 0.00     | 
###    | [ContractNo]   | [AllocRef_YNLP]    | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
###    | [ContractNo]   | [AllocRef_YNLP]    | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
###
###    # Check the NET AMOUNTS in CRM on the latest approved contract
###    And   the Net Payments are calculated as follows 
###    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-22   | Jun-23   | Jul-23   | Aug-23   | Sep-23   | Oct-23   | Nov-23   | Dec-23   | Jan-24   | Feb-24   | Mar-24   | Apr-24   | May-24   | Jun-24   | Jul-24   | Aug-24   | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   |
###    | [ContractNo]   | [AllocRef_ANLP]    | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
###    | [ContractNo]   | [AllocRef_ANLP]    | 2               | 2367.28   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2367.28  | 0.00     | 0.00     | 0.00     | 
###    | [ContractNo]   | [AllocRef_ANLP]    | 3               | 2377.22   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 2377.22  | 0.00     | 0.00     | 0.00     | 
###    | [ContractNo]   | [AllocRef_ANLP]    | 4               | 14893.94  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 14893.94 | 0.00     | 0.00     | 0.00     | 
###    | [ContractNo]   | [AllocRef_ANLP]    | 5               | 17673.56  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 17673.56 | 0.00     | 0.00     | 0.00     | 
###    #
###    | [ContractNo]   | [AllocRef_YNLP]    | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
###    | [ContractNo]   | [AllocRef_YNLP]    | 2               | 10387.42  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 10387.42 | 0.00     | 0.00     | 0.00     | 
###    | [ContractNo]   | [AllocRef_YNLP]    | 3               | 8174.95   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 8174.95  | 0.00     | 0.00     | 0.00     | 
###    | [ContractNo]   | [AllocRef_YNLP]    | 4               | 12371.94  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 12371.94 | 0.00     | 0.00     | 0.00     | 
###    | [ContractNo]   | [AllocRef_YNLP]    | 5               | 13182.69  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 13182.69 | 0.00     | 0.00     | 0.00     | 
###
###
###    # Subnominal Aggregations
###
###    # Check the RECONCILIATION subnominal aggregations in CRM
###    And   the Reconciliation Subnominal Amounts are calculated as follows
###    | UKPRN    | ContractNumber | AllocationRef      | ReconciliationSubnominal | Dec-24    |
###    | 10010050 | [ContractNo]   | [AllocRef_ANLP]    | 2340151                  | 24040.84  | 
###    | 10010050 | [ContractNo]   | [AllocRef_ANLP]    | 2340161                  | 14893.94  | 
###    | 10010050 | [ContractNo]   | [AllocRef_ANLP]    | 2340162                  | 17673.56  | 
###    | 10010050 | [ContractNo]   | [AllocRef_YNLP]    | 2240151                  | 22147.13  | 
###    | 10010050 | [ContractNo]   | [AllocRef_YNLP]    | 2240161                  | 12371.94  | 
###    | 10010050 | [ContractNo]   | [AllocRef_YNLP]    | 2240162                  | 13182.69  | 
###
###    # Check the CAPPING subnominal aggregations in CRM
###    And   the Capping Subnominal Amounts are calculated as follows
###    | UKPRN    | ContractNumber | AllocationRef      | CappingSubnominal        | Dec-24    |
###    | 10010050 | [ContractNo]   | [AllocRef_ANLP]    | 2340151                  | -19296.34 | 
###    | 10010050 | [ContractNo]   | [AllocRef_YNLP]    | 2240151                  | -3584.76  | 
###
###
##
##
##
##    # Part 5. Payment batch for Apr 25
##
##    # Payment Batch stuff starts here for 16-18NLAP2018(PoA)
##
##    # Change the date
##    Given the override date is '09/05/2025 22:05'
##
##    # Month end is not running
##    And   the PaaS MonthEndIsRunning indicator is set to 'False'
##
##    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
##    And   there is no data in the Payment feed for FundingStreamPeriod '16-18NLAP2018' AccountingPaymentPeriod '202501' CensusEndDate '09/05/2025' and LinkCodeSuffix 'A'
##
##    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
##    And   the following allocation periods are present in the subnominal aggregation PaaS table
##    | ContractAllocationNumber | Period |
##    | [AllocRef_YNLP]          | 202504 |
##
##    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
##    And   the following configuration exists in the Payment Timetable
##    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
##    | 16-18NLAP2018              | 202504               |                      | A              | NotStarted |
##
##    When  the Payment Generation Batch run is started
##
##    # PaymentGeneration.PaymentTimetable
##    Then  there is an entry in the Payment Timetable
##    | Funding Stream Period Code | Calendar Year/Period | Status    |
##    | 16-18NLAP2018              | 202504               | Completed |
##
##    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
##    And   the Payment feed xml for FundingStreamPeriod '16-18NLAP2018' PaymentPeriod '202501' CensusEndDate '09/05/2025' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'S041_YNLP.xml'
##
###    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
###    And   the Payment feed xml for FundingStreamPeriod '16-18NLAP2018' PaymentPeriod '202409' CensusEndDate '09/01/2025' and LinkCodeSuffix 'A' includes the following values
###    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef     | AggregatedValue | PaymentType      | SubnominalDescription  | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
###    | YNLP                   | 2024          | 09             | 09          | ?       | [AllocRef_YNLP]   | -3584.76        | CAPPING          | 16-18 NLAP             | 2024-01-23 | 2018-01-01   | 2025-03-31 | ?              | 10010050 | 2240151    |
###    | YNLP                   | 2024          | 09             | 09          | ?       | [AllocRef_YNLP]   | 22147.13        | RECONCILIATION   | 16-18 NLAP             | 2024-01-23 | 2018-01-01   | 2025-03-31 | ?              | 10010050 | 2240151    |
###    | YNLP                   | 2024          | 09             | 09          | ?       | [AllocRef_YNLP]   | 12371.94        | RECONCILIATION   | 16-18 NLAP Employer    | 2024-01-23 | 2018-01-01   | 2025-03-31 | ?              | 10010050 | 2240161    |
###    | YNLP                   | 2024          | 09             | 09          | ?       | [AllocRef_YNLP]   | 13182.69        | RECONCILIATION   | 16-18NonLevy AppsInd   | 2024-01-23 | 2018-01-01   | 2025-03-31 | ?              | 10010050 | 2240162    |
###
##
##
##
##
##    # Payment Batch stuff starts here for ANLAP2018(PoA)
##
##    # Change the date
##    Given the override date is '09/05/2025 22:05'
##
##    # Month end is not running
##    And   the PaaS MonthEndIsRunning indicator is set to 'False'
##
##    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
##    And   there is no data in the Payment feed for FundingStreamPeriod 'ANLAP2018' AccountingPaymentPeriod '202501' CensusEndDate '09/05/2025' and LinkCodeSuffix 'A'
##
##    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
##    And   the following allocation periods are present in the subnominal aggregation PaaS table
##    | ContractAllocationNumber | Period |
##    | [AllocRef_ANLP]          | 202504 |
##
##    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
##    And   the following configuration exists in the Payment Timetable
##    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
##    | ANLAP2018                  | 202504               |                      | A              | NotStarted |
##
##    When  the Payment Generation Batch run is started
##
##    # PaymentGeneration.PaymentTimetable
##    Then  there is an entry in the Payment Timetable
##    | Funding Stream Period Code | Calendar Year/Period | Status    |
##    | ANLAP2018                  | 202504               | Completed |
##
##    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
##    And   the Payment feed xml for FundingStreamPeriod 'ANLAP2018' PaymentPeriod '202501' CensusEndDate '09/05/2025' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'S041_ANLP.xml'
##
##    ## Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
##    #And   the Payment feed xml for FundingStreamPeriod 'ANLAP2018' PaymentPeriod '202409' CensusEndDate '09/01/2025' and LinkCodeSuffix 'A' includes the following values
##    #| FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef     | AggregatedValue | PaymentType      | SubnominalDescription  | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
##    #| ANLP                   | 2024          | 09             | 09          | ?       | [AllocRef_ANLP]   | -19296.34       | CAPPING          | 19+ NLAP               | 2024-01-23 | 2018-01-01   | 2025-03-31 | ?              | 10010050 | 2340151    |
##    #| ANLP                   | 2024          | 09             | 09          | ?       | [AllocRef_ANLP]   | 24040.84        | RECONCILIATION   | 19+ NLAP               | 2024-01-23 | 2018-01-01   | 2025-03-31 | ?              | 10010050 | 2340151    |
##    #| ANLP                   | 2024          | 09             | 09          | ?       | [AllocRef_ANLP]   | 14893.94        | RECONCILIATION   | 19+ NLAP Employer      | 2024-01-23 | 2018-01-01   | 2025-03-31 | ?              | 10010050 | 2340161    |
##    #| ANLP                   | 2024          | 09             | 09          | ?       | [AllocRef_ANLP]   | 17673.56        | RECONCILIATION   | 19+NonLevy AppsInd     | 2024-01-23 | 2018-01-01   | 2025-03-31 | ?              | 10010050 | 2340162    |
##
##
##
##
##
##    # Part 10: Create Consolidated Payment Summary rpt
##   
##    # Set the override date, run the Consolidated Payment Summary Report and save output in Sharepoint (30759) J050)
##    #Given the override date is '06/01/2023 10:00'
##
##   # Change the date
##   Given the override date is '12/05/2025 22:05'
##   
##   Given there are no files prefixed '2025-05 Payments.xlsx' in the Sharepoint 'Consolidated Payment Summary' folder
##   
##   When  a Consolidated Payment Summary Report is created in Sharepoint for '12/05/2025'
##    # Check the above report manually
##
##        
##    
##    # CDA
##    
##    # Run the CDA report
##    Given the override date is '13/05/2025'
##    Given there is no CDA report named 'CDA Latest Version S041.csv'
##    And   the following ADF Pipeline run
##    And   the following CDA report is run
##    | FundingStreamPeriod           | Version               | Suffix |
##    | 16-18NLAP2018, ANLAP2018      | Latest Version        | S041   |
##
##    Then  a report named 'CDA Latest Version S041.csv' is created
##	# Check the above report manually
#
#
#
#    # Tidy Up
#    Given the override date is reset
#
#    # Remove all trace of NLAP config values for NewStarts for a specific UKPRN (DocumentsDomain.NLAPFundingConfig) (28766)
#    And   there is no NLAP NewStarts profile data in config for UKPRN '10010050'
#   