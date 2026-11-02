Feature: CreateCSPIPFContract


@AcceptanceTest @Complete
@Long2Run @Long2Run67
Scenario Outline: S204 Bulk load a CSPIPF new contract and do NFA notification amendment, NFA vary amendment. Check docs. 
    Given there are no allocations marked as Under Termination for UKPRN '<UKPRN>' 
    And   there are no terminated or closed allocations for UKPRN '<UKPRN>' 
    And   there is no Contract, Task or Workflow data for UKPRN '<UKPRN>' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '<UKPRN>' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '<UKPRN>' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP            |
    | <FSP>     	 |


    # Set the base timestamp for each of the  document templates (DocumentsDomain.UploadedDocumentTemplate) (J107)
    And the following document templates have Upload timestamps as indicated
    | DocumentTemplateName          | UploadTimestamp         |
    | <DocumentTemplateName>        | <UploadTimestamp1>      | 



    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '<UKPRN>'


    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '<UKPRN>' 
    And   there is no caseload advisor for UKPRN '<UKPRN>' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | <UKPRN> | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '<UKPRN>' 

    And   caseload advisor 'FCS2 Test' is assigned to provider '<LegalName>' with UKPRN '<UKPRN>' and OrgId '<OrgId>' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber 		  | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | <UKPRN>  | <UPIN> | <LegalName>  	  | 0              | In Administration     | Yes           | <CompanyNumber>      | ?             | 6 The Avenue           | ?                      | ?                      | ?                      | Bournemouth            | Bardford               | BH9 2UX   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    |  UKPRN  |
    | <UKPRN> |





    # Change the date
    Given the override date is '<InitialOverrideDate>'

    # Bulk file  
    And   there are no files prefixed '<UKPRN>' in the Sharepoint '<Library>' folder
    And   there are no files prefixed '<Bulkfile1>' in the Sharepoint 'Input' folder
    And   there are no files prefixed '<Bulkfile1>' in the Sharepoint 'Processing' folder
    And   there are no files prefixed '<Bulkfile1>' in the Sharepoint 'Processed' folder
    And   there are no files prefixed '<Bulkfile1>' in the Sharepoint 'Reports' folder
    And   spreadsheet '<Bulkfile1>.xlsx' exists in the Datafiles folder and UKPRN '<UKPRN>' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    #And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '<UKPRN>' for FundingType '<FundingType>' and period '<Period>'

     
   # Then  the file named '10000051_[ContractNo]_v1.pdf' in Sharepoint location '<Library>' contains the following lines in order
   # """
   # Annex H – Grant payment schedule
   # Provider: <UKPRN> Co Ltd UKPRN: <UKPRN>
   # Master Contract Number: [MasterContractNo] Start Date: 01/04/2026 End Date: 31/03/2027
   # Contract Ref: [AllocRef_CSIPF]
   # Cash (£) Apr 2026 May 2026 Jun 2026 Jul 2026 Aug 2026 Sep 2026 Oct 2026 Nov 2026 Dec 2026 Jan 2027 Feb 2027 Mar 2027
   #Construction Skills Package: Industry Placements £120,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000
   #Fund
   #Total Funding £120,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000
   #Construction Skills Package: Industry Placements Fund (CSP-IPF) 2627 – [AllocRef_CSIPF] – Page 1 Ref (for internal use only):  [ContractNo] v1
   # """

 


    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '<UKPRN>_[ContractNo]_v1.pdf' in '<Library>' is copied to 'Datafiles/Downloads' as 'S204_v1.pdf'

    
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
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate  | ContractEndDate 			| AmendmentType |
    | <UKPRN> | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | <ContractStartDate> | <ContractEndDate>      	| ?             |
    | <UKPRN> | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | <ContractStartDate> | <ContractEndDate>		| ?             |



    # Remove all details from ContractManagement.CreatedContract for a contract
 #  Given there are no created contracts for this number '[ContractNo]'
    Given there are no details in ContractManagement.CreatedContract for '[ContractNo]'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
   And   the following document creation details exist in the ContractManagement.CreatedContract table
   | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate                   |
   | [ContractNo]   | 1                     | 0                        | <CreatedDate1>                |



    # T&C document changes then Notification amendment issued 

    # Update timestamp on SB TAC document template (DocumentsDomain.UploadedDocumentTemplate) (J107)
    And the following document templates have Upload timestamps as indicated
    | DocumentTemplateName          | UploadTimestamp         |
    | <DocumentTemplateName>        | <UploadTimestamp1>      |



    # Change the date to one several days after the date of the revised TAC template
    Given the override date is '01/04/2026'

    # Issue a non-financial NOTIFICATION amendment on v1 to create v2. Only the Summary of Funding should be produced
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial notification contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial NOTIFICATION contract amendment


    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate   | ContractEndDate         | AmendmentType |
    | <UKPRN>  | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | <ContractStartDate> | <ContractEndDate>       | Notification  |
    | <UKPRN>  | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | False         | True                | <ContractStartDate> | <ContractEndDate>       | ?             |
    | <UKPRN>  | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | <ContractStartDate> | <ContractEndDate>       | ?             |




    # Retrieve parameters for the Contracting Org
   #And  I retrieve the latest EFA contract details from CRM for provider '<UKPRN>' for FundingType 'HTE-SIF' and period '2324' and Delivery Organisation '10017176'
    And   I retrieve the latest contract details from CRM for provider '<UKPRN>' for FundingType '<FundingType>' and period '<Period>'


    # Save a copy of the output
    Then  Sharepoint file '<UKPRN>_[ContractNo]_v2.pdf' in '<Library>' is copied to 'Datafiles/Downloads' as 'S204_v2.pdf'


    # Publish then withdraw the contract
    
    # Change the date
    Given the override date is '04/04/2026'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
   #And   the latest version of contract is in a state of 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Withdraw v2 of the contract 
    When  the next action performed on the latest version of contract '[ContractNo]' is 'Withdraw On Behalf Of Provider' with reason 'Test withdrawal' by 'FCS1 Test'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus  | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate   | ContractEndDate        | AmendmentType |
    | <UKPRN> | [ContractNo]       | 2                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | <ContractStartDate> | <ContractEndDate>      | Notification  |
    | <UKPRN> | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | <ContractStartDate> | <ContractEndDate>      | ?             |
    | <UKPRN> | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | <ContractStartDate> | <ContractEndDate>      | ?             |

 # Execute a NON-FINANCIAL amendment variation on v2 to create v3

 # Change the date
 Given the override date is '09/04/2026'

 # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
 And   there are no Sector-based Work Academies profile values in config for UKPRN '<UKPRN>'


 # T&C document changes then Notification amendment issued 

 # Update timestamp on SB TAC document template (DocumentsDomain.UploadedDocumentTemplate) (J107)
 And the following document templates have Upload timestamps as indicated
 | DocumentTemplateName          | UploadTimestamp         |
 | <DocumentTemplateName>        | <UploadTimestamp2>      |


 # Issue a non-financial VARIATION amendment on v1 to create v2
 When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment

 # Check the CONTRACT version, status and dates in CRM
 Then  the following contract values are present in CRM
 | UKPRN    | ContractNumber    | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate  | ContractEndDate        | AmendmentType |
 | <UKPRN> | [ContractNo]       | 3                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | <ContractStartDate> | <ContractEndDate>      | Variation     |
 | <UKPRN> | [ContractNo]       | 2                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | <ContractStartDate> | <ContractEndDate>      | Notification  |
 | <UKPRN> | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | False         | True                | <ContractStartDate> | <ContractEndDate>      | ?             |
 | <UKPRN> | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | <ContractStartDate> | <ContractEndDate>      | ?             |

#
 # Retrieve parameters
#When  I retrieve the latest EFA contract details from CRM for provider '10000018' for FundingType 'SB' and period '2023' and Delivery Organisation '00000000'
 When  I retrieve the latest contract details from CRM for provider '<UKPRN>' for FundingType '<FundingType>' and period '<Period>'

 ### Check the contents of the Appendices (SoF, TaC, Sch1, Sch2, Sch3)
 #Then  the file named '10010051_[ContractNo]_v3.pdf' in Sharepoint location '<Library>' contains the following lines in order
 #  """
 #   Annex H – Grant payment schedule
 #   Provider: <UKPRN> Co Ltd UKPRN: <UKPRN>
 #   Master Contract Number: [MasterContractNo] Start Date: 01/04/2026 End Date: 31/03/2027
 #   Contract Ref: [AllocRef_CSIPF]
 #   Cash (£) Apr 2026 May 2026 Jun 2026 Jul 2026 Aug 2026 Sep 2026 Oct 2026 Nov 2026 Dec 2026 Jan 2027 Feb 2027 Mar 2027
 #  Construction Skills Package: Industry Placements £120,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000
 #  Fund
 #  Total Funding £120,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000 £10,000
 #  Construction Skills Package: Industry Placements Fund (CSP-IPF) 2627 – [AllocRef_CSIPF] – Page 1 Ref (for internal use only):  [ContractNo] v1
 #   """


 # Save a copy of the output
 Then  Sharepoint file '<UKPRN>_[ContractNo]_v3.pdf' in '<Library>' is copied to 'Datafiles/Downloads' as 'S204_v3.pdf'


  

    Then wait '10' seconds


    # Part 7c: Payment Batch for CSPIPF

    # Change the date
    Given the override date is '<CensusEndDate> 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod '<FSP>' AccountingPaymentPeriod '<FinancialPeriod>' CensusEndDate '<CensusEndDate>' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber               | Period          |
    | [AllocRef_<AllocationPrefix>]          | <PaymentPeriod> |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period          | Census End Date/Time | LinkCodeSuffix | Status     |
    | <FSP>	                     | <PaymentPeriod>               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period          | Status    |
    | <FSP>	         	         | <PaymentPeriod>               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod '<FSP>' PaymentPeriod '<FinancialPeriod>' CensusEndDate '<CensusEndDate>' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'S204.xml'

    ## Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    #And   the Payment feed xml for FundingStreamPeriod 'ALLBC2425' PaymentPeriod '202306' CensusEndDate '09/10/2023' and LinkCodeSuffix 'A' includes the following values
    #| FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef    | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_ASCA]  | 3008.75         | RECONCILIATION   | AEB Other Learning                 | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 2372010    |
    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_ASCA]  | 980.07          | RECONCILIATION   | AEB OthLearning LngS               | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 2372060    |
    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_ASCA]  | 2567.98         | RECONCILIATION   | AdltSkll19+Hardship                | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100927     |
    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_ASCA]  | 2111.17         | RECONCILIATION   | AdltSkll20+Childcare               | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100928     |
    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_ASCA]  | 1323.40         | RECONCILIATION   | AdltSkllRsdntlAccess               | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100929     |
    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_ASCA]  | 3073.78         | RECONCILIATION   | AdltSkllAdminExp                   | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100930     |
    #| AS23                   | 2023          | 06             | 10          | ?       | [AllocRef_ASCA]  | 2023.94         | RECONCILIATION   | AdltSkllC19Response                | 2023-10-23 | 2023-08-01   | 2024-07-31 | ?              | 10018024 | 100931     |
    ##                                                                                                    £15089.09




    # CDA
    
    # Change the date
    Given the override date is '11/04/2026'
#
#    # Run the CDA report
    Given there is no CDA report named 'CDA Last Approved Version S204.csv'
    And   the following ADF Pipeline run
    When  the following CDA report is run
    | FundingStreamPeriod   | Version               | Suffix |
    | <FSP>                 | Last Approved Version | S204   |

    Then  a report named 'CDA Last Approved Version S204.csv' is created


 # Tidy Up
    And the override date is reset


Examples:
    | UKPRN   | LegalName           | UPIN  | OrgId      | CompanyNumber |  InitialOverrideDate |   AmendOverrideDate |   ContractStartDate | ContractEndDate | FSP          	| AllocationPrefix | PaymentPeriod | FinancialPeriod | CensusEndDate |  Period | Library  						| Bulkfile1   						       | FundingType | CreatedDate1            | DocumentTemplateName          | UploadTimestamp1         | UploadTimestamp2        | 
#   | 10019204| 10019204 Co Ltd     | 119204| ORG0019204 | AA019204      |  01/04/2026          |   01/11/2026        |   01/04/2026        | 31/03/2027      | CSPIPF2627	    |  CSIPF           | 202612        | 202609          | 02/12/2026    |  2627   | CSP-IPF-2627-Input-Appendices 	| CSP-IPF FY 2627 17082025105948 v1        | CSP-IPF	 | 2026-02-01 09:12:35.000 | FA_CSPIPF2627_2026-04-01.docx | 2026-02-01 22:22:22.000  | 2026-04-09 22:22:22.000 |
#   | 10019204| 10019204 Co Ltd     | 119204| ORG0019204 | AA019204      |  01/03/2025          |   01/11/2025        |   01/04/2025        | 31/03/2026      | TTFY2   	    |  TTFY2           | 202512        | 202509          | 02/12/2025    |  2526   | TTFY2-2526-Input-Appendices 	| TTFY2 FY 2526 15032025105948 v1_S204     | TTFY2 	     | 2025-04-01 09:12:35.000 | FA_TTFY22526_2025-04-01.docx  | 2025-04-01 22:22:22.000  | 2025-04-09 22:22:22.000 |
    | 10019204| 10019204 Co Ltd     | 119204| ORG0019204 | AA019204      |  01/03/2026          |   01/11/2026        |   01/04/2026        | 31/03/2027      | TTFY22526  	    |  TTFY2           | 202612        | 202609          | 02/12/2026    |  2627   | TTFY2-2627-Input-Appendices 	| TTFY2 FY 2627 15032025105948 v1_S204     | TTFY2 	     | 2025-04-01 09:12:35.000 | FA_TTFY22627_2025-04-01.docx  | 2026-04-01 22:22:22.000  | 2026-04-09 22:22:22.000 |


    
   