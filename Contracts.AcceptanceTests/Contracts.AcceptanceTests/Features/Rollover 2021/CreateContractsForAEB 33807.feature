Feature: CreateContractsForAEB 33807

@AcceptanceTest @Withdrawn20231002
Scenario: A577 Bulk load a new 2122 AEB contract. Check docs then publish and approve. Non-financial amendment then check docs. Check CRM
    
    # 1. Bulk load a new 2122AEB contract with AEB-AS2122, AEB-NSF2122 and STFI2122 allocations
    # 2. Check document parts and content
    # 3. Publish and approve v1
    # 4. Check Deliverable count is 384 (AEB-AS:10x12, AEB-NSF:10x12, STFI:12x12)
    # 5. Non-financial VARIATION amendment
    # 6. Check document parts and content
    # 7. Publish and approve v2
    # 8. Change timestamp on S1 template
    # 9. Non-financial VARIATION amendment
    # 10. Check document parts and content
 #  # 11. Publish and approve v3
 #  # 12. Change timestamp on S1 template (again)
 #  # 13. Non-financial NOTIFICATION amendment
 #  # 14. Check document parts and content
      
    Given there are no allocations marked as Under Termination for UKPRN '10017577' 
    And   there are no terminated or closed allocations for UKPRN '10017577' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017577' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017577' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017577' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEB-AS2122        |
    | AEB-NSF2122       |
    | STFI2122          |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017577'

    # Set the 'base' timestamp for each of the 21/22 AEB document templates (DocumentsDomain.UploadedDocumentTemplate) (J107) 
    And   the following document templates have Upload timestamps as indicated 
    | DocumentTemplateName                            | UploadTimestamp         | 
 #  | SOF_AEB2021_2021-08-01.docx                     | 2021-06-20 12:00:00.000 | 
 #  | AEB2021_2122_TAC_2021-08-01.docx                | 2021-06-20 12:00:00.000 | 
 #  | AEB2021_2122_S1_2021-08-01.docx                 | 2020-06-20 12:00:00.000 | 
 #  | AEB2021_2122_S2_2021-08-01.docx                 | 2020-06-20 12:00:00.000 | 
 #  | FA_AEB2021_2122_2021-08-01.docx                 | 2020-06-20 12:00:00.000 | 
 #  | AEB2021_2122_S3ON_2021-08-01.docx               | 2020-06-20 12:00:00.000 |  
    | SOF_AEB2021_2021-08-01.docx                     | 2021-06-20 12:00:00.000 |
    | AEB2021_2122_TAC_2021-08-01.docx                | 2021-06-20 12:00:00.000 |
    | AEB2021_2122_S1_2021-08-01.docx                 | 2021-06-20 12:00:00.000 |
    | AEB2021_2122_S2_2021-08-01.docx                 | 2021-06-20 12:00:00.000 |
    | FA_AEB2021_2020-08-01.docx                      | 2021-06-20 12:00:00.000 |
    | FA_AEB2021_2122_2021-08-01.docx                 | 2021-06-20 12:00:00.000 |  
    | AEB2021_2122_S3ON_2021-08-01.docx               | 2021-06-20 12:00:00.000 |


  
    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017577' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017577 Co Ltd' with UKPRN '10017577' and OrgId 'ORG0017577' and has 'FCS1 Test' as a manager 
 
    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017577 | 117577 | 10017577 Co Ltd | 0              | In Administration     | Yes           | AA017577      | ?             | 49 Lyon Meade          | Stanmore               | London                 | ?                      | ?                      | ?                      | HA7 1HZ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017577 |




    
    # Part 1: Bulk load a new 2122AEB contract with AEB-AS2122, AEB-NSF2122 and STFI2122 allocations
    
    # Change the date
    Given the override date is '01/07/2021'

    # Bulk file to create a new contract
    And   there are no files prefixed '10017577' in the Sharepoint 'AEB2021-2122-Input-Appendices' folder
    And   there are no files prefixed 'AEB2021 AY 2122 11062021150935 v3_A577' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'AEB2021 AY 2122 11062021150935 v3_A577' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'AEB2021 AY 2122 11062021150935 v3_A577' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB2021 AY 2122 11062021150935 v3_A577' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB2021 AY 2122 11062021150935 v3_A577.xlsx' exists in the Datafiles folder and UKPRN '10017577' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017577' for FundingType 'AEB2021' and period '2122' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017577' for FundingType 'AEB2021' and period '2122'

    # Check the deliverable count in CRM 
    Then  there are '120' deliverable period rows in CRM linked to the latest version of contract '[ContractNo]'
    
    # Check the contents of the Appendices
    And   the file named '10017577_[ContractNo]_v1.pdf' in Sharepoint location 'AEB2021-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING
    Organisation Name: 10017577 Co Ltd UKPRN: 10017577
    Master Contract Number: [MasterContractNo]
    Allocation
    1 August 2021 to 31 July 2022 Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 Total
    ESFA AEB - Adult Skills (procured from Aug 2021) [AllocRef_AEBA] £59,727 £25,584 £85,311
    of which Learner Support £31,424 £12,113 £43,537
    ESFA AEB - National Skills Fund (procured from Aug 2021) [AllocRef_NSF] £61,170 £34,009 £95,179
    of which Level 3 Offer for 24 year olds and over £32,999 £14,764 £47,763
    of which Learner Support £28,171 £19,245 £47,416
    ESFA AEB - Short Term Funding Initiatives (procured from
    [AllocRef_STFI] £147,389 £83,646 £231,035
    Aug 2021)
    of which Short Term Funding Initiative 1 £45,342 £25,966 £71,308
    of which Short Term Funding Initiative 2 £32,561 £16,657 £49,218
    of which Short Term Funding Initiative 3 £45,746 £23,250 £68,996
    of which Short Term Funding Initiative 4 £23,740 £17,773 £41,513
    Total: £411,525
    Total Funding for this contract: £411,525
        
    Between the Secretary of State for Education
    And 10017577 Co Ltd
    Funding for ESFA Adult Education Budget (Contract for Services)
    Master Contract Number [MasterContractNo]
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by John Edwards, Interim Chief Executive of the Education & Skills Funding Agency
    This Contract is made on the date the Contract is digitally signed by the
    Contractor on the Manage Your Education & Skills Funding Service between:
    10017577 Co Ltd THE SECRETARY OF STATE FOR
    49 Lyon Meade EDUCATION
    Stanmore DEPARTMENT FOR EDUCATION
    London 20 GREAT SMITH STREET
    AND
    HA7 1HZ LONDON
    SW1P 3BT
    Company No: AA017577
    Hereinafter called Hereinafter called
    the Contractor the Department
    ESFA Adult Education Budget (Procured) Version 3 (April 2022) - Page 2
    ESFA Adult Education Budget (Procured) Version 3 (April 2022) - Page 78

    SCHEDULE 1: SPECIFICATION & MONITORING
    ESFA ADULT EDUCATION BUDGET CONTRACT FOR SERVICES 2021/22
    ESFA Adult Education Budget (Procured) Schedule 1 Version 2 (March 2022) – Page 1
    Level 3 qualification, which is equivalent to A levels or a
    ESFA Adult Education Budget (Procured) Schedule 1 Version 2 (March 2022) – Page 12
    
    SCHEDULE 2: PAYMENT
    ESFA ADULT EDUCATION BUDGET (CONTRACT FOR SERVICES)
    ESFA Adult Education Budget (Procured) Schedule 2 Version 1 (July 2021) – Page 1
    ESFA Adult Education Budget (Procured) Schedule 2 Version 1 (July 2021) – Page 2
    
    SCHEDULE 2
    Funding Agreement – ESFA-Funded Adult Education Budget - Adult Skills (procured from Aug 2021)
    Provider: 10017577 Co Ltd UKPRN: 10017577
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_AEBA]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    ESFA AEB - Adult Skills £85,311 £3,011 £5,769 £13,891 £3,318 £6,958 £8,212 £8,180 £10,388 £3,763 £1,895 £7,500 £12,426
    of which Learner Support £43,537 £996 £4,413 £6,335 £571 £5,687 £401 £6,197 £6,824 £2,832 £1,016 £624 £7,641
    Total Funding £85,311 £3,011 £5,769 £13,891 £3,318 £6,958 £8,212 £8,180 £10,388 £3,763 £1,895 £7,500 £12,426
    Schedule 2 – Funding Agreement [AllocRef_AEBA] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 2
    Funding Agreement – ESFA-Funded Adult Education Budget - National Skills Fund (procured from Aug 2021)
    Provider: 10017577 Co Ltd UKPRN: 10017577
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_NSF]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    ESFA AEB - National Skills Fund £95,179 £11,002 £12,054 £6,788 £6,682 £4,887 £8,656 £3,189 £7,912 £7,531 £8,179 £8,348 £9,951
    of which Level 3 Offer for 24 year olds and over £47,763 £7,470 £7,014 £2,545 £5,889 £1,695 £2,597 £2,003 £3,786 £4,275 £6,536 £1,865 £2,088
    of which Learner Support £47,416 £3,532 £5,040 £4,243 £793 £3,192 £6,059 £1,186 £4,126 £3,256 £1,643 £6,483 £7,863
    Total Funding £95,179 £11,002 £12,054 £6,788 £6,682 £4,887 £8,656 £3,189 £7,912 £7,531 £8,179 £8,348 £9,951
    Schedule 2 – Funding Agreement [AllocRef_NSF] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 2
    Funding Agreement – ESFA-Funded Adult Education Budget - Short Term Funding Initiatives (procured from Aug 2021)
    Provider: 10017577 Co Ltd UKPRN: 10017577
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_STFI]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    ESFA AEB - Short Term Funding Initiative 1 £71,308 £7,452 £7,198 £7,962 £5,669 £4,597 £5,701 £2,389 £4,374 £4,257 £6,720 £7,282 £7,707
    ESFA AEB - Short Term Funding Initiative 2 £49,218 £6,433 £2,304 £4,629 £3,493 £1,062 £6,243 £6,603 £1,794 £6,158 £6,858 £1,030 £2,611
    ESFA AEB - Short Term Funding Initiative 3 £68,996 £5,818 £7,877 £5,924 £3,833 £7,994 £3,461 £3,270 £7,569 £4,735 £7,400 £5,244 £5,871
    ESFA AEB - Short Term Funding Initiative 4 £41,513 £1,879 £7,389 £1,158 £223 £3,026 £2,569 £6,051 £1,445 £5,202 £3,992 £3,398 £5,181
    Total Funding £231,035 £21,582 £24,768 £19,673 £13,218 £16,679 £17,974 £18,313 £15,182 £20,352 £24,970 £16,954 £21,370
    Schedule 2 – Funding Agreement [AllocRef_STFI] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 3: CHANGE CONTROL PROCEDURE
    ESFA Adult Education Budget (Procured) Schedule 3 Version 1 (July 2021) – Page 1
    
    SCHEDULE 4: TUPE
    TRANSFER OF UNDERTAKINGS (PROTECTION OF EMPLOYMENT)
    REGULATIONS 2006 AND PENSIONS ASPECTS
    ESFA Adult Education Budget (Procured) Schedule 4 Version 1 (July 2021) – Page 1
    ESFA Adult Education Budget (Procured) Schedule 4 Version 1 (July 2021) – Page 20
    
    SCHEDULE 5: UK GDPR AND DATA PROTECTION
    PROCESSING, PERSONAL DATA AND DATA SUBJECTS
    ESFA Adult Education Budget (Procured) Schedule 5 Version 1 (July 2021) – Page 1
    ESFA Adult Education Budget (Procured) Schedule 5 Version 1 (July 2021) – Page 2
    
    SCHEDULE 6: SECURITY & DEPARTMENT POLICIES
    ESFA Adult Education Budget (Procured) Schedule 6 Version 1 (July 2021) – Page 1
    ESFA Adult Education Budget (Procured) Schedule 6 Version 1 (July 2021) – Page 8
    
    SCHEDULE 7: EXIT ARRANGEMENTS
    ESFA Adult Education Budget (Procured) Schedule 7 Version 1 (July 2021) – Page 1
    ESFA Adult Education Budget (Procured) Schedule 7 Version 1 (July 2021) – Page 5
    
    SCHEDULE 8: SUB-CONTRACTING
    ESFA Adult Education Budget (Procured) Schedule 8 Version 1 (July 2021) – Page 1
    ESFA Adult Education Budget (Procured) Schedule 8 Version 1 (July 2021) – Page 5
    
    SCHEDULE 9: CONTRACTOR’S RESPONSE/PROPOSALS
    ESFA Adult Education Budget (Procured) Schedule 9 Version 1 (July 2021) – Page 1
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017577_[ContractNo]_v1.pdf' in 'AEB2021-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A577v1.pdf'

    # Display Sharepoint filename
    And   message '10017577_[ContractNo]_v1.pdf' is written to the Output window

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2021-07-01 09:12:35.000 |





     # Part 3: Publish and approve v1
     
     # Publish and approve the contract 
     
     # Change the date
     Given the override date is '03/07/2021'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017577 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017577 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_AEBA] | 2372010          | Jul-22 | Reconciliation |
    | [AllocRef_NSF]  | 100942           | Jul-22 | Reconciliation |
    | [AllocRef_STFI] | 2374010          | Jul-22 | Reconciliation |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '384' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Test CRM details against same in ContractManagement feed (30447)
    And   the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | P1-8     | P9-12    | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   |
    | [ContractNo]   | [AllocRef_NSF]     | 1               | 95179.00  | 61170.00 | 34009.00 | 11002.00 | 12054.00 | 6788.00  | 6682.00  | 4887.00  | 8656.00  | 3189.00  | 7912.00  | 7531.00  | 8179.00  | 8348.00  | 9951.00  | 
    | [ContractNo]   | [AllocRef_NSF]     | 2               | 47763.00  | 32999.00 | 14764.00 | 7470.00  | 7014.00  | 2545.00  | 5889.00  | 1695.00  | 2597.00  | 2003.00  | 3786.00  | 4275.00  | 6536.00  | 1865.00  | 2088.00  | 
    | [ContractNo]   | [AllocRef_NSF]     | 5               | 47416.00  | 28171.00 | 19245.00 | 3532.00  | 5040.00  | 4243.00  | 793.00   | 3192.00  | 6059.00  | 1186.00  | 4126.00  | 3256.00  | 1643.00  | 6483.00  | 7863.00  | 
    #
    | [ContractNo]   | [AllocRef_STFI]    | 1               | 71308.00  | 45342.00 | 25966.00 | 7452.00  | 7198.00  | 7962.00  | 5669.00  | 4597.00  | 5701.00  | 2389.00  | 4374.00  | 4257.00  | 6720.00  | 7282.00  | 7707.00  | 
    | [ContractNo]   | [AllocRef_STFI]    | 2               | 49218.00  | 32561.00 | 16657.00 | 6433.00  | 2304.00  | 4629.00  | 3493.00  | 1062.00  | 6243.00  | 6603.00  | 1794.00  | 6158.00  | 6858.00  | 1030.00  | 2611.00  | 
    | [ContractNo]   | [AllocRef_STFI]    | 3               | 68996.00  | 45746.00 | 23250.00 | 5818.00  | 7877.00  | 5924.00  | 3833.00  | 7994.00  | 3461.00  | 3270.00  | 7569.00  | 4735.00  | 7400.00  | 5244.00  | 5871.00  | 
    | [ContractNo]   | [AllocRef_STFI]    | 4               | 41513.00  | 23740.00 | 17773.00 | 1879.00  | 7389.00  | 1158.00  | 223.00   | 3026.00  | 2569.00  | 6051.00  | 1445.00  | 5202.00  | 3992.00  | 3398.00  | 5181.00  | 
    #
    | [ContractNo]   | [AllocRef_AEBA]    | 1               | 85311.00  | 59727.00 | 25584.00 | 3011.00  | 5769.00  | 13891.00 | 3318.00  | 6958.00  | 8212.00  | 8180.00  | 10388.00 | 3763.00  | 1895.00  | 7500.00  | 12426.00 | 
    | [ContractNo]   | [AllocRef_AEBA]    | 4               | 41774.00  | 28303.00 | 13471.00 | 2015.00  | 1356.00  | 7556.00  | 2747.00  | 1271.00  | 7811.00  | 1983.00  | 3564.00  | 931.00   | 879.00   | 6876.00  | 4785.00  | 
    | [ContractNo]   | [AllocRef_AEBA]    | 5               | 43537.00  | 31424.00 | 12113.00 | 996.00   | 4413.00  | 6335.00  | 571.00   | 5687.00  | 401.00   | 6197.00  | 6824.00  | 2832.00  | 1016.00  | 624.00   | 7641.00  | 





    # Part 5: Non-financial VARIATION amendment
    
    # NFA amendment then check doc parts (No doc templates have changed since v1 was generated)

    Given the override date is '04/07/2021'

    # Issue a non-financial VARIATION amendment on v1 to create v2
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM.
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017577 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017577 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017577 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the contents of the Appendices  (Only SoF)
    Then  the file named '10017577_[ContractNo]_v2.pdf' in Sharepoint location 'AEB2021-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING
    Organisation Name: 10017577 Co Ltd UKPRN: 10017577
    Master Contract Number: [MasterContractNo]
    Allocation
    1 August 2021 to 31 July 2022 Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 Total
    ESFA AEB - Adult Skills (procured from Aug 2021) [AllocRef_AEBA] £59,727 £25,584 £85,311
    of which Learner Support £31,424 £12,113 £43,537
    ESFA AEB - National Skills Fund (procured from Aug 2021) [AllocRef_NSF] £61,170 £34,009 £95,179
    of which Level 3 Offer for 24 year olds and over £32,999 £14,764 £47,763
    of which Learner Support £28,171 £19,245 £47,416
    ESFA AEB - Short Term Funding Initiatives (procured from
    [AllocRef_STFI] £147,389 £83,646 £231,035
    Aug 2021)
    of which Short Term Funding Initiative 1 £45,342 £25,966 £71,308
    of which Short Term Funding Initiative 2 £32,561 £16,657 £49,218
    of which Short Term Funding Initiative 3 £45,746 £23,250 £68,996
    of which Short Term Funding Initiative 4 £23,740 £17,773 £41,513
    Total: £411,525
    Total Funding for this contract: £411,525
    """
    
    # There shouldn't be a T&C doc
    And   the pdf file does not contain the following text
    """
    Agreement Type Contract for Services
    """

    # There shouldn't be a Sch1 doc
    And   the pdf file does not contain the following text
    """
    SCHEDULE 1: SPECIFICATION & MONITORING
    """

    # There shouldn't be a Sch2 doc
    And   the pdf file does not contain the following text
    """  
    SCHEDULE 2: PAYMENT
    """
    
    # There shouldn't be a Sch3ON doc
    And   the pdf file does not contain the following text
    """  
    SCHEDULE 3: NOT USED
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017577_[ContractNo]_v2.pdf' in 'AEB2021-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A577v2.pdf'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 2                     | 0                        | 2021-07-04 09:12:35.000 |




     # Publish and approve the contract 
     
     # Change the date
     Given the override date is '05/07/2021'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017577 | [ContractNo]       | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017577 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017577 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |





    # Part 8: Change timestamp on S1 template
    
    # Change the date
    Given the override date is '05/02/2022'
    
    # Updatebase timestamp on S1 template to a date after the latest contract was created (DocumentsDomain.UploadedDocumentTemplate) (J107) 
    And   the following document templates have Upload timestamps as indicated 
    | DocumentTemplateName                            | UploadTimestamp         | 
    | SOF_AEB2021_2021-08-01.docx                     | 2021-06-20 12:00:00.000 |
    | AEB2021_2122_TAC_2021-08-01.docx                | 2021-06-20 12:00:00.000 |
    | AEB2021_2122_S1_2021-08-01.docx                 | 2022-02-05 12:23:45.000 |
    | AEB2021_2122_S2_2021-08-01.docx                 | 2021-06-20 12:00:00.000 |
    | FA_AEB2021_2020-08-01.docx                      | 2021-06-20 12:00:00.000 |
    | FA_AEB2021_2122_2021-08-01.docx                 | 2021-06-20 12:00:00.000 |  
    | AEB2021_2122_S3ON_2021-08-01.docx               | 2021-06-20 12:00:00.000 |
 
    
  
  

    # Part 9: Non-financial VARIATION amendment
    
    # NFA amendment then check doc parts 

    Given the override date is '08/02/2022'

    # Issue a non-financial VARIATION amendment on v2 to create v3
    When  a request is raised by advisor 'FCS2 Test' against version '2' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM.
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017577 | [ContractNo]       | 3                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017577 | [ContractNo]       | 2                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017577 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017577 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the contents of the Appendices  (Only SoF and Sch 1)
    Then  the file named '10017577_[ContractNo]_v3.pdf' in Sharepoint location 'AEB2021-2122-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING
    Organisation Name: 10017577 Co Ltd UKPRN: 10017577
    Master Contract Number: [MasterContractNo]
    Allocation
    1 August 2021 to 31 July 2022 Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 Total
    ESFA AEB - Adult Skills (procured from Aug 2021) [AllocRef_AEBA] £59,727 £25,584 £85,311
    of which Learner Support £31,424 £12,113 £43,537
    ESFA AEB - National Skills Fund (procured from Aug 2021) [AllocRef_NSF] £61,170 £34,009 £95,179
    of which Level 3 Offer for 24 year olds and over £32,999 £14,764 £47,763
    of which Learner Support £28,171 £19,245 £47,416
    ESFA AEB - Short Term Funding Initiatives (procured from
    [AllocRef_STFI] £147,389 £83,646 £231,035
    Aug 2021)
    of which Short Term Funding Initiative 1 £45,342 £25,966 £71,308
    of which Short Term Funding Initiative 2 £32,561 £16,657 £49,218
    of which Short Term Funding Initiative 3 £45,746 £23,250 £68,996
    of which Short Term Funding Initiative 4 £23,740 £17,773 £41,513
    Total: £411,525
    Total Funding for this contract: £411,525

    SCHEDULE 1: SPECIFICATION & MONITORING
    ESFA ADULT EDUCATION BUDGET CONTRACT FOR SERVICES 2021/22
    ESFA Adult Education Budget (Procured) Schedule 1 Version 2 (March 2022) – Page 1
    ESFA Adult Education Budget (Procured) Schedule 1 Version 2 (March 2022) – Page 12
    """
    
    # There shouldn't be a T&C doc
    And   the pdf file does not contain the following text
    """
    Agreement Type Contract for Services
    """

    # There shouldn't be a Sch2 doc
    And   the pdf file does not contain the following text
    """  
    SCHEDULE 2: PAYMENT
    """
    
    # There shouldn't be a Sch3ON doc
    And   the pdf file does not contain the following text
    """  
    SCHEDULE 3: NOT USED
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017577_[ContractNo]_v3.pdf' in 'AEB2021-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A577v3.pdf'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 3                     | 0                        | 2022-02-08 09:12:35.000 |




#     # Publish and approve v3
#     
#     # Change the date
#     Given the override date is '10/02/2022'
#
#    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
#    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'
#
#    # Month end is not running
#    And   the PaaS MonthEndIsRunning indicator is set to 'False'
#
#    # Inject an SFS approval message 
#    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '3'
#
#    # Check that the contract is now approved
#    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'
#
#    # Check the CONTRACT version, status and dates in CRM.
#    And   the following contract values are present in CRM
#    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
#    | 10017577 | [ContractNo]       | 3                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | Variation     |
#    | 10017577 | [ContractNo]       | 2                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2021        | 31/07/2022      | Variation     |
#    | 10017577 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
#    | 10017577 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
#
#
#
#
#
#    # Part 12: Change timestamp on S1 template (again)
#    
#    # Change the date
#    Given the override date is '05/03/2022'
#    
#    # Updatebase timestamp on S1 template to a date after the latest contract was created (DocumentsDomain.UploadedDocumentTemplate) (J107) 
#    And   the following document templates have Upload timestamps as indicated 
#    | DocumentTemplateName                            | UploadTimestamp         | 
#    | SOF_AEB2021_2021-08-01.docx                     | 2021-06-20 12:00:00.000 |
#    | AEB2021_2122_TAC_2021-08-01.docx                | 2021-06-20 12:00:00.000 |
#    | AEB2021_2122_S1_2021-08-01.docx                 | 2022-03-05 12:23:45.000 |
#    | AEB2021_2122_S2_2021-08-01.docx                 | 2021-06-20 12:00:00.000 |
#    | FA_AEB2021_2020-08-01.docx                      | 2021-06-20 12:00:00.000 |
#    | FA_AEB2021_2122_2021-08-01.docx                 | 2021-06-20 12:00:00.000 |  
#    | AEB2021_2122_S3ON_2021-08-01.docx               | 2021-06-20 12:00:00.000 |
#
#
#
#
#    # Part 13: Non-financial NOTIFICATION amendment
#    
#    # NFA amendment then check doc parts 
#
#    Given the override date is '15/03/2022'
#
#    # Issue a non-financial NOTIFICATION amendment on v3 to create v4
#    When  a request is raised by advisor 'FCS2 Test' against version '3' subversion '0' of contract '[ContractNo]' for a non-financial NOTIFICATION contract amendment
#
#    # Check the CONTRACT version, status and dates in CRM.
#    Then  the following contract values are present in CRM
#    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
#    | 10017577 | [ContractNo]       | 4                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2021        | 31/07/2022      | Notification  |
#    | 10017577 | [ContractNo]       | 3                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2021        | 31/07/2022      | Variation     |
#    | 10017577 | [ContractNo]       | 2                     | 0                        | Replaced         | Approved                  | False         | True                | 01/08/2021        | 31/07/2022      | Variation     |
#    | 10017577 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
#    | 10017577 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
#
#    # Check the contents of the Appendices  (Only SoF)
#    Then  the file named '10017577_[ContractNo]_v4.pdf' in Sharepoint location 'AEB2021-2122-Input-Appendices' contains the following lines in order
#    """
#    SUMMARY OF FUNDING
#    Organisation Name: 10017577 Co Ltd UKPRN: 10017577
#    Master Contract Number: [MasterContractNo]
#    Allocation
#    1 August 2021 to 31 July 2022 Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 Total
#    ESFA AEB - Adult Skills (procured from Aug 2021) [AllocRef_AEBA] £59,727 £25,584 £85,311
#    of which Learner Support £31,424 £12,113 £43,537
#    ESFA AEB - National Skills Fund (procured from Aug 2021) [AllocRef_NSF] £61,170 £34,009 £95,179
#    of which Level 3 Offer for 24 year olds and over £32,999 £14,764 £47,763
#    of which Learner Support £28,171 £19,245 £47,416
#    ESFA AEB - Short Term Funding Initiatives (procured from
#    [AllocRef_STFI] £147,389 £83,646 £231,035
#    Aug 2021)
#    of which Short Term Funding Initiative 1 £45,342 £25,966 £71,308
#    of which Short Term Funding Initiative 2 £32,561 £16,657 £49,218
#    of which Short Term Funding Initiative 3 £45,746 £23,250 £68,996
#    of which Short Term Funding Initiative 4 £23,740 £17,773 £41,513
#    Total: £411,525
#    Total Funding for this contract: £411,525
#    """
#    
#    # There shouldn't be a T&C doc
#    And   the pdf file does not contain the following text
#    """
#    Agreement Type Contract for Services
#    """
#
#    # There shouldn't be a Sch1 doc
#    And   the pdf file does not contain the following text
#    """
#    SCHEDULE 1: SPECIFICATION & MONITORING
#    """
#
#    # There shouldn't be a Sch2 doc
#    And   the pdf file does not contain the following text
#    """  
#    SCHEDULE 2: PAYMENT
#    """
#    
#    # There shouldn't be a Sch3ON doc
#    And   the pdf file does not contain the following text
#    """  
#    SCHEDULE 3: NOT USED
#    """
#
#    # Copy\Save a named Sharepoint file to a named folder\filename
#    And   Sharepoint file '10017577_[ContractNo]_v4.pdf' in 'AEB2021-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A577v4.pdf'


    # Tidy Up
    And   the override date is reset

@AcceptanceTest @Withdrawn20231002
Scenario: A578 Create and approve a new 2122 AEB contract with AEB-AS, AEB-NSF and STFI allocs. Add actuals. Payment Batch. CDA. Check CRM, PaaS and Feed
    
    # 1. Create and approve AEB2122 contract with AEB-AS, AEB-NSF and STFI allocations
    # 2. Check deliverable count = 384
    # 3. Check CRM subnominals and contents of CM feed
    # 4. Run and check CDA
    # 5. Add actuals for each of the three Allocations
    # 6. Check CRM financials and subnominals (inc Capping)
    # 7. Run payment batch and check payment feed
    
    Given there are no allocations marked as Under Termination for UKPRN '10017578' 
    And   there are no terminated or closed allocations for UKPRN '10017578' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017578' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017578' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017578' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AEBA-578      |
    | NSF-578       |
    | STFI-578      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | AEBA-578      |
    | NSF-578       |
    | STFI-578      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEB-AS2122        |
    | AEB-NSF2122       |
    | STFI2122          |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | AEBP21-578     | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017578'




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017578' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017578 Co Ltd' with UKPRN '10017578' and OrgId 'ORG0017578' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017578' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017578 | 117578 | 10017578 Co Ltd | 0              | Active                | Yes           | AA017578      | ?             | 43 Roebuck Court       | Lower Broadway         | ?                      | ?                      | Didcot                 | Oxfordshire            | OX11 4UE  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017578 |





    # Change the date
    Given the override date is '01/07/2021'

    # Remove all contract details from ContractManagement.CreatedContract
    And   there are no details in ContractManagement.CreatedContract for 'AEBP21-578'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017578 | 10017578 Co Ltd      | ESFA-578             | AEBP21-578     | 1                     | 01/08/2021        | 31/07/2022      | 165327.00     |                                       | Contract for Services                      | 2122   | New          | ORG0017578 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017578 | AEBP21-578     | AEBA-578      | AEB-AS            | AEB-AS2122              | AY                      | 01/08/2021          | 31/07/2022        | 43874.00        |                                         |            |                                                             | New          |             |
    | 10017578 | AEBP21-578     | NSF-578       | AEB-NSF           | AEB-NSF2122             | AY                      | 01/08/2021          | 31/07/2022        | 37259.00        |                                         |            |                                                             | New          |             |
    | 10017578 | AEBP21-578     | STFI-578      | STFI              | STFI2122                | AY                      | 01/08/2021          | 31/07/2022        | 84194.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017578 | AEBP21-578     | AEBA-578      | 1               | 0                     | 43874.00  | 32264.00  | 11610.00  | 3218.00  | 3203.00  | 4230.00  | 4848.00  | 3978.00  | 2887.00  | 5180.00  | 4720.00  | 6098.00  | 1212.00  | 3786.00  | 514.00   | Adult Skills Total Funding                                      | New          |             | 
    | 10017578 | AEBP21-578     | AEBA-578      | 4               | 1                     | 23658.00  | 17280.00  | 6378.00   | 1401.00  | 2389.00  | 3125.00  | 1900.00  | 1875.00  | 966.00   | 3694.00  | 1930.00  | 3520.00  | 714.00   | 1732.00  | 412.00   | Adult Skills                                                    | New          |             | 
    | 10017578 | AEBP21-578     | AEBA-578      | 5               | 1                     | 20216.00  | 14984.00  | 5232.00   | 1817.00  | 814.00   | 1105.00  | 2948.00  | 2103.00  | 1921.00  | 1486.00  | 2790.00  | 2578.00  | 498.00   | 2054.00  | 102.00   | Adult Skills Learner Support                                    | New          |             | 
    #
    | 10017578 | AEBP21-578     | NSF-578       | 1               | 0                     | 37259.00  | 22341.00  | 14918.00  | 3951.00  | 1405.00  | 3605.00  | 3427.00  | 3729.00  | 3807.00  | 853.00   | 1564.00  | 5848.00  | 2132.00  | 3160.00  | 3778.00  | National Skills Fund Total Funding                              | New          |             | 
    | 10017578 | AEBP21-578     | NSF-578       | 2               | 1                     | 16017.00  | 10701.00  | 5316.00   | 994.00   | 717.00   | 1548.00  | 1775.00  | 2828.00  | 653.00   | 757.00   | 1429.00  | 2131.00  | 1760.00  | 154.00   | 1271.00  | Level 3 Offer for 24 year olds and over                         | New          |             | 
    | 10017578 | AEBP21-578     | NSF-578       | 5               | 1                     | 21242.00  | 11640.00  | 9602.00   | 2957.00  | 688.00   | 2057.00  | 1652.00  | 901.00   | 3154.00  | 96.00    | 135.00   | 3717.00  | 372.00   | 3006.00  | 2507.00  | National Skills Fund Learner Support                            | New          |             | 
    #
    | 10017578 | AEBP21-578     | STFI-578      | 1               | 0                     | 19601.00  | 12762.00  | 6839.00   | 1176.00  | 3335.00  | 558.00   | 504.00   | 1650.00  | 1912.00  | 2110.00  | 1517.00  | 3296.00  | 677.00   | 148.00   | 2718.00  | Short Term Funding Initiative 1                                 | New          |             | 
    | 10017578 | AEBP21-578     | STFI-578      | 2               | 0                     | 24885.00  | 18097.00  | 6788.00   | 3471.00  | 3639.00  | 1400.00  | 3432.00  | 56.00    | 1045.00  | 1781.00  | 3273.00  | 531.00   | 3323.00  | 2349.00  | 585.00   | Short Term Funding Initiative 2                                 | New          |             | 
    | 10017578 | AEBP21-578     | STFI-578      | 3               | 0                     | 19831.00  | 15056.00  | 4775.00   | 3049.00  | 2961.00  | 1261.00  | 3642.00  | 1182.00  | 178.00   | 470.00   | 2313.00  | 485.00   | 1285.00  | 850.00   | 2155.00  | Short Term Funding Initiative 3                                 | New          |             | 
    | 10017578 | AEBP21-578     | STFI-578      | 4               | 0                     | 19877.00  | 13852.00  | 6025.00   | 2705.00  | 625.00   | 2182.00  | 230.00   | 3368.00  | 3091.00  | 220.00   | 1431.00  | 2483.00  | 309.00   | 3131.00  | 102.00   | Short Term Funding Initiative 4                                 | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | AEBP21-578     | 1                     | 0                        | 2021-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'AEBP21-578'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-578' and actual ContractNumber 'AEBP21-578'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP21-578' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017578 | AEBP21-578         | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017578 | ESFA-578           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'AEBP21-578' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '384' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '384' deliverable period rows in CRM linked to the latest version of contract 'AEBP21-578'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | AEBA-578        | 2372010          | Jul-22 | Reconciliation |
    | NSF-578         | 100942           | Jul-22 | Reconciliation |
    | STFI-578        | 2374010          | Jul-22 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '10' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                           | DeliverableDescription     | 
    | 10017578 | AEBP21-578     | 1               | AEBA-578      | 1               | 0                     | 43874.00     | 0             | 0        | Adult Skills Total Funding                | ?                          |
    | 10017578 | AEBP21-578     | 1               | AEBA-578      | 4               | 1                     | 23658.00     | 0             | 0        | Adult Skills                              | ?                          |
    | 10017578 | AEBP21-578     | 1               | AEBA-578      | 5               | 1                     | 20216.00     | 0             | 0        | Adult Skills Learner Support              | ?                          |
    #
    | 10017578 | AEBP21-578     | 1               | NSF-578       | 1               | 0                     | 37259.00     | 0             | 0        | National Skills Fund Total Funding        | ?                          |
    | 10017578 | AEBP21-578     | 1               | NSF-578       | 2               | 1                     | 16017.00     | 0             | 0        | Level 3 Offer for 24 year olds and over   | ?                          |
    | 10017578 | AEBP21-578     | 1               | NSF-578       | 5               | 1                     | 21242.00     | 0             | 0        | National Skills Fund Learner Support      | ?                          |
    #
    | 10017578 | AEBP21-578     | 1               | STFI-578      | 1               | 0                     | 19601.00     | 0             | 0        | Short Term Funding Initiative 1           | ?                          |
    | 10017578 | AEBP21-578     | 1               | STFI-578      | 2               | 0                     | 24885.00     | 0             | 0        | Short Term Funding Initiative 2           | ?                          |
    | 10017578 | AEBP21-578     | 1               | STFI-578      | 3               | 0                     | 19831.00     | 0             | 0        | Short Term Funding Initiative 3           | ?                          |
    | 10017578 | AEBP21-578     | 1               | STFI-578      | 4               | 0                     | 19877.00     | 0             | 0        | Short Term Funding Initiative 4           | ?                          |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract 'AEBP21-578' agree with the most recent entry for this contract in the ContractManagement feed





#    # CDA
#    
#    # Change the date
#    Given the override date is '23/08/2021'
#
#    # Run the CDA report
#    Given there is no CDA report named 'CDA Latest Version A578.csv'
#
#    And   the following contracts are in the replicated CRM database
#    | ContractNumber | ContractVersionNumber |
#    | AEBP21-578     | 1                     |
#
#    When  the following CDA report is run
#    | FundingStreamPeriod             | Version               | Suffix |
#    | AEB-AS2122,AEB-NSF2122,STFI2122 | Latest Version        | A578   |
#
#    Then  a report named 'CDA Latest Version A578.csv' is created
#
#    # Check the contents of the CDA report
#    And   the following rows are present in the report
#    | FundingStreamPeriodCode | UKPRN    | ProviderName                | DeliveryUKPRN | DeliveryProviderName        | ContractAllocationNumber | ContractNumber | MasterContractReference | ContractAllocationStartDate | ContractAllocationEndDate | ContractVersionNumber | ContractStatus | ContractSubStatus       | DeliverableDescription                               | Deliverable                                                     | DeliverableParent                                               | DeliverablePeriod | DeliverableYear | FinancialYear | PlanningUnit | PlannedValue | ActualEarned | PlannedVolume | ActualVolume | PayableDeliverable | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | TotalNetPayment | PaymentHeld | PaymentPosted | UnitOfProcurement | LEP    | SubnominalProfile | SubnominalReconciliation | SubnominalCapping | DeliverableMonth |
#    | AEB-AS2122              | 10017578 | 10017578 Co Ltd             |               |                             | AEBA-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Adult Skills                                                    | Adult Skills Total Funding                                      | 8                 | 2021            | 2021/22       |              | 1401         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Aug              |
#    | AEB-AS2122              | 10017578 | 10017578 Co Ltd             |               |                             | AEBA-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Adult Skills                                                    | Adult Skills Total Funding                                      | 9                 | 2021            | 2021/22       |              | 2389         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Sep              |
#    | AEB-AS2122              | 10017578 | 10017578 Co Ltd             |               |                             | AEBA-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Adult Skills                                                    | Adult Skills Total Funding                                      | 10                | 2021            | 2021/22       |              | 3125         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Oct              |
#    | AEB-AS2122              | 10017578 | 10017578 Co Ltd             |               |                             | AEBA-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Adult Skills                                                    | Adult Skills Total Funding                                      | 11                | 2021            | 2021/22       |              | 1900         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Nov              |
#    | AEB-AS2122              | 10017578 | 10017578 Co Ltd             |               |                             | AEBA-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Adult Skills                                                    | Adult Skills Total Funding                                      | 12                | 2021            | 2021/22       |              | 1875         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Dec              |
#    | AEB-AS2122              | 10017578 | 10017578 Co Ltd             |               |                             | AEBA-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Adult Skills                                                    | Adult Skills Total Funding                                      | 1                 | 2022            | 2021/22       |              | 966          |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jan              |
#    | AEB-AS2122              | 10017578 | 10017578 Co Ltd             |               |                             | AEBA-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Adult Skills                                                    | Adult Skills Total Funding                                      | 2                 | 2022            | 2021/22       |              | 3694         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Feb              |
#    | AEB-AS2122              | 10017578 | 10017578 Co Ltd             |               |                             | AEBA-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Adult Skills                                                    | Adult Skills Total Funding                                      | 3                 | 2022            | 2021/22       |              | 1930         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Mar              |
#    | AEB-AS2122              | 10017578 | 10017578 Co Ltd             |               |                             | AEBA-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Adult Skills                                                    | Adult Skills Total Funding                                      | 4                 | 2022            | 2022/23       |              | 3520         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Apr              |
#    | AEB-AS2122              | 10017578 | 10017578 Co Ltd             |               |                             | AEBA-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Adult Skills                                                    | Adult Skills Total Funding                                      | 5                 | 2022            | 2022/23       |              | 714          |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | May              |
#    | AEB-AS2122              | 10017578 | 10017578 Co Ltd             |               |                             | AEBA-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Adult Skills                                                    | Adult Skills Total Funding                                      | 6                 | 2022            | 2022/23       |              | 1732         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jun              |
#    | AEB-AS2122              | 10017578 | 10017578 Co Ltd             |               |                             | AEBA-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Adult Skills                                                    | Adult Skills Total Funding                                      | 7                 | 2022            | 2022/23       |              | 412          |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jul              |
#    | AEB-AS2122              | 10017578 | 10017578 Co Ltd             |               |                             | AEBA-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Adult Skills Learner Support                                    | Adult Skills Total Funding                                      | 8                 | 2021            | 2021/22       |              | 1817         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Aug              |
#    | AEB-AS2122              | 10017578 | 10017578 Co Ltd             |               |                             | AEBA-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Adult Skills Learner Support                                    | Adult Skills Total Funding                                      | 9                 | 2021            | 2021/22       |              | 814          |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Sep              |
#    | AEB-AS2122              | 10017578 | 10017578 Co Ltd             |               |                             | AEBA-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Adult Skills Learner Support                                    | Adult Skills Total Funding                                      | 10                | 2021            | 2021/22       |              | 1105         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Oct              |
#    | AEB-AS2122              | 10017578 | 10017578 Co Ltd             |               |                             | AEBA-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Adult Skills Learner Support                                    | Adult Skills Total Funding                                      | 11                | 2021            | 2021/22       |              | 2948         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Nov              |
#    | AEB-AS2122              | 10017578 | 10017578 Co Ltd             |               |                             | AEBA-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Adult Skills Learner Support                                    | Adult Skills Total Funding                                      | 12                | 2021            | 2021/22       |              | 2103         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Dec              |
#    | AEB-AS2122              | 10017578 | 10017578 Co Ltd             |               |                             | AEBA-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Adult Skills Learner Support                                    | Adult Skills Total Funding                                      | 1                 | 2022            | 2021/22       |              | 1921         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jan              |
#    | AEB-AS2122              | 10017578 | 10017578 Co Ltd             |               |                             | AEBA-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Adult Skills Learner Support                                    | Adult Skills Total Funding                                      | 2                 | 2022            | 2021/22       |              | 1486         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Feb              |
#    | AEB-AS2122              | 10017578 | 10017578 Co Ltd             |               |                             | AEBA-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Adult Skills Learner Support                                    | Adult Skills Total Funding                                      | 3                 | 2022            | 2021/22       |              | 2790         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Mar              |
#    | AEB-AS2122              | 10017578 | 10017578 Co Ltd             |               |                             | AEBA-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Adult Skills Learner Support                                    | Adult Skills Total Funding                                      | 4                 | 2022            | 2022/23       |              | 2578         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Apr              |
#    | AEB-AS2122              | 10017578 | 10017578 Co Ltd             |               |                             | AEBA-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Adult Skills Learner Support                                    | Adult Skills Total Funding                                      | 5                 | 2022            | 2022/23       |              | 498          |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | May              |
#    | AEB-AS2122              | 10017578 | 10017578 Co Ltd             |               |                             | AEBA-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Adult Skills Learner Support                                    | Adult Skills Total Funding                                      | 6                 | 2022            | 2022/23       |              | 2054         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jun              |
#    | AEB-AS2122              | 10017578 | 10017578 Co Ltd             |               |                             | AEBA-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Adult Skills Learner Support                                    | Adult Skills Total Funding                                      | 7                 | 2022            | 2022/23       |              | 102          |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jul              |
#    #
#    | AEB-NSF2122             | 10017578 | 10017578 Co Ltd             |               |                             | NSF-578                  | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Level 3 Offer for 24 year olds and over                         | National Skills Fund Total Funding                              | 8                 | 2021            | 2021/22       |              | 994          |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Aug              |
#    | AEB-NSF2122             | 10017578 | 10017578 Co Ltd             |               |                             | NSF-578                  | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Level 3 Offer for 24 year olds and over                         | National Skills Fund Total Funding                              | 9                 | 2021            | 2021/22       |              | 717          |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Sep              |
#    | AEB-NSF2122             | 10017578 | 10017578 Co Ltd             |               |                             | NSF-578                  | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Level 3 Offer for 24 year olds and over                         | National Skills Fund Total Funding                              | 10                | 2021            | 2021/22       |              | 1548         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Oct              |
#    | AEB-NSF2122             | 10017578 | 10017578 Co Ltd             |               |                             | NSF-578                  | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Level 3 Offer for 24 year olds and over                         | National Skills Fund Total Funding                              | 11                | 2021            | 2021/22       |              | 1775         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Nov              |
#    | AEB-NSF2122             | 10017578 | 10017578 Co Ltd             |               |                             | NSF-578                  | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Level 3 Offer for 24 year olds and over                         | National Skills Fund Total Funding                              | 12                | 2021            | 2021/22       |              | 2828         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Dec              |
#    | AEB-NSF2122             | 10017578 | 10017578 Co Ltd             |               |                             | NSF-578                  | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Level 3 Offer for 24 year olds and over                         | National Skills Fund Total Funding                              | 1                 | 2022            | 2021/22       |              | 653          |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jan              |
#    | AEB-NSF2122             | 10017578 | 10017578 Co Ltd             |               |                             | NSF-578                  | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Level 3 Offer for 24 year olds and over                         | National Skills Fund Total Funding                              | 2                 | 2022            | 2021/22       |              | 757          |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Feb              |
#    | AEB-NSF2122             | 10017578 | 10017578 Co Ltd             |               |                             | NSF-578                  | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Level 3 Offer for 24 year olds and over                         | National Skills Fund Total Funding                              | 3                 | 2022            | 2021/22       |              | 1429         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Mar              |
#    | AEB-NSF2122             | 10017578 | 10017578 Co Ltd             |               |                             | NSF-578                  | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Level 3 Offer for 24 year olds and over                         | National Skills Fund Total Funding                              | 4                 | 2022            | 2022/23       |              | 2131         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Apr              |
#    | AEB-NSF2122             | 10017578 | 10017578 Co Ltd             |               |                             | NSF-578                  | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Level 3 Offer for 24 year olds and over                         | National Skills Fund Total Funding                              | 5                 | 2022            | 2022/23       |              | 1760         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | May              |
#    | AEB-NSF2122             | 10017578 | 10017578 Co Ltd             |               |                             | NSF-578                  | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Level 3 Offer for 24 year olds and over                         | National Skills Fund Total Funding                              | 6                 | 2022            | 2022/23       |              | 154          |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jun              |
#    | AEB-NSF2122             | 10017578 | 10017578 Co Ltd             |               |                             | NSF-578                  | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Level 3 Offer for 24 year olds and over                         | National Skills Fund Total Funding                              | 7                 | 2022            | 2022/23       |              | 1271         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jul              |
#    | AEB-NSF2122             | 10017578 | 10017578 Co Ltd             |               |                             | NSF-578                  | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | National Skills Fund Learner Support                            | National Skills Fund Total Funding                              | 8                 | 2021            | 2021/22       |              | 2957         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Aug              |
#    | AEB-NSF2122             | 10017578 | 10017578 Co Ltd             |               |                             | NSF-578                  | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | National Skills Fund Learner Support                            | National Skills Fund Total Funding                              | 9                 | 2021            | 2021/22       |              | 688          |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Sep              |
#    | AEB-NSF2122             | 10017578 | 10017578 Co Ltd             |               |                             | NSF-578                  | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | National Skills Fund Learner Support                            | National Skills Fund Total Funding                              | 10                | 2021            | 2021/22       |              | 2057         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Oct              |
#    | AEB-NSF2122             | 10017578 | 10017578 Co Ltd             |               |                             | NSF-578                  | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | National Skills Fund Learner Support                            | National Skills Fund Total Funding                              | 11                | 2021            | 2021/22       |              | 1652         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Nov              |
#    | AEB-NSF2122             | 10017578 | 10017578 Co Ltd             |               |                             | NSF-578                  | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | National Skills Fund Learner Support                            | National Skills Fund Total Funding                              | 12                | 2021            | 2021/22       |              | 901          |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Dec              |
#    | AEB-NSF2122             | 10017578 | 10017578 Co Ltd             |               |                             | NSF-578                  | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | National Skills Fund Learner Support                            | National Skills Fund Total Funding                              | 1                 | 2022            | 2021/22       |              | 3154         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jan              |
#    | AEB-NSF2122             | 10017578 | 10017578 Co Ltd             |               |                             | NSF-578                  | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | National Skills Fund Learner Support                            | National Skills Fund Total Funding                              | 2                 | 2022            | 2021/22       |              | 96           |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Feb              |
#    | AEB-NSF2122             | 10017578 | 10017578 Co Ltd             |               |                             | NSF-578                  | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | National Skills Fund Learner Support                            | National Skills Fund Total Funding                              | 3                 | 2022            | 2021/22       |              | 135          |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Mar              |
#    | AEB-NSF2122             | 10017578 | 10017578 Co Ltd             |               |                             | NSF-578                  | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | National Skills Fund Learner Support                            | National Skills Fund Total Funding                              | 4                 | 2022            | 2022/23       |              | 3717         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Apr              |
#    | AEB-NSF2122             | 10017578 | 10017578 Co Ltd             |               |                             | NSF-578                  | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | National Skills Fund Learner Support                            | National Skills Fund Total Funding                              | 5                 | 2022            | 2022/23       |              | 372          |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | May              |
#    | AEB-NSF2122             | 10017578 | 10017578 Co Ltd             |               |                             | NSF-578                  | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | National Skills Fund Learner Support                            | National Skills Fund Total Funding                              | 6                 | 2022            | 2022/23       |              | 3006         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jun              |
#    | AEB-NSF2122             | 10017578 | 10017578 Co Ltd             |               |                             | NSF-578                  | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | National Skills Fund Learner Support                            | National Skills Fund Total Funding                              | 7                 | 2022            | 2022/23       |              | 2507         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jul              |
#    #
#    | STFI2122                | 10017578 | 10017578 Co Ltd             |               |                             | STFI-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Short Term Funding Initiative 1                                 |                                                                 | 8                 | 2021            | 2021/22       |              | 1176         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Aug              |
#    | STFI2122                | 10017578 | 10017578 Co Ltd             |               |                             | STFI-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Short Term Funding Initiative 1                                 |                                                                 | 9                 | 2021            | 2021/22       |              | 3335         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Sep              |
#    | STFI2122                | 10017578 | 10017578 Co Ltd             |               |                             | STFI-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Short Term Funding Initiative 1                                 |                                                                 | 10                | 2021            | 2021/22       |              | 558          |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Oct              |
#    | STFI2122                | 10017578 | 10017578 Co Ltd             |               |                             | STFI-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Short Term Funding Initiative 1                                 |                                                                 | 11                | 2021            | 2021/22       |              | 504          |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Nov              |
#    | STFI2122                | 10017578 | 10017578 Co Ltd             |               |                             | STFI-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Short Term Funding Initiative 1                                 |                                                                 | 12                | 2021            | 2021/22       |              | 1650         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Dec              |
#    | STFI2122                | 10017578 | 10017578 Co Ltd             |               |                             | STFI-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Short Term Funding Initiative 1                                 |                                                                 | 1                 | 2022            | 2021/22       |              | 1912         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jan              |
#    | STFI2122                | 10017578 | 10017578 Co Ltd             |               |                             | STFI-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Short Term Funding Initiative 1                                 |                                                                 | 2                 | 2022            | 2021/22       |              | 2110         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Feb              |
#    | STFI2122                | 10017578 | 10017578 Co Ltd             |               |                             | STFI-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Short Term Funding Initiative 1                                 |                                                                 | 3                 | 2022            | 2021/22       |              | 1517         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Mar              |
#    | STFI2122                | 10017578 | 10017578 Co Ltd             |               |                             | STFI-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Short Term Funding Initiative 1                                 |                                                                 | 4                 | 2022            | 2022/23       |              | 3296         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Apr              |
#    | STFI2122                | 10017578 | 10017578 Co Ltd             |               |                             | STFI-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Short Term Funding Initiative 1                                 |                                                                 | 5                 | 2022            | 2022/23       |              | 677          |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | May              |
#    | STFI2122                | 10017578 | 10017578 Co Ltd             |               |                             | STFI-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Short Term Funding Initiative 1                                 |                                                                 | 6                 | 2022            | 2022/23       |              | 148          |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jun              |
#    | STFI2122                | 10017578 | 10017578 Co Ltd             |               |                             | STFI-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Short Term Funding Initiative 1                                 |                                                                 | 7                 | 2022            | 2022/23       |              | 2718         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jul              |
#    | STFI2122                | 10017578 | 10017578 Co Ltd             |               |                             | STFI-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Short Term Funding Initiative 2                                 |                                                                 | 8                 | 2021            | 2021/22       |              | 3471         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Aug              |
#    | STFI2122                | 10017578 | 10017578 Co Ltd             |               |                             | STFI-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Short Term Funding Initiative 2                                 |                                                                 | 9                 | 2021            | 2021/22       |              | 3639         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Sep              |
#    | STFI2122                | 10017578 | 10017578 Co Ltd             |               |                             | STFI-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Short Term Funding Initiative 2                                 |                                                                 | 10                | 2021            | 2021/22       |              | 1400         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Oct              |
#    | STFI2122                | 10017578 | 10017578 Co Ltd             |               |                             | STFI-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Short Term Funding Initiative 2                                 |                                                                 | 11                | 2021            | 2021/22       |              | 3432         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Nov              |
#    | STFI2122                | 10017578 | 10017578 Co Ltd             |               |                             | STFI-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Short Term Funding Initiative 2                                 |                                                                 | 12                | 2021            | 2021/22       |              | 56           |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Dec              |
#    | STFI2122                | 10017578 | 10017578 Co Ltd             |               |                             | STFI-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Short Term Funding Initiative 2                                 |                                                                 | 1                 | 2022            | 2021/22       |              | 1045         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jan              |
#    | STFI2122                | 10017578 | 10017578 Co Ltd             |               |                             | STFI-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Short Term Funding Initiative 2                                 |                                                                 | 2                 | 2022            | 2021/22       |              | 1781         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Feb              |
#    | STFI2122                | 10017578 | 10017578 Co Ltd             |               |                             | STFI-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Short Term Funding Initiative 2                                 |                                                                 | 3                 | 2022            | 2021/22       |              | 3273         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Mar              |
#    | STFI2122                | 10017578 | 10017578 Co Ltd             |               |                             | STFI-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Short Term Funding Initiative 2                                 |                                                                 | 4                 | 2022            | 2022/23       |              | 531          |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Apr              |
#    | STFI2122                | 10017578 | 10017578 Co Ltd             |               |                             | STFI-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Short Term Funding Initiative 2                                 |                                                                 | 5                 | 2022            | 2022/23       |              | 3323         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | May              |
#    | STFI2122                | 10017578 | 10017578 Co Ltd             |               |                             | STFI-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Short Term Funding Initiative 2                                 |                                                                 | 6                 | 2022            | 2022/23       |              | 2349         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jun              |
#    | STFI2122                | 10017578 | 10017578 Co Ltd             |               |                             | STFI-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Short Term Funding Initiative 2                                 |                                                                 | 7                 | 2022            | 2022/23       |              | 585          |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jul              |
#    | STFI2122                | 10017578 | 10017578 Co Ltd             |               |                             | STFI-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Short Term Funding Initiative 3                                 |                                                                 | 8                 | 2021            | 2021/22       |              | 3049         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Aug              |
#    | STFI2122                | 10017578 | 10017578 Co Ltd             |               |                             | STFI-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Short Term Funding Initiative 3                                 |                                                                 | 9                 | 2021            | 2021/22       |              | 2961         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Sep              |
#    | STFI2122                | 10017578 | 10017578 Co Ltd             |               |                             | STFI-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Short Term Funding Initiative 3                                 |                                                                 | 10                | 2021            | 2021/22       |              | 1261         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Oct              |
#    | STFI2122                | 10017578 | 10017578 Co Ltd             |               |                             | STFI-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Short Term Funding Initiative 3                                 |                                                                 | 11                | 2021            | 2021/22       |              | 3642         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Nov              |
#    | STFI2122                | 10017578 | 10017578 Co Ltd             |               |                             | STFI-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Short Term Funding Initiative 3                                 |                                                                 | 12                | 2021            | 2021/22       |              | 1182         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Dec              |
#    | STFI2122                | 10017578 | 10017578 Co Ltd             |               |                             | STFI-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Short Term Funding Initiative 3                                 |                                                                 | 1                 | 2022            | 2021/22       |              | 178          |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jan              |
#    | STFI2122                | 10017578 | 10017578 Co Ltd             |               |                             | STFI-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Short Term Funding Initiative 3                                 |                                                                 | 2                 | 2022            | 2021/22       |              | 470          |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Feb              |
#    | STFI2122                | 10017578 | 10017578 Co Ltd             |               |                             | STFI-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Short Term Funding Initiative 3                                 |                                                                 | 3                 | 2022            | 2021/22       |              | 2313         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Mar              |
#    | STFI2122                | 10017578 | 10017578 Co Ltd             |               |                             | STFI-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Short Term Funding Initiative 3                                 |                                                                 | 4                 | 2022            | 2022/23       |              | 485          |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Apr              |
#    | STFI2122                | 10017578 | 10017578 Co Ltd             |               |                             | STFI-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Short Term Funding Initiative 3                                 |                                                                 | 5                 | 2022            | 2022/23       |              | 1285         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | May              |
#    | STFI2122                | 10017578 | 10017578 Co Ltd             |               |                             | STFI-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Short Term Funding Initiative 3                                 |                                                                 | 6                 | 2022            | 2022/23       |              | 850          |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jun              |
#    | STFI2122                | 10017578 | 10017578 Co Ltd             |               |                             | STFI-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Short Term Funding Initiative 3                                 |                                                                 | 7                 | 2022            | 2022/23       |              | 2155         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jul              |
#    | STFI2122                | 10017578 | 10017578 Co Ltd             |               |                             | STFI-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Short Term Funding Initiative 4                                 |                                                                 | 8                 | 2021            | 2021/22       |              | 2705         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Aug              |
#    | STFI2122                | 10017578 | 10017578 Co Ltd             |               |                             | STFI-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Short Term Funding Initiative 4                                 |                                                                 | 9                 | 2021            | 2021/22       |              | 625          |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Sep              |
#    | STFI2122                | 10017578 | 10017578 Co Ltd             |               |                             | STFI-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Short Term Funding Initiative 4                                 |                                                                 | 10                | 2021            | 2021/22       |              | 2182         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Oct              |
#    | STFI2122                | 10017578 | 10017578 Co Ltd             |               |                             | STFI-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Short Term Funding Initiative 4                                 |                                                                 | 11                | 2021            | 2021/22       |              | 230          |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Nov              |
#    | STFI2122                | 10017578 | 10017578 Co Ltd             |               |                             | STFI-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Short Term Funding Initiative 4                                 |                                                                 | 12                | 2021            | 2021/22       |              | 3368         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Dec              |
#    | STFI2122                | 10017578 | 10017578 Co Ltd             |               |                             | STFI-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Short Term Funding Initiative 4                                 |                                                                 | 1                 | 2022            | 2021/22       |              | 3091         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jan              |
#    | STFI2122                | 10017578 | 10017578 Co Ltd             |               |                             | STFI-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Short Term Funding Initiative 4                                 |                                                                 | 2                 | 2022            | 2021/22       |              | 220          |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Feb              |
#    | STFI2122                | 10017578 | 10017578 Co Ltd             |               |                             | STFI-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Short Term Funding Initiative 4                                 |                                                                 | 3                 | 2022            | 2021/22       |              | 1431         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Mar              |
#    | STFI2122                | 10017578 | 10017578 Co Ltd             |               |                             | STFI-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Short Term Funding Initiative 4                                 |                                                                 | 4                 | 2022            | 2022/23       |              | 2483         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Apr              |
#    | STFI2122                | 10017578 | 10017578 Co Ltd             |               |                             | STFI-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Short Term Funding Initiative 4                                 |                                                                 | 5                 | 2022            | 2022/23       |              | 309          |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | May              |
#    | STFI2122                | 10017578 | 10017578 Co Ltd             |               |                             | STFI-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Short Term Funding Initiative 4                                 |                                                                 | 6                 | 2022            | 2022/23       |              | 3131         |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jun              |
#    | STFI2122                | 10017578 | 10017578 Co Ltd             |               |                             | STFI-578                 | AEBP21-578     | ESFA-578                | 01/08/2021                  | 31/07/2022                | 1                     | Approved       | Approved                |                                                      | Short Term Funding Initiative 4                                 |                                                                 | 7                 | 2022            | 2022/23       |              | 102          |              |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jul              |





    # Add actuals to the contract for the three FSPs

    # Change the date
    Given the override date is '04/10/2021'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017578'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Sep 2021
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202108 | AEB-AS2122              | AEBA-578                 | ?          | 2               | 0            | 2418.39     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202108 | AEB-AS2122              | AEBA-578                 | ?          | 3               | 0            | 2303.88     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202108 | AEB-AS2122              | AEBA-578                 | ?          | 6               | 0            | 1140.49     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202108 | AEB-AS2122              | AEBA-578                 | ?          | 7               | 0            | 1145.20     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202108 | AEB-AS2122              | AEBA-578                 | ?          | 8               | 0            | 2006.10     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202108 | AEB-AS2122              | AEBA-578                 | ?          | 9               | 0            | 2442.05     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202108 | AEB-AS2122              | AEBA-578                 | ?          | 10              | 0            | 2447.08     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202109 | AEB-AS2122              | AEBA-578                 | ?          | 2               | 0            | 987.10      |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202109 | AEB-AS2122              | AEBA-578                 | ?          | 3               | 0            | 2220.49     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202109 | AEB-AS2122              | AEBA-578                 | ?          | 6               | 0            | 1003.69     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202109 | AEB-AS2122              | AEBA-578                 | ?          | 7               | 0            | 1272.70     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202109 | AEB-AS2122              | AEBA-578                 | ?          | 8               | 0            | 503.50      |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202109 | AEB-AS2122              | AEBA-578                 | ?          | 9               | 0            | 1516.42     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202109 | AEB-AS2122              | AEBA-578                 | ?          | 10              | 0            | 1705.47     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202110 | AEB-AS2122              | AEBA-578                 | ?          | 2               | 0            | 1823.65     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202110 | AEB-AS2122              | AEBA-578                 | ?          | 3               | 0            | 1906.82     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202110 | AEB-AS2122              | AEBA-578                 | ?          | 6               | 0            | 1262.92     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202110 | AEB-AS2122              | AEBA-578                 | ?          | 7               | 0            | 1621.55     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202110 | AEB-AS2122              | AEBA-578                 | ?          | 8               | 0            | 933.65      |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202110 | AEB-AS2122              | AEBA-578                 | ?          | 9               | 0            | 2227.15     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202110 | AEB-AS2122              | AEBA-578                 | ?          | 10              | 0            | 1575.99     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202111 | AEB-AS2122              | AEBA-578                 | ?          | 2               | 0            | 1585.19     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202111 | AEB-AS2122              | AEBA-578                 | ?          | 3               | 0            | 959.17      |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202111 | AEB-AS2122              | AEBA-578                 | ?          | 6               | 0            | 826.30      |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202111 | AEB-AS2122              | AEBA-578                 | ?          | 7               | 0            | 1876.42     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202111 | AEB-AS2122              | AEBA-578                 | ?          | 8               | 0            | 2415.29     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202111 | AEB-AS2122              | AEBA-578                 | ?          | 9               | 0            | 2199.76     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202111 | AEB-AS2122              | AEBA-578                 | ?          | 10              | 0            | 1136.90     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202112 | AEB-AS2122              | AEBA-578                 | ?          | 2               | 0            | 1972.58     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202112 | AEB-AS2122              | AEBA-578                 | ?          | 3               | 0            | 1667.96     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202112 | AEB-AS2122              | AEBA-578                 | ?          | 6               | 0            | 2143.32     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202112 | AEB-AS2122              | AEBA-578                 | ?          | 7               | 0            | 2426.44     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202112 | AEB-AS2122              | AEBA-578                 | ?          | 8               | 0            | 1568.25     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202112 | AEB-AS2122              | AEBA-578                 | ?          | 9               | 0            | 1413.08     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202112 | AEB-AS2122              | AEBA-578                 | ?          | 10              | 0            | 1536.49     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202201 | AEB-AS2122              | AEBA-578                 | ?          | 2               | 0            | 486.31      |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202201 | AEB-AS2122              | AEBA-578                 | ?          | 3               | 0            | 2395.46     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202201 | AEB-AS2122              | AEBA-578                 | ?          | 6               | 0            | 1835.87     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202201 | AEB-AS2122              | AEBA-578                 | ?          | 7               | 0            | 479.86      |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202201 | AEB-AS2122              | AEBA-578                 | ?          | 8               | 0            | 1445.95     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202201 | AEB-AS2122              | AEBA-578                 | ?          | 9               | 0            | 2472.26     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202201 | AEB-AS2122              | AEBA-578                 | ?          | 10              | 0            | 1663.43     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202202 | AEB-AS2122              | AEBA-578                 | ?          | 2               | 0            | 1348.39     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202202 | AEB-AS2122              | AEBA-578                 | ?          | 3               | 0            | 411.78      |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202202 | AEB-AS2122              | AEBA-578                 | ?          | 6               | 0            | 1385.52     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202202 | AEB-AS2122              | AEBA-578                 | ?          | 7               | 0            | 1216.31     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202202 | AEB-AS2122              | AEBA-578                 | ?          | 8               | 0            | 1736.63     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202202 | AEB-AS2122              | AEBA-578                 | ?          | 9               | 0            | 531.37      |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202202 | AEB-AS2122              | AEBA-578                 | ?          | 10              | 0            | 1898.83     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202203 | AEB-AS2122              | AEBA-578                 | ?          | 2               | 0            | 1785.12     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202203 | AEB-AS2122              | AEBA-578                 | ?          | 3               | 0            | 529.07      |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202203 | AEB-AS2122              | AEBA-578                 | ?          | 6               | 0            | 1082.48     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202203 | AEB-AS2122              | AEBA-578                 | ?          | 7               | 0            | 1585.20     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202203 | AEB-AS2122              | AEBA-578                 | ?          | 8               | 0            | 1332.00     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202203 | AEB-AS2122              | AEBA-578                 | ?          | 9               | 0            | 2395.49     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202203 | AEB-AS2122              | AEBA-578                 | ?          | 10              | 0            | 787.06      |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202204 | AEB-AS2122              | AEBA-578                 | ?          | 2               | 0            | 1784.94     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202204 | AEB-AS2122              | AEBA-578                 | ?          | 3               | 0            | 1217.26     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202204 | AEB-AS2122              | AEBA-578                 | ?          | 6               | 0            | 1811.20     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202204 | AEB-AS2122              | AEBA-578                 | ?          | 7               | 0            | 1650.42     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202204 | AEB-AS2122              | AEBA-578                 | ?          | 8               | 0            | 2388.47     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202204 | AEB-AS2122              | AEBA-578                 | ?          | 9               | 0            | 850.93      |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202204 | AEB-AS2122              | AEBA-578                 | ?          | 10              | 0            | 1202.40     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202205 | AEB-AS2122              | AEBA-578                 | ?          | 2               | 0            | 725.17      |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202205 | AEB-AS2122              | AEBA-578                 | ?          | 3               | 0            | 1344.11     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202205 | AEB-AS2122              | AEBA-578                 | ?          | 6               | 0            | 1269.29     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202205 | AEB-AS2122              | AEBA-578                 | ?          | 7               | 0            | 2316.50     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202205 | AEB-AS2122              | AEBA-578                 | ?          | 8               | 0            | 1300.40     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202205 | AEB-AS2122              | AEBA-578                 | ?          | 9               | 0            | 990.90      |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202205 | AEB-AS2122              | AEBA-578                 | ?          | 10              | 0            | 836.45      |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202206 | AEB-AS2122              | AEBA-578                 | ?          | 2               | 0            | 2317.37     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202206 | AEB-AS2122              | AEBA-578                 | ?          | 3               | 0            | 1515.66     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202206 | AEB-AS2122              | AEBA-578                 | ?          | 6               | 0            | 2316.43     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202206 | AEB-AS2122              | AEBA-578                 | ?          | 7               | 0            | 1970.94     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202206 | AEB-AS2122              | AEBA-578                 | ?          | 8               | 0            | 905.74      |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202206 | AEB-AS2122              | AEBA-578                 | ?          | 9               | 0            | 2400.07     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202206 | AEB-AS2122              | AEBA-578                 | ?          | 10              | 0            | 1839.62     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202207 | AEB-AS2122              | AEBA-578                 | ?          | 2               | 0            | 1597.21     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202207 | AEB-AS2122              | AEBA-578                 | ?          | 3               | 0            | 1664.47     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202207 | AEB-AS2122              | AEBA-578                 | ?          | 6               | 0            | 1736.33     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202207 | AEB-AS2122              | AEBA-578                 | ?          | 7               | 0            | 1618.55     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202207 | AEB-AS2122              | AEBA-578                 | ?          | 8               | 0            | 1022.25     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202207 | AEB-AS2122              | AEBA-578                 | ?          | 9               | 0            | 1328.82     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202207 | AEB-AS2122              | AEBA-578                 | ?          | 10              | 0            | 1049.85     |
    #
    | ILR2122        | R02                  | ORG0017578     | CM             | 202108 | AEB-NSF2122             | NSF-578                  | ?          | 3               | 0            | 825.75      |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202108 | AEB-NSF2122             | NSF-578                  | ?          | 4               | 0            | 1489.86     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202108 | AEB-NSF2122             | NSF-578                  | ?          | 6               | 0            | 560.18      |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202108 | AEB-NSF2122             | NSF-578                  | ?          | 7               | 0            | 508.14      |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202108 | AEB-NSF2122             | NSF-578                  | ?          | 8               | 0            | 746.81      |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202108 | AEB-NSF2122             | NSF-578                  | ?          | 9               | 0            | 1055.06     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202108 | AEB-NSF2122             | NSF-578                  | ?          | 10              | 0            | 641.92      |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202109 | AEB-NSF2122             | NSF-578                  | ?          | 3               | 0            | 693.35      |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202109 | AEB-NSF2122             | NSF-578                  | ?          | 4               | 0            | 1212.38     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202109 | AEB-NSF2122             | NSF-578                  | ?          | 6               | 0            | 757.24      |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202109 | AEB-NSF2122             | NSF-578                  | ?          | 7               | 0            | 551.22      |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202109 | AEB-NSF2122             | NSF-578                  | ?          | 8               | 0            | 680.46      |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202109 | AEB-NSF2122             | NSF-578                  | ?          | 9               | 0            | 718.55      |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202109 | AEB-NSF2122             | NSF-578                  | ?          | 10              | 0            | 598.76      |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202110 | AEB-NSF2122             | NSF-578                  | ?          | 3               | 0            | 859.09      |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202110 | AEB-NSF2122             | NSF-578                  | ?          | 4               | 0            | 722.06      |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202110 | AEB-NSF2122             | NSF-578                  | ?          | 6               | 0            | 1860.67     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202110 | AEB-NSF2122             | NSF-578                  | ?          | 7               | 0            | 1234.20     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202110 | AEB-NSF2122             | NSF-578                  | ?          | 8               | 0            | 2029.95     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202110 | AEB-NSF2122             | NSF-578                  | ?          | 9               | 0            | 1390.51     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202110 | AEB-NSF2122             | NSF-578                  | ?          | 10              | 0            | 724.75      |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202111 | AEB-NSF2122             | NSF-578                  | ?          | 3               | 0            | 646.09      |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202111 | AEB-NSF2122             | NSF-578                  | ?          | 4               | 0            | 1444.28     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202111 | AEB-NSF2122             | NSF-578                  | ?          | 6               | 0            | 1409.99     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202111 | AEB-NSF2122             | NSF-578                  | ?          | 7               | 0            | 791.42      |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202111 | AEB-NSF2122             | NSF-578                  | ?          | 8               | 0            | 533.25      |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202111 | AEB-NSF2122             | NSF-578                  | ?          | 9               | 0            | 1983.78     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202111 | AEB-NSF2122             | NSF-578                  | ?          | 10              | 0            | 1501.01     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202112 | AEB-NSF2122             | NSF-578                  | ?          | 3               | 0            | 1402.27     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202112 | AEB-NSF2122             | NSF-578                  | ?          | 4               | 0            | 2061.53     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202112 | AEB-NSF2122             | NSF-578                  | ?          | 6               | 0            | 729.04      |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202112 | AEB-NSF2122             | NSF-578                  | ?          | 7               | 0            | 1287.45     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202112 | AEB-NSF2122             | NSF-578                  | ?          | 8               | 0            | 1488.77     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202112 | AEB-NSF2122             | NSF-578                  | ?          | 9               | 0            | 2077.09     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202112 | AEB-NSF2122             | NSF-578                  | ?          | 10              | 0            | 2169.69     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202201 | AEB-NSF2122             | NSF-578                  | ?          | 3               | 0            | 2216.09     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202201 | AEB-NSF2122             | NSF-578                  | ?          | 4               | 0            | 1913.71     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202201 | AEB-NSF2122             | NSF-578                  | ?          | 6               | 0            | 882.21      |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202201 | AEB-NSF2122             | NSF-578                  | ?          | 7               | 0            | 426.99      |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202201 | AEB-NSF2122             | NSF-578                  | ?          | 8               | 0            | 1688.64     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202201 | AEB-NSF2122             | NSF-578                  | ?          | 9               | 0            | 875.08      |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202201 | AEB-NSF2122             | NSF-578                  | ?          | 10              | 0            | 1223.54     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202202 | AEB-NSF2122             | NSF-578                  | ?          | 3               | 0            | 789.14      |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202202 | AEB-NSF2122             | NSF-578                  | ?          | 4               | 0            | 606.26      |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202202 | AEB-NSF2122             | NSF-578                  | ?          | 6               | 0            | 872.48      |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202202 | AEB-NSF2122             | NSF-578                  | ?          | 7               | 0            | 2192.92     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202202 | AEB-NSF2122             | NSF-578                  | ?          | 8               | 0            | 1008.76     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202202 | AEB-NSF2122             | NSF-578                  | ?          | 9               | 0            | 2126.66     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202202 | AEB-NSF2122             | NSF-578                  | ?          | 10              | 0            | 1336.04     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202203 | AEB-NSF2122             | NSF-578                  | ?          | 3               | 0            | 990.60      |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202203 | AEB-NSF2122             | NSF-578                  | ?          | 4               | 0            | 813.18      |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202203 | AEB-NSF2122             | NSF-578                  | ?          | 6               | 0            | 1633.50     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202203 | AEB-NSF2122             | NSF-578                  | ?          | 7               | 0            | 967.78      |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202203 | AEB-NSF2122             | NSF-578                  | ?          | 8               | 0            | 701.10      |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202203 | AEB-NSF2122             | NSF-578                  | ?          | 9               | 0            | 777.00      |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202203 | AEB-NSF2122             | NSF-578                  | ?          | 10              | 0            | 1218.54     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202204 | AEB-NSF2122             | NSF-578                  | ?          | 3               | 0            | 545.58      |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202204 | AEB-NSF2122             | NSF-578                  | ?          | 4               | 0            | 1881.42     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202204 | AEB-NSF2122             | NSF-578                  | ?          | 6               | 0            | 1657.35     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202204 | AEB-NSF2122             | NSF-578                  | ?          | 7               | 0            | 576.11      |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202204 | AEB-NSF2122             | NSF-578                  | ?          | 8               | 0            | 639.55      |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202204 | AEB-NSF2122             | NSF-578                  | ?          | 9               | 0            | 2011.87     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202204 | AEB-NSF2122             | NSF-578                  | ?          | 10              | 0            | 491.41      |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202205 | AEB-NSF2122             | NSF-578                  | ?          | 3               | 0            | 1310.19     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202205 | AEB-NSF2122             | NSF-578                  | ?          | 4               | 0            | 1640.95     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202205 | AEB-NSF2122             | NSF-578                  | ?          | 6               | 0            | 959.30      |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202205 | AEB-NSF2122             | NSF-578                  | ?          | 7               | 0            | 1956.73     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202205 | AEB-NSF2122             | NSF-578                  | ?          | 8               | 0            | 603.87      |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202205 | AEB-NSF2122             | NSF-578                  | ?          | 9               | 0            | 553.56      |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202205 | AEB-NSF2122             | NSF-578                  | ?          | 10              | 0            | 1352.97     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202206 | AEB-NSF2122             | NSF-578                  | ?          | 3               | 0            | 593.72      |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202206 | AEB-NSF2122             | NSF-578                  | ?          | 4               | 0            | 2001.46     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202206 | AEB-NSF2122             | NSF-578                  | ?          | 6               | 0            | 1197.65     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202206 | AEB-NSF2122             | NSF-578                  | ?          | 7               | 0            | 2022.72     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202206 | AEB-NSF2122             | NSF-578                  | ?          | 8               | 0            | 490.93      |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202206 | AEB-NSF2122             | NSF-578                  | ?          | 9               | 0            | 752.93      |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202206 | AEB-NSF2122             | NSF-578                  | ?          | 10              | 0            | 826.33      |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202207 | AEB-NSF2122             | NSF-578                  | ?          | 3               | 0            | 1149.82     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202207 | AEB-NSF2122             | NSF-578                  | ?          | 4               | 0            | 2132.67     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202207 | AEB-NSF2122             | NSF-578                  | ?          | 6               | 0            | 1071.06     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202207 | AEB-NSF2122             | NSF-578                  | ?          | 7               | 0            | 1254.49     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202207 | AEB-NSF2122             | NSF-578                  | ?          | 8               | 0            | 1730.27     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202207 | AEB-NSF2122             | NSF-578                  | ?          | 9               | 0            | 809.11      |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202207 | AEB-NSF2122             | NSF-578                  | ?          | 10              | 0            | 550.85      |
    #
    | ILR2122        | R02                  | ORG0017578     | CM             | 202108 | STFI2122                | STFI-578                 | ?          | 5               | 0            | 4215.17     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202108 | STFI2122                | STFI-578                 | ?          | 6               | 0            | 2253.60     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202108 | STFI2122                | STFI-578                 | ?          | 7               | 0            | 4552.09     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202108 | STFI2122                | STFI-578                 | ?          | 8               | 0            | 2434.02     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202108 | STFI2122                | STFI-578                 | ?          | 9               | 0            | 2499.79     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202108 | STFI2122                | STFI-578                 | ?          | 10              | 0            | 3636.46     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202108 | STFI2122                | STFI-578                 | ?          | 11              | 0            | 2618.28     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202108 | STFI2122                | STFI-578                 | ?          | 12              | 0            | 2416.11     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202109 | STFI2122                | STFI-578                 | ?          | 5               | 0            | 4336.46     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202109 | STFI2122                | STFI-578                 | ?          | 6               | 0            | 3502.67     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202109 | STFI2122                | STFI-578                 | ?          | 7               | 0            | 4216.08     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202109 | STFI2122                | STFI-578                 | ?          | 8               | 0            | 1458.51     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202109 | STFI2122                | STFI-578                 | ?          | 9               | 0            | 3126.97     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202109 | STFI2122                | STFI-578                 | ?          | 10              | 0            | 3703.04     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202109 | STFI2122                | STFI-578                 | ?          | 11              | 0            | 1524.27     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202109 | STFI2122                | STFI-578                 | ?          | 12              | 0            | 3431.02     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202110 | STFI2122                | STFI-578                 | ?          | 5               | 0            | 3143.16     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202110 | STFI2122                | STFI-578                 | ?          | 6               | 0            | 3178.32     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202110 | STFI2122                | STFI-578                 | ?          | 7               | 0            | 2051.86     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202110 | STFI2122                | STFI-578                 | ?          | 8               | 0            | 2512.92     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202110 | STFI2122                | STFI-578                 | ?          | 9               | 0            | 4728.45     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202110 | STFI2122                | STFI-578                 | ?          | 10              | 0            | 2754.52     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202110 | STFI2122                | STFI-578                 | ?          | 11              | 0            | 4352.08     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202110 | STFI2122                | STFI-578                 | ?          | 12              | 0            | 3250.77     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202111 | STFI2122                | STFI-578                 | ?          | 5               | 0            | 3524.38     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202111 | STFI2122                | STFI-578                 | ?          | 6               | 0            | 4163.23     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202111 | STFI2122                | STFI-578                 | ?          | 7               | 0            | 4261.45     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202111 | STFI2122                | STFI-578                 | ?          | 8               | 0            | 1841.24     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202111 | STFI2122                | STFI-578                 | ?          | 9               | 0            | 3722.23     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202111 | STFI2122                | STFI-578                 | ?          | 10              | 0            | 3286.88     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202111 | STFI2122                | STFI-578                 | ?          | 11              | 0            | 1963.86     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202111 | STFI2122                | STFI-578                 | ?          | 12              | 0            | 4538.90     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202112 | STFI2122                | STFI-578                 | ?          | 5               | 0            | 2439.54     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202112 | STFI2122                | STFI-578                 | ?          | 6               | 0            | 4029.12     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202112 | STFI2122                | STFI-578                 | ?          | 7               | 0            | 3279.65     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202112 | STFI2122                | STFI-578                 | ?          | 8               | 0            | 3989.04     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202112 | STFI2122                | STFI-578                 | ?          | 9               | 0            | 4621.68     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202112 | STFI2122                | STFI-578                 | ?          | 10              | 0            | 3310.10     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202112 | STFI2122                | STFI-578                 | ?          | 11              | 0            | 1979.60     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202112 | STFI2122                | STFI-578                 | ?          | 12              | 0            | 2585.49     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202201 | STFI2122                | STFI-578                 | ?          | 5               | 0            | 2468.38     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202201 | STFI2122                | STFI-578                 | ?          | 6               | 0            | 3286.78     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202201 | STFI2122                | STFI-578                 | ?          | 7               | 0            | 2524.08     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202201 | STFI2122                | STFI-578                 | ?          | 8               | 0            | 3653.43     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202201 | STFI2122                | STFI-578                 | ?          | 9               | 0            | 1885.39     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202201 | STFI2122                | STFI-578                 | ?          | 10              | 0            | 4598.27     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202201 | STFI2122                | STFI-578                 | ?          | 11              | 0            | 4027.07     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202201 | STFI2122                | STFI-578                 | ?          | 12              | 0            | 3457.19     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202202 | STFI2122                | STFI-578                 | ?          | 5               | 0            | 3560.95     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202202 | STFI2122                | STFI-578                 | ?          | 6               | 0            | 3736.07     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202202 | STFI2122                | STFI-578                 | ?          | 7               | 0            | 1545.20     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202202 | STFI2122                | STFI-578                 | ?          | 8               | 0            | 3833.09     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202202 | STFI2122                | STFI-578                 | ?          | 9               | 0            | 4667.37     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202202 | STFI2122                | STFI-578                 | ?          | 10              | 0            | 4439.51     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202202 | STFI2122                | STFI-578                 | ?          | 11              | 0            | 4691.88     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202202 | STFI2122                | STFI-578                 | ?          | 12              | 0            | 2547.21     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202203 | STFI2122                | STFI-578                 | ?          | 5               | 0            | 4687.62     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202203 | STFI2122                | STFI-578                 | ?          | 6               | 0            | 3515.91     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202203 | STFI2122                | STFI-578                 | ?          | 7               | 0            | 4276.26     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202203 | STFI2122                | STFI-578                 | ?          | 8               | 0            | 4278.26     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202203 | STFI2122                | STFI-578                 | ?          | 9               | 0            | 2166.85     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202203 | STFI2122                | STFI-578                 | ?          | 10              | 0            | 3886.02     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202203 | STFI2122                | STFI-578                 | ?          | 11              | 0            | 2467.41     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202203 | STFI2122                | STFI-578                 | ?          | 12              | 0            | 2725.33     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202204 | STFI2122                | STFI-578                 | ?          | 5               | 0            | 2189.03     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202204 | STFI2122                | STFI-578                 | ?          | 6               | 0            | 2054.26     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202204 | STFI2122                | STFI-578                 | ?          | 7               | 0            | 4183.31     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202204 | STFI2122                | STFI-578                 | ?          | 8               | 0            | 3140.76     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202204 | STFI2122                | STFI-578                 | ?          | 9               | 0            | 1578.43     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202204 | STFI2122                | STFI-578                 | ?          | 10              | 0            | 2804.07     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202204 | STFI2122                | STFI-578                 | ?          | 11              | 0            | 2704.91     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202204 | STFI2122                | STFI-578                 | ?          | 12              | 0            | 2787.89     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202205 | STFI2122                | STFI-578                 | ?          | 5               | 0            | 4626.21     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202205 | STFI2122                | STFI-578                 | ?          | 6               | 0            | 1718.18     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202205 | STFI2122                | STFI-578                 | ?          | 7               | 0            | 2415.22     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202205 | STFI2122                | STFI-578                 | ?          | 8               | 0            | 1923.94     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202205 | STFI2122                | STFI-578                 | ?          | 9               | 0            | 3341.99     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202205 | STFI2122                | STFI-578                 | ?          | 10              | 0            | 1523.97     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202205 | STFI2122                | STFI-578                 | ?          | 11              | 0            | 2763.39     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202205 | STFI2122                | STFI-578                 | ?          | 12              | 0            | 2407.79     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202206 | STFI2122                | STFI-578                 | ?          | 5               | 0            | 4730.44     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202206 | STFI2122                | STFI-578                 | ?          | 6               | 0            | 2863.77     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202206 | STFI2122                | STFI-578                 | ?          | 7               | 0            | 2853.71     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202206 | STFI2122                | STFI-578                 | ?          | 8               | 0            | 3832.76     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202206 | STFI2122                | STFI-578                 | ?          | 9               | 0            | 2792.75     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202206 | STFI2122                | STFI-578                 | ?          | 10              | 0            | 2490.13     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202206 | STFI2122                | STFI-578                 | ?          | 11              | 0            | 3559.72     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202206 | STFI2122                | STFI-578                 | ?          | 12              | 0            | 3784.49     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202207 | STFI2122                | STFI-578                 | ?          | 5               | 0            | 4153.32     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202207 | STFI2122                | STFI-578                 | ?          | 6               | 0            | 2186.19     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202207 | STFI2122                | STFI-578                 | ?          | 7               | 0            | 3863.26     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202207 | STFI2122                | STFI-578                 | ?          | 8               | 0            | 2223.69     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202207 | STFI2122                | STFI-578                 | ?          | 9               | 0            | 1711.20     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202207 | STFI2122                | STFI-578                 | ?          | 10              | 0            | 2010.97     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202207 | STFI2122                | STFI-578                 | ?          | 11              | 0            | 4618.54     |
    | ILR2122        | R02                  | ORG0017578     | CM             | 202207 | STFI2122                | STFI-578                 | ?          | 12              | 0            | 3394.01     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   |
    | AEBP21-578     | AEBA-578           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP21-578     | AEBA-578           | 2               | 3405.49   | 2418.39  | 987.10   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP21-578     | AEBA-578           | 3               | 4524.37   | 2303.88  | 2220.49  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP21-578     | AEBA-578           | 4               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP21-578     | AEBA-578           | 5               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP21-578     | AEBA-578           | 6               | 2144.18   | 1140.49  | 1003.69  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP21-578     | AEBA-578           | 7               | 2417.90   | 1145.20  | 1272.70  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP21-578     | AEBA-578           | 8               | 2509.60   | 2006.10  | 503.50   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP21-578     | AEBA-578           | 9               | 3958.47   | 2442.05  | 1516.42  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP21-578     | AEBA-578           | 10              | 4152.55   | 2447.08  | 1705.47  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    #
    | AEBP21-578     | NSF-578            | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP21-578     | NSF-578            | 2               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP21-578     | NSF-578            | 3               | 1519.10   | 825.75   | 693.35   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP21-578     | NSF-578            | 4               | 2702.24   | 1489.86  | 1212.38  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP21-578     | NSF-578            | 5               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP21-578     | NSF-578            | 6               | 1317.42   | 560.18   | 757.24   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP21-578     | NSF-578            | 7               | 1059.36   | 508.14   | 551.22   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP21-578     | NSF-578            | 8               | 1427.27   | 746.81   | 680.46   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP21-578     | NSF-578            | 9               | 1773.61   | 1055.06  | 718.55   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP21-578     | NSF-578            | 10              | 1240.68   | 641.92   | 598.76   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    #
    | AEBP21-578     | STFI-578           | 1               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP21-578     | STFI-578           | 2               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP21-578     | STFI-578           | 3               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP21-578     | STFI-578           | 4               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP21-578     | STFI-578           | 5               | 8551.63   | 4215.17  | 4336.46  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP21-578     | STFI-578           | 6               | 5756.27   | 2253.60  | 3502.67  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP21-578     | STFI-578           | 7               | 8768.17   | 4552.09  | 4216.08  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP21-578     | STFI-578           | 8               | 3892.53   | 2434.02  | 1458.51  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP21-578     | STFI-578           | 9               | 5626.76   | 2499.79  | 3126.97  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP21-578     | STFI-578           | 10              | 7339.50   | 3636.46  | 3703.04  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP21-578     | STFI-578           | 11              | 4142.55   | 2618.28  | 1524.27  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | AEBP21-578     | STFI-578           | 12              | 5847.13   | 2416.11  | 3431.02  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   |
    | AEBP21-578     | AEBA-578           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | AEBA-578           | 2               | 3405.49   | 0.00     | 3405.49  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | AEBA-578           | 3               | 4524.37   | 0.00     | 4524.37  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | AEBA-578           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | AEBA-578           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | AEBA-578           | 6               | 2144.18   | 0.00     | 2144.18  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | AEBA-578           | 7               | 2417.90   | 0.00     | 2417.90  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | AEBA-578           | 8               | 2509.60   | 0.00     | 2509.60  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | AEBA-578           | 9               | 3958.47   | 0.00     | 3958.47  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | AEBA-578           | 10              | 4152.55   | 0.00     | 4152.55  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | AEBP21-578     | NSF-578            | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | NSF-578            | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | NSF-578            | 3               | 1519.10   | 0.00     | 1519.10  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | NSF-578            | 4               | 2702.24   | 0.00     | 2702.24  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | NSF-578            | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | NSF-578            | 6               | 1317.42   | 0.00     | 1317.42  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | NSF-578            | 7               | 1059.36   | 0.00     | 1059.36  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | NSF-578            | 8               | 1427.27   | 0.00     | 1427.27  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | NSF-578            | 9               | 1773.61   | 0.00     | 1773.61  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | NSF-578            | 10              | 1240.68   | 0.00     | 1240.68  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | AEBP21-578     | STFI-578           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | STFI-578           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | STFI-578           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | STFI-578           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | STFI-578           | 5               | 8551.63   | 0.00     | 8551.63  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | STFI-578           | 6               | 5756.27   | 0.00     | 5756.27  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | STFI-578           | 7               | 8768.17   | 0.00     | 8768.17  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | STFI-578           | 8               | 3892.53   | 0.00     | 3892.53  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | STFI-578           | 9               | 5626.76   | 0.00     | 5626.76  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | STFI-578           | 10              | 7339.50   | 0.00     | 7339.50  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | STFI-578           | 11              | 4142.55   | 0.00     | 4142.55  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | STFI-578           | 12              | 5847.13   | 0.00     | 5847.13  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   |
    | AEBP21-578     | AEBA-578           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | AEBA-578           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | AEBA-578           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | AEBA-578           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | AEBA-578           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | AEBA-578           | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | AEBA-578           | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | AEBA-578           | 8               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | AEBA-578           | 9               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | AEBA-578           | 10              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | AEBP21-578     | NSF-578            | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | NSF-578            | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | NSF-578            | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | NSF-578            | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | NSF-578            | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | NSF-578            | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | NSF-578            | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | NSF-578            | 8               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | NSF-578            | 9               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | NSF-578            | 10              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | AEBP21-578     | STFI-578           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | STFI-578           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | STFI-578           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | STFI-578           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | STFI-578           | 5               | -923.96   | 0.00     | -923.96  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | STFI-578           | 6               | -621.94   | 0.00     | -621.94  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | STFI-578           | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | STFI-578           | 8               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | STFI-578           | 9               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | STFI-578           | 10              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | STFI-578           | 11              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | STFI-578           | 12              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   |
    | AEBP21-578     | AEBA-578           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | AEBA-578           | 2               | 3405.49   | 0.00     | 3405.49  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | AEBA-578           | 3               | 4524.37   | 0.00     | 4524.37  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | AEBA-578           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | AEBA-578           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | AEBA-578           | 6               | 2144.18   | 0.00     | 2144.18  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | AEBA-578           | 7               | 2417.90   | 0.00     | 2417.90  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | AEBA-578           | 8               | 2509.60   | 0.00     | 2509.60  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | AEBA-578           | 9               | 3958.47   | 0.00     | 3958.47  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | AEBA-578           | 10              | 4152.55   | 0.00     | 4152.55  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | AEBP21-578     | NSF-578            | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | NSF-578            | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | NSF-578            | 3               | 1519.10   | 0.00     | 1519.10  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | NSF-578            | 4               | 2702.24   | 0.00     | 2702.24  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | NSF-578            | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | NSF-578            | 6               | 1317.42   | 0.00     | 1317.42  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | NSF-578            | 7               | 1059.36   | 0.00     | 1059.36  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | NSF-578            | 8               | 1427.27   | 0.00     | 1427.27  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | NSF-578            | 9               | 1773.61   | 0.00     | 1773.61  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | NSF-578            | 10              | 1240.68   | 0.00     | 1240.68  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | AEBP21-578     | STFI-578           | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | STFI-578           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | STFI-578           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | STFI-578           | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | STFI-578           | 5               | 7627.67   | 0.00     | 7627.67  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | STFI-578           | 6               | 5134.33   | 0.00     | 5134.33  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | STFI-578           | 7               | 8768.17   | 0.00     | 8768.17  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | STFI-578           | 8               | 3892.53   | 0.00     | 3892.53  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | STFI-578           | 9               | 5626.76   | 0.00     | 5626.76  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | STFI-578           | 10              | 7339.50   | 0.00     | 7339.50  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | STFI-578           | 11              | 4142.55   | 0.00     | 4142.55  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | STFI-578           | 12              | 5847.13   | 0.00     | 5847.13  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | P1-8     | P9-12    | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   |
    | AEBP21-578     | AEBA-578           | 1               | 43874.00  | 32264.00 | 11610.00 | 3218.00  | 3203.00  | 4230.00  | 4848.00  | 3978.00  | 2887.00  | 5180.00  | 4720.00  | 6098.00  | 1212.00  | 3786.00  | 514.00   | 
    | AEBP21-578     | AEBA-578           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | AEBA-578           | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | AEBA-578           | 4               | 23658.00  | 17280.00 | 6378.00  | 1401.00  | 2389.00  | 3125.00  | 1900.00  | 1875.00  | 966.00   | 3694.00  | 1930.00  | 3520.00  | 714.00   | 1732.00  | 412.00   | 
    | AEBP21-578     | AEBA-578           | 5               | 20216.00  | 14984.00 | 5232.00  | 1817.00  | 814.00   | 1105.00  | 2948.00  | 2103.00  | 1921.00  | 1486.00  | 2790.00  | 2578.00  | 498.00   | 2054.00  | 102.00   | 
    | AEBP21-578     | AEBA-578           | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | AEBA-578           | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | AEBA-578           | 8               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | AEBA-578           | 9               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | AEBA-578           | 10              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | AEBP21-578     | NSF-578            | 1               | 37259.00  | 22341.00 | 14918.00 | 3951.00  | 1405.00  | 3605.00  | 3427.00  | 3729.00  | 3807.00  | 853.00   | 1564.00  | 5848.00  | 2132.00  | 3160.00  | 3778.00  | 
    | AEBP21-578     | NSF-578            | 2               | 16017.00  | 10701.00 | 5316.00  | 994.00   | 717.00   | 1548.00  | 1775.00  | 2828.00  | 653.00   | 757.00   | 1429.00  | 2131.00  | 1760.00  | 154.00   | 1271.00  | 
    | AEBP21-578     | NSF-578            | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | NSF-578            | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | NSF-578            | 5               | 21242.00  | 11640.00 | 9602.00  | 2957.00  | 688.00   | 2057.00  | 1652.00  | 901.00   | 3154.00  | 96.00    | 135.00   | 3717.00  | 372.00   | 3006.00  | 2507.00  | 
    | AEBP21-578     | NSF-578            | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | NSF-578            | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | NSF-578            | 8               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | NSF-578            | 9               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | NSF-578            | 10              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | AEBP21-578     | STFI-578           | 1               | 19601.00  | 12762.00 | 6839.00  | 1176.00  | 3335.00  | 558.00   | 504.00   | 1650.00  | 1912.00  | 2110.00  | 1517.00  | 3296.00  | 677.00   | 148.00   | 2718.00  | 
    | AEBP21-578     | STFI-578           | 2               | 24885.00  | 18097.00 | 6788.00  | 3471.00  | 3639.00  | 1400.00  | 3432.00  | 56.00    | 1045.00  | 1781.00  | 3273.00  | 531.00   | 3323.00  | 2349.00  | 585.00   | 
    | AEBP21-578     | STFI-578           | 3               | 19831.00  | 15056.00 | 4775.00  | 3049.00  | 2961.00  | 1261.00  | 3642.00  | 1182.00  | 178.00   | 470.00   | 2313.00  | 485.00   | 1285.00  | 850.00   | 2155.00  | 
    | AEBP21-578     | STFI-578           | 4               | 19877.00  | 13852.00 | 6025.00  | 2705.00  | 625.00   | 2182.00  | 230.00   | 3368.00  | 3091.00  | 220.00   | 1431.00  | 2483.00  | 309.00   | 3131.00  | 102.00   | 
    | AEBP21-578     | STFI-578           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | STFI-578           | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | STFI-578           | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | STFI-578           | 8               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | STFI-578           | 9               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | STFI-578           | 10              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | STFI-578           | 11              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | AEBP21-578     | STFI-578           | 12              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the RECONCILIATION subnominal aggregations in PaaS
    And   the PaymentGeneration.SubnominalAggregation table contains the following values
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017578 | ORG0017578 | AEBA-578          | 100927          | AEB-AS2122                 | 202109               | RECONCILIATION  | CM             | False       | 2144.18         |
    | 10017578 | ORG0017578 | AEBA-578          | 100928          | AEB-AS2122                 | 202109               | RECONCILIATION  | CM             | False       | 2417.90         |
    | 10017578 | ORG0017578 | AEBA-578          | 100929          | AEB-AS2122                 | 202109               | RECONCILIATION  | CM             | False       | 2509.60         |
    | 10017578 | ORG0017578 | AEBA-578          | 100930          | AEB-AS2122                 | 202109               | RECONCILIATION  | CM             | False       | 3958.47         |
    | 10017578 | ORG0017578 | AEBA-578          | 100931          | AEB-AS2122                 | 202109               | RECONCILIATION  | CM             | False       | 4152.55         |
    | 10017578 | ORG0017578 | AEBA-578          | 2372010         | AEB-AS2122                 | 202109               | RECONCILIATION  | CM             | False       | 3405.49         |
    | 10017578 | ORG0017578 | AEBA-578          | 2372060         | AEB-AS2122                 | 202109               | RECONCILIATION  | CM             | False       | 4524.37         |
    #
    | 10017578 | ORG0017578 | NSF-578           | 100937          | AEB-NSF2122                | 202109               | RECONCILIATION  | CM             | False       | 1317.42         |
    | 10017578 | ORG0017578 | NSF-578           | 100938          | AEB-NSF2122                | 202109               | RECONCILIATION  | CM             | False       | 1059.36         |
    | 10017578 | ORG0017578 | NSF-578           | 100939          | AEB-NSF2122                | 202109               | RECONCILIATION  | CM             | False       | 1427.27         |
    | 10017578 | ORG0017578 | NSF-578           | 100940          | AEB-NSF2122                | 202109               | RECONCILIATION  | CM             | False       | 1773.61         |
    | 10017578 | ORG0017578 | NSF-578           | 100941          | AEB-NSF2122                | 202109               | RECONCILIATION  | CM             | False       | 1240.68         |
    | 10017578 | ORG0017578 | NSF-578           | 100942          | AEB-NSF2122                | 202109               | RECONCILIATION  | CM             | False       | 1519.10         |
    | 10017578 | ORG0017578 | NSF-578           | 100943          | AEB-NSF2122                | 202109               | RECONCILIATION  | CM             | False       | 2702.24         |
    #
    | 10017578 | ORG0017578 | STFI-578          | 2374010         | STFI2122                   | 202109               | RECONCILIATION  | CM             | False       | 14307.90        |
    | 10017578 | ORG0017578 | STFI-578          | 2374020         | STFI2122                   | 202109               | RECONCILIATION  | CM             | False       | 12660.70        |
    | 10017578 | ORG0017578 | STFI-578          | 2374030         | STFI2122                   | 202109               | RECONCILIATION  | CM             | False       | 12966.26        |
    | 10017578 | ORG0017578 | STFI-578          | 2374040         | STFI2122                   | 202109               | RECONCILIATION  | CM             | False       | 9989.68         |

    # Check the CAPPING subnominal aggregations in PaaS
    And   the PaymentGeneration.SubnominalAggregation table contains the following values 
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017578 | ORG0017578 | STFI-578          | 2374010         | STFI2122                   | 202109               | CAPPING         | CM             | False       | -1545.90        |





    # Payment Batch for AEB-AS2122

    # Change the date
    Given the override date is '08/10/2021 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'AEB-AS2122' AccountingPaymentPeriod '202106' CensusEndDate '08/10/2021' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | AEBA-578                 | 202109 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | AEB-AS2122                 | 202109               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | AEB-AS2122                 | 202109               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'AEB-AS2122' PaymentPeriod '202106' CensusEndDate '08/10/2021' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A578_AEBA.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'AEB-AS2122' PaymentPeriod '202106' CensusEndDate '08/10/2021' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | AEBA                   | 2021          | 06             | 08          | ?       | AEBA-578      | 2144.18         | RECONCILIATION   | AdltSkll19+Hardship                | 2021-10-20 | 2021-08-01   | 2022-07-31 | ?              | 10017578 | 100927     |
    | AEBA                   | 2021          | 06             | 08          | ?       | AEBA-578      | 2417.90         | RECONCILIATION   | AdltSkll20+Childcare               | 2021-10-20 | 2021-08-01   | 2022-07-31 | ?              | 10017578 | 100928     |
    | AEBA                   | 2021          | 06             | 08          | ?       | AEBA-578      | 2509.60         | RECONCILIATION   | AdltSkllRsdntlAccess               | 2021-10-20 | 2021-08-01   | 2022-07-31 | ?              | 10017578 | 100929     |
    | AEBA                   | 2021          | 06             | 08          | ?       | AEBA-578      | 3958.47         | RECONCILIATION   | AdltSkllAdminExp                   | 2021-10-20 | 2021-08-01   | 2022-07-31 | ?              | 10017578 | 100930     |
    | AEBA                   | 2021          | 06             | 08          | ?       | AEBA-578      | 4152.55         | RECONCILIATION   | AdltSkllC19Response                | 2021-10-20 | 2021-08-01   | 2022-07-31 | ?              | 10017578 | 100931     |
    | AEBA                   | 2021          | 06             | 08          | ?       | AEBA-578      | 3405.49         | RECONCILIATION   | AEB Other Learning                 | 2021-10-20 | 2021-08-01   | 2022-07-31 | ?              | 10017578 | 2372010    |
    | AEBA                   | 2021          | 06             | 08          | ?       | AEBA-578      | 4524.37         | RECONCILIATION   | AEB OthLearning LngS               | 2021-10-20 | 2021-08-01   | 2022-07-31 | ?              | 10017578 | 2372060    |



    # Retrieve data from the Payment Feed and check for specific items and values (23926)
    Then  there is an item on the Payment feed for FundingStreamPeriod 'AEB-AS2122' AccountingPaymentPeriod '202106' and CensusEndDate '08/10/2021'

    # Title details
    And   the Payment feed item TITLE is as follows
    | Title                                                                                                                                                |
    | Payment Requests for Funding Stream Period AEB-AS2122 for Payment Period 202106 have been generated as of Census End Date/Time 2021-10-08T22:00:00Z. |

    # Summary details
    And   the Payment feed item SUMMARY is as follows
    | FundingStreamPeriod | PaymentPeriod | CensusEndDate         | PaymentLineCount | TotalValue | 
    | AEB-AS2122          | 202106        | 2021-10-08T22:00:00Z  | 7                | 23112.56   |

    # PaymentPeriod details
    And   the Payment feed item PaymentPeriod details are as follows
    | Agency | FSSC      | FSPStartDate | FSPEndDate | CensusEndDate | DueDate    | FinancialYear | FinancialMonth |
    | ESFA   | AEBA      | 01/08/2021   | 31/07/2022 | 08/10/2021    | 20/10/2021 | 2021          | 06             |

    # PaymentDetails
    And   the Payment feed item PaymentDetails are as follows
    | OrgId       | AlternateOrgId | AlternateOrgIdName           | OrgStatusScheme | OrgStatus | AllocRef   | Version | TenderSpecRef | TenderSpecTitle | LotRef | LotSpec | AwardRef                     | ActivityDescription           | InvestmentPriority            | LEPCode | LEPName                       | RegionType       | AgreementNumber | LearningRatePremium | Subnominal | PaymentType    | SubnominalDescription         | AggregatedValue |
    | ORG0017578  | 10017578       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | AEBA-578   | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 100927     | RECONCILIATION | AdltSkll19+Hardship           | 2144.18         |
    | ORG0017578  | 10017578       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | AEBA-578   | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 100928     | RECONCILIATION | AdltSkll20+Childcare          | 2417.90         |
    | ORG0017578  | 10017578       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | AEBA-578   | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 100929     | RECONCILIATION | AdltSkllRsdntlAccess          | 2509.60         |
    | ORG0017578  | 10017578       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | AEBA-578   | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 100930     | RECONCILIATION | AdltSkllAdminExp              | 3958.47         |
    | ORG0017578  | 10017578       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | AEBA-578   | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 100931     | RECONCILIATION | AdltSkllC19Response           | 4152.55         |
    | ORG0017578  | 10017578       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | AEBA-578   | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2372010    | RECONCILIATION | AEB Other Learning            | 3405.49         |
    | ORG0017578  | 10017578       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | AEBA-578   | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2372060    | RECONCILIATION | AEB OthLearning LngS          | 4524.37         |





    # Payment Batch stuff starts here for AEB-NSF2122

    # Change the date
    Given the override date is '08/10/2021 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'AEB-NSF2122' AccountingPaymentPeriod '202106' CensusEndDate '08/10/2021' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | NSF-578                  | 202109 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | AEB-NSF2122                | 202109               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | AEB-NSF2122                | 202109               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'AEB-NSF2122' PaymentPeriod '202106' CensusEndDate '08/10/2021' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A578_NSF.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'AEB-NSF2122' PaymentPeriod '202106' CensusEndDate '08/10/2021' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | NSF                    | 2021          | 06             | 08          | ?       | NSF-578       | 1317.42         | RECONCILIATION   | NSF 19+ Hardship                   | 2021-10-20 | 2021-08-01   | 2022-07-31 | ?              | 10017578 | 100937     |
    | NSF                    | 2021          | 06             | 08          | ?       | NSF-578       | 1059.36         | RECONCILIATION   | NSF 20+ Childcare                  | 2021-10-20 | 2021-08-01   | 2022-07-31 | ?              | 10017578 | 100938     |
    | NSF                    | 2021          | 06             | 08          | ?       | NSF-578       | 1427.27         | RECONCILIATION   | NSF RsdntlAccessFund               | 2021-10-20 | 2021-08-01   | 2022-07-31 | ?              | 10017578 | 100939     |
    | NSF                    | 2021          | 06             | 08          | ?       | NSF-578       | 1773.61         | RECONCILIATION   | NSF Admin Exp                      | 2021-10-20 | 2021-08-01   | 2022-07-31 | ?              | 10017578 | 100940     |
    | NSF                    | 2021          | 06             | 08          | ?       | NSF-578       | 1240.68         | RECONCILIATION   | NSF COVID19 Response               | 2021-10-20 | 2021-08-01   | 2022-07-31 | ?              | 10017578 | 100941     |
    | NSF                    | 2021          | 06             | 08          | ?       | NSF-578       | 1519.10         | RECONCILIATION   | NSF Programme                      | 2021-10-20 | 2021-08-01   | 2022-07-31 | ?              | 10017578 | 100942     |
    | NSF                    | 2021          | 06             | 08          | ?       | NSF-578       | 2702.24         | RECONCILIATION   | NSF Learning Support               | 2021-10-20 | 2021-08-01   | 2022-07-31 | ?              | 10017578 | 100943     |



    # Retrieve data from the Payment Feed and check for specific items and values (23926)
    Then  there is an item on the Payment feed for FundingStreamPeriod 'AEB-NSF2122' AccountingPaymentPeriod '202106' and CensusEndDate '08/10/2021'

    # Title details
    And   the Payment feed item TITLE is as follows
    | Title                                                                                                                                                 |
    | Payment Requests for Funding Stream Period AEB-NSF2122 for Payment Period 202106 have been generated as of Census End Date/Time 2021-10-08T22:00:00Z. |

    # Summary details
    And   the Payment feed item SUMMARY is as follows
    | FundingStreamPeriod | PaymentPeriod | CensusEndDate         | PaymentLineCount | TotalValue | 
    | AEB-NSF2122         | 202106        | 2021-10-08T22:00:00Z  | 7                | 11039.68   |

    # PaymentPeriod details
    And   the Payment feed item PaymentPeriod details are as follows
    | Agency | FSSC      | FSPStartDate | FSPEndDate | CensusEndDate | DueDate    | FinancialYear | FinancialMonth |
    | ESFA   | NSF       | 01/08/2021   | 31/07/2022 | 08/10/2021    | 20/10/2021 | 2021          | 06             |

    # PaymentDetails
    And   the Payment feed item PaymentDetails are as follows
    | OrgId       | AlternateOrgId | AlternateOrgIdName           | OrgStatusScheme | OrgStatus | AllocRef   | Version | TenderSpecRef | TenderSpecTitle | LotRef | LotSpec | AwardRef                     | ActivityDescription           | InvestmentPriority            | LEPCode | LEPName                       | RegionType       | AgreementNumber | LearningRatePremium | Subnominal | PaymentType    | SubnominalDescription         | AggregatedValue |
    | ORG0017578  | 10017578       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | NSF-578    | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 100937     | RECONCILIATION | NSF 19+ Hardship              | 1317.42         |
    | ORG0017578  | 10017578       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | NSF-578    | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 100938     | RECONCILIATION | NSF 20+ Childcare             | 1059.36         |
    | ORG0017578  | 10017578       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | NSF-578    | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 100939     | RECONCILIATION | NSF RsdntlAccessFund          | 1427.27         |
    | ORG0017578  | 10017578       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | NSF-578    | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 100940     | RECONCILIATION | NSF Admin Exp                 | 1773.61         |
    | ORG0017578  | 10017578       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | NSF-578    | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 100941     | RECONCILIATION | NSF COVID19 Response          | 1240.68         |
    | ORG0017578  | 10017578       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | NSF-578    | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 100942     | RECONCILIATION | NSF Programme                 | 1519.10         |
    | ORG0017578  | 10017578       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | NSF-578    | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 100943     | RECONCILIATION | NSF Learning Support          | 2702.24         |





    # Payment Batch stuff starts here for STFI2122

    # Change the date
    Given the override date is '08/10/2021 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'STFI2122' AccountingPaymentPeriod '202106' CensusEndDate '08/10/2021' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | STFI-578                 | 202109 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | STFI2122                   | 202109               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | STFI2122                   | 202109               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'STFI2122' PaymentPeriod '202106' CensusEndDate '08/10/2021' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A578_STFI.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'STFI2122' PaymentPeriod '202106' CensusEndDate '08/10/2021' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | STFI                   | 2021          | 06             | 08          | ?       | STFI-578      | 14307.90        | RECONCILIATION   | ShortTermInit1Cntrct               | 2021-10-20 | 2021-08-01   | 2022-07-31 | ?              | 10017578 | 2374010    |
    | STFI                   | 2021          | 06             | 08          | ?       | STFI-578      | 12660.70        | RECONCILIATION   | ShortTermInit2Cntrct               | 2021-10-20 | 2021-08-01   | 2022-07-31 | ?              | 10017578 | 2374020    |
    | STFI                   | 2021          | 06             | 08          | ?       | STFI-578      | 12966.26        | RECONCILIATION   | ShortTermInit3Cntrct               | 2021-10-20 | 2021-08-01   | 2022-07-31 | ?              | 10017578 | 2374030    |
    | STFI                   | 2021          | 06             | 08          | ?       | STFI-578      | 9989.68         | RECONCILIATION   | ShortTermInit4Cntrct               | 2021-10-20 | 2021-08-01   | 2022-07-31 | ?              | 10017578 | 2374040    |
    #
    | STFI                   | 2021          | 06             | 08          | ?       | STFI-578      | -1545.90        | CAPPING          | ShortTermInit1Cntrct               | 2021-10-20 | 2021-08-01   | 2022-07-31 | ?              | 10017578 | 2374010    |



    # Retrieve data from the Payment Feed and check for specific items and values (23926)
    Then  there is an item on the Payment feed for FundingStreamPeriod 'STFI2122' AccountingPaymentPeriod '202106' and CensusEndDate '08/10/2021'

    # Title details
    And   the Payment feed item TITLE is as follows
    | Title                                                                                                                                              |
    | Payment Requests for Funding Stream Period STFI2122 for Payment Period 202106 have been generated as of Census End Date/Time 2021-10-08T22:00:00Z. |

    # Summary details
    And   the Payment feed item SUMMARY is as follows
    | FundingStreamPeriod | PaymentPeriod | CensusEndDate         | PaymentLineCount | TotalValue | 
    | STFI2122            | 202106        | 2021-10-08T22:00:00Z  | 5                | 48378.64   |

    # PaymentPeriod details
    And   the Payment feed item PaymentPeriod details are as follows
    | Agency | FSSC      | FSPStartDate | FSPEndDate | CensusEndDate | DueDate    | FinancialYear | FinancialMonth |
    | ESFA   | STFI      | 01/08/2021   | 31/07/2022 | 08/10/2021    | 20/10/2021 | 2021          | 06             |

    # PaymentDetails
    And   the Payment feed item PaymentDetails are as follows
    | OrgId       | AlternateOrgId | AlternateOrgIdName           | OrgStatusScheme | OrgStatus | AllocRef   | Version | TenderSpecRef | TenderSpecTitle | LotRef | LotSpec | AwardRef                     | ActivityDescription           | InvestmentPriority            | LEPCode | LEPName                       | RegionType       | AgreementNumber | LearningRatePremium | Subnominal | PaymentType    | SubnominalDescription         | AggregatedValue |
    | ORG0017578  | 10017578       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | STFI-578   | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2374010    | RECONCILIATION | ShortTermInit1Cntrct          | 14307.90        |
    | ORG0017578  | 10017578       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | STFI-578   | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2374020    | RECONCILIATION | ShortTermInit2Cntrct          | 12660.70        |
    | ORG0017578  | 10017578       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | STFI-578   | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2374030    | RECONCILIATION | ShortTermInit3Cntrct          | 12966.26        |
    | ORG0017578  | 10017578       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | STFI-578   | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2374040    | RECONCILIATION | ShortTermInit4Cntrct          | 9989.68         |
    #
    | ORG0017578  | 10017578       | UK PROVIDER REFERENCE NUMBER | LEGAL           | ACTIVE    | STFI-578   | 1       | ?             | ?               | ?      | ?       | ?                            | ?                             | ?                             | ?       | ?                             | ?                | ?               | ?                   | 2374010    | CAPPING        | ShortTermInit1Cntrct          | -1545.90        |


    # Tidy Up
    And    the override date is reset   
  
@AcceptanceTest @Withdrawn20231002
Scenario: A087 Create and publish an AEB2122 contract. Withdraw v1. Revised New v2. Approve. Variation amendment. Bulk new amendment for 22/23. Check doc parts
    
    #  1. Create a draft 21/22 contract
    #  2. Withdraw contract v1
    #  3. Bulk amend the 21/22 contract (Revised New) and check docs
    #  4. Publish and approve 21/22 v2
    #  5. NFA amendment on 21/22 v2 then check docs    
    #  6. Attempt to add a 22/23 contract by bulk upload (New Amendment) but fail (MBR-005)
    #  7. Publish and approve 21/22 contract
    #  8. Successfully add a 22/23 contract by bulk upload (New Amendment)
    #  9. Publish and approve 22/23 contract
    # 10. NFA amend 22/23 and check docs
    # 11. Publish and approve 22/23 v2
    
    Given there are no allocations marked as Under Termination for UKPRN '10017087' 
    And   there are no terminated or closed allocations for UKPRN '10017087' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017087' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017087' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017087' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AEBA-087      |
    | NSF-087       |
    | STFI-087      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | AEBA-087      |
    | NSF-087       |
    | STFI-087      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | AEB-AS2122        |
    | AEB-NSF2122       |
    | STFI2122          |
    #
    | AEB-AS2223        |
    | AEB-NSF2223       |
    | STFI2223          |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | AEBP21-087     | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017087'

    # Set the 'base' timestamp for each of the 21/22 and 22/23 AEB document templates (DocumentsDomain.UploadedDocumentTemplate) (J107) 
    And   the following document templates have Upload timestamps as indicated 
    | DocumentTemplateName                            | UploadTimestamp         | 
    | SOF_AEB2021_2021-08-01.docx                     | 2021-06-10 12:00:00.000 | 
    #
    | AEB2021_2122_TAC_2021-08-01.docx                | 2021-06-10 12:00:00.000 | 
    | AEB2021_2122_S1_2021-08-01.docx                 | 2021-06-10 12:00:00.000 | 
    | AEB2021_2122_S2_2021-08-01.docx                 | 2021-06-10 12:00:00.000 | 
    | FA_AEB2021_2122_2021-08-01.docx                 | 2021-06-10 12:00:00.000 | 
    | AEB2021_2122_S3ON_2021-08-01.docx               | 2021-06-10 12:00:00.000 | 
    #
    | AEB2021_2223_TAC_2022-08-01.docx                | 2022-06-20 12:00:00.000 |
    | AEB2021_2223_S1_2022-08-01.docx                 | 2022-06-20 12:00:00.000 |
    | AEB2021_2223_S2_2022-08-01.docx                 | 2022-06-20 12:00:00.000 |
    | FA_AEB2021_2223_2022-08-01.docx                 | 2022-06-20 12:00:00.000 |
    | AEB2021_2223_S3ON_2022-08-01.docx               | 2022-06-20 12:00:00.000 |



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017087' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017087 Co Ltd' with UKPRN '10017087' and OrgId 'ORG0017087' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017087' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017087 | 117087 | 10017087 Co Ltd | 0              | Active                | Yes           | AA017087      | ?             | 14 Daisy Way           | High Lane              | ?                      | ?                      | Stockport              | Cheshire               | SK6 8EF   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017087 |





    # Part 1: Create a draft 21/22 contract
    
    # Change the date
    Given the override date is '11/06/2021'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'AEBP21-087'
    And   there are no details in ContractManagement.CreatedContract for 'AEBP21-087'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017087 | 10017087 Co Ltd      | ESFA-087             | AEBP21-087     | 1                     | 01/08/2021        | 31/07/2022      | 170047.00     |                                       | Contract for Services                      | 2122   | New          | ORG0017087 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017087 | AEBP21-087     | AEBA-087      | AEB-AS            | AEB-AS2122              | AY                      | 01/08/2021          | 31/07/2022        | 41398.00        |                                         |            |                                                             | New          |             |
    | 10017087 | AEBP21-087     | NSF-087       | AEB-NSF           | AEB-NSF2122             | AY                      | 01/08/2021          | 31/07/2022        | 46335.00        |                                         |            |                                                             | New          |             |
    | 10017087 | AEBP21-087     | STFI-087      | STFI              | STFI2122                | AY                      | 01/08/2021          | 31/07/2022        | 82314.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-21   | Sep-21   | Oct-21   | Nov-21   | Dec-21   | Jan-22   | Feb-22   | Mar-22   | Apr-22   | May-22   | Jun-22   | Jul-22   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017087 | AEBP21-087     | AEBA-087      | 1               | 0                     | 41398.00  | 26989.00  | 14409.00  | 3026.00  | 5003.00  | 5492.00  | 3041.00  | 2993.00  | 2157.00  | 3911.00  | 1366.00  | 3565.00  | 3387.00  | 3689.00  | 3768.00  | Adult Skills Total Funding                                      | New          |             | 
    | 10017087 | AEBP21-087     | AEBA-087      | 4               | 1                     | 21676.00  | 14599.00  | 7077.00   | 2026.00  | 3331.00  | 3118.00  | 1038.00  | 2595.00  | 643.00   | 1062.00  | 786.00   | 1616.00  | 1843.00  | 2896.00  | 722.00   | Adult Skills                                                    | New          |             | 
    | 10017087 | AEBP21-087     | AEBA-087      | 5               | 1                     | 19722.00  | 12390.00  | 7332.00   | 1000.00  | 1672.00  | 2374.00  | 2003.00  | 398.00   | 1514.00  | 2849.00  | 580.00   | 1949.00  | 1544.00  | 793.00   | 3046.00  | Adult Skills Learner Support                                    | New          |             | 
    #
    | 10017087 | AEBP21-087     | NSF-087       | 1               | 0                     | 46335.00  | 31188.00  | 15147.00  | 4477.00  | 3923.00  | 5584.00  | 3320.00  | 5425.00  | 3795.00  | 3019.00  | 1645.00  | 4031.00  | 2307.00  | 3779.00  | 5030.00  | National Skills Fund Total Funding                              | New          |             | 
    | 10017087 | AEBP21-087     | NSF-087       | 2               | 1                     | 30992.00  | 19904.00  | 11088.00  | 3568.00  | 3607.00  | 3489.00  | 143.00   | 2777.00  | 2278.00  | 2792.00  | 1250.00  | 2174.00  | 2120.00  | 3266.00  | 3528.00  | Level 3 Offer for 24 year olds and over                         | New          |             | 
    | 10017087 | AEBP21-087     | NSF-087       | 5               | 1                     | 15343.00  | 11284.00  | 4059.00   | 909.00   | 316.00   | 2095.00  | 3177.00  | 2648.00  | 1517.00  | 227.00   | 395.00   | 1857.00  | 187.00   | 513.00   | 1502.00  | National Skills Fund Learner Support                            | New          |             | 
    #
    | 10017087 | AEBP21-087     | STFI-087      | 1               | 0                     | 21976.00  | 13238.00  | 8738.00   | 2348.00  | 139.00   | 1098.00  | 188.00   | 2916.00  | 1152.00  | 2743.00  | 2654.00  | 954.00   | 3336.00  | 875.00   | 3573.00  | Short Term Funding Initiative 1                                 | New          |             | 
    | 10017087 | AEBP21-087     | STFI-087      | 2               | 0                     | 21144.00  | 14571.00  | 6573.00   | 2509.00  | 651.00   | 2524.00  | 3324.00  | 2889.00  | 493.00   | 280.00   | 1901.00  | 3458.00  | 1506.00  | 943.00   | 666.00   | Short Term Funding Initiative 2                                 | New          |             | 
    | 10017087 | AEBP21-087     | STFI-087      | 3               | 0                     | 18443.00  | 14583.00  | 3860.00   | 683.00   | 1894.00  | 2946.00  | 772.00   | 3594.00  | 565.00   | 2250.00  | 1879.00  | 273.00   | 407.00   | 2724.00  | 456.00   | Short Term Funding Initiative 3                                 | New          |             | 
    | 10017087 | AEBP21-087     | STFI-087      | 4               | 0                     | 20751.00  | 10281.00  | 10470.00  | 1434.00  | 2012.00  | 1261.00  | 3514.00  | 456.00   | 495.00   | 377.00   | 732.00   | 2383.00  | 2867.00  | 3381.00  | 1839.00  | Short Term Funding Initiative 4                                 | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | AEBP21-087     | 1                     | 0                        | 2021-06-11 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'AEBP21-087'



  

     # Part 2: Withdraw contract v1

     # Change the date
     Given the override date is '13/06/2021'

     # Contract Withdrawal
     When  the next action performed on the latest version of contract 'AEBP21-087' is 'Withdraw On Behalf Of Provider' with reason 'Director absconded' by 'FCS2 Test'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017087 | AEBP21-087         | 1                     | 0                        | Withdrawn        | Withdrawn By Provider                     | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017087 | ESFA-087           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |





    # Part 3: Bulk amend the 21/22 contract (Revised New) and check docs

    Given the override date is '15/06/2021'

    # Bulk file 'Revised New' amendment
    And   there are no files prefixed '10017087' in the Sharepoint 'AEB2021-2122-Input-Appendices' folder
    And   there are no files prefixed 'AEB2021 AY 2122 15062021142510 v3_A087' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'AEB2021 AY 2122 15062021142510 v3_A087' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'AEB2021 AY 2122 15062021142510 v3_A087' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB2021 AY 2122 15062021142510 v3_A087' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB2021 AY 2122 15062021142510 v3_A087.xlsx' exists in the Datafiles folder and UKPRN '10017087' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10017087' for FundingType 'AEB2021' and period '2122'

    # Check the contents of the Appendices (All doc parts should be present)
    Then  the file named '10017087_AEBP21-087_v2.pdf' in Sharepoint location 'AEB2021-2122-Input-Appendices' contains the following lines in order
    """ 
    SUMMARY OF FUNDING
    Organisation Name: 10017087 Co Ltd UKPRN: 10017087
    Master Contract Number: ESFA-087
    Allocation
    1 August 2021 to 31 July 2022 Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 Total
    ESFA AEB - Adult Skills (procured from Aug 2021) [AllocRef_AEBA] £56,102 £31,723 £87,825
    of which Learner Support £21,661 £15,182 £36,843
    ESFA AEB - National Skills Fund (procured from Aug 2021) [AllocRef_NSF] £64,495 £27,721 £92,216
    of which Level 3 Offer for 24 year olds and over £34,661 £15,596 £50,257
    of which Learner Support £29,834 £12,125 £41,959
    ESFA AEB - Short Term Funding Initiatives (procured from
    [AllocRef_STFI] £146,068 £61,138 £207,206
    Aug 2021)
    of which Short Term Funding Initiative 1 £31,080 £14,860 £45,940
    of which Short Term Funding Initiative 2 £42,153 £13,502 £55,655
    of which Short Term Funding Initiative 3 £37,948 £22,099 £60,047
    of which Short Term Funding Initiative 4 £34,887 £10,677 £45,564
    Total: £387,247
    Total Funding for this contract: £387,247
    Summary of Funding – Page 1
    
    Agreement Type Contract for Services
    Funding Period 1 August 2021 to 31 July 2022
    Between the Secretary of State for Education
    And 10017087 Co Ltd
    Funding for ESFA Adult Education Budget (Contract for Services)
    Master Contract Number ESFA-087
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by John Edwards, Interim Chief Executive of the Education & Skills Funding Agency
    This Contract is made on the date the Contract is digitally signed by the
    Contractor on the Manage Your Education & Skills Funding Service between:
    10017087 Co Ltd THE SECRETARY OF STATE FOR
    14 Daisy Way EDUCATION
    High Lane DEPARTMENT FOR EDUCATION
    Stockport 20 GREAT SMITH STREET
    AND
    Cheshire LONDON
    SK6 8EF SW1P 3BT
    Company No: AA017087
    Hereinafter called Hereinafter called
    the Contractor the Department
    ESFA Adult Education Budget (Procured) Version 3 (April 2022) - Page 2
    ESFA Adult Education Budget (Procured) Version 3 (April 2022) - Page 78
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    ESFA ADULT EDUCATION BUDGET CONTRACT FOR SERVICES 2021/22
    ESFA Adult Education Budget (Procured) Schedule 1 Version 2 (March 2022) – Page 1
    ESFA Adult Education Budget (Procured) Schedule 1 Version 2 (March 2022) – Page 12
    
    SCHEDULE 2: PAYMENT
    ESFA ADULT EDUCATION BUDGET (CONTRACT FOR SERVICES)
    4. The Department will pay the Contractor on the 14 Working Day of each
    month.
    ESFA Adult Education Budget (Procured) Schedule 2 Version 1 (July 2021) – Page 1
    ESFA Adult Education Budget (Procured) Schedule 2 Version 1 (July 2021) – Page 2
    
    SCHEDULE 2
    Funding Agreement – ESFA-Funded Adult Education Budget - Adult Skills (procured from Aug 2021)
    Provider: 10017087 Co Ltd UKPRN: 10017087
    Master Contract Number: ESFA-087 Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_AEBA]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    ESFA AEB - Adult Skills £87,825 £8,521 £11,280 £3,499 £8,828 £4,517 £5,771 £5,739 £7,947 £9,274 £7,405 £5,059 £9,985
    of which Learner Support £36,843 £3,751 £7,169 £1,139 £3,326 £491 £3,156 £1,001 £1,628 £5,587 £3,771 £3,379 £2,445
    Total Funding £87,825 £8,521 £11,280 £3,499 £8,828 £4,517 £5,771 £5,739 £7,947 £9,274 £7,405 £5,059 £9,985
    Schedule 2 – Funding Agreement [AllocRef_AEBA] – Page 1 Ref (for internal use only):  AEBP21-087 v2
    
    SCHEDULE 2
    Funding Agreement – ESFA-Funded Adult Education Budget - National Skills Fund (procured from Aug 2021)
    Provider: 10017087 Co Ltd UKPRN: 10017087
    Master Contract Number: ESFA-087 Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_NSF]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    ESFA AEB - National Skills Fund £92,216 £11,417 £12,469 £7,203 £7,098 £5,303 £9,072 £3,605 £8,328 £7,947 £8,594 £8,764 £2,416
    of which Level 3 Offer for 24 year olds and over £50,257 £7,678 £7,221 £2,752 £6,097 £1,903 £2,805 £2,211 £3,994 £4,483 £6,744 £2,073 £2,296
    of which Learner Support £41,959 £3,739 £5,248 £4,451 £1,001 £3,400 £6,267 £1,394 £4,334 £3,464 £1,850 £6,691 £120
    Total Funding £92,216 £11,417 £12,469 £7,203 £7,098 £5,303 £9,072 £3,605 £8,328 £7,947 £8,594 £8,764 £2,416
    Schedule 2 – Funding Agreement [AllocRef_NSF] – Page 1 Ref (for internal use only):  AEBP21-087 v2
    
    SCHEDULE 2
    Funding Agreement – ESFA-Funded Adult Education Budget - Short Term Funding Initiatives (procured from Aug 2021)
    Provider: 10017087 Co Ltd UKPRN: 10017087
    Master Contract Number: ESFA-087 Start Date: 01/08/2021 End Date: 31/07/2022
    Contract Ref: [AllocRef_STFI]
    Cash (£) Aug 2021 Sep 2021 Oct 2021 Nov 2021 Dec 2021 Jan 2022 Feb 2022 Mar 2022 Apr 2022 May 2022 Jun 2022 Jul 2022
    ESFA AEB - Short Term Funding Initiative 1 £45,940 £700 £445 £1,210 £6,868 £5,796 £6,900 £3,588 £5,573 £5,456 £7,919 £530 £955
    ESFA AEB - Short Term Funding Initiative 2 £55,655 £7,632 £3,503 £5,828 £4,692 £2,261 £7,442 £7,802 £2,993 £7,357 £106 £2,229 £3,810
    ESFA AEB - Short Term Funding Initiative 3 £60,047 £7,017 £1,125 £7,122 £5,031 £1,242 £4,660 £4,469 £7,282 £4,447 £7,112 £4,957 £5,583
    ESFA AEB - Short Term Funding Initiative 4 £45,564 £1,592 £5,615 £7,335 £6,400 £1,252 £795 £4,277 £7,621 £3,428 £2,218 £1,624 £3,407
    Total Funding £207,206 £16,941 £10,688 £21,495 £22,991 £10,551 £19,797 £20,136 £23,469 £20,688 £17,355 £9,340 £13,755
    Schedule 2 – Funding Agreement [AllocRef_STFI] – Page 1 Ref (for internal use only):  AEBP21-087 v2
    
    SCHEDULE 3: CHANGE CONTROL PROCEDURE
    ESFA Adult Education Budget (Procured) Schedule 3 Version 1 (July 2021) – Page 1
    """

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | AEBP21-087     | 2                     | 0                        | 2021-06-15 12:06:22.000 |

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017087_AEBP21-087_v2.pdf' in 'AEB2021-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A087.pdf'





    # Part 4: Publish and approve v2

    Given the override date is '16/06/2021'
    
    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'AEBP21-087'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-087' and ContractNumber 'AEBP21-087' and Version '2'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP21-087' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017087 | AEBP21-087         | 2                     | 0                        | Approved         | Approved                                  | True          | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017087 | AEBP21-087         | 1                     | 0                        | Withdrawn        | Withdrawn By Provider                     | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017087 | ESFA-087           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |





    # Part 5: NFA amendment on v2 then check docs (No doc templates have changed since v2 was generated)

    # Change the date
    Given the override date is '18/06/2021'

    # Issue a non-financial VARIATION amendment on v3 to create v3
    When  a request is raised by advisor 'FCS2 Test' against version '2' subversion '0' of contract 'AEBP21-087' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017087 | AEBP21-087         | 3                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017087 | AEBP21-087         | 2                     | 0                        | Approved         | Approved                                  | False         | True                | 01/08/2021        | 31/07/2022      | ?             |
    | 10017087 | AEBP21-087         | 1                     | 0                        | Withdrawn        | Withdrawn By Provider                     | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017087 | ESFA-087           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the contents of the Appendices  (Only SoF)
    Then  the file named '10017087_AEBP21-087_v3.pdf' in Sharepoint location 'AEB2021-2122-Input-Appendices' contains the following lines in order
    """ 
    SUMMARY OF FUNDING
    Organisation Name: 10017087 Co Ltd UKPRN: 10017087
    Master Contract Number: ESFA-087
    Allocation
    1 August 2021 to 31 July 2022 Contract Ref Aug 21 - Mar 22 Apr 22 - Jul 22 Total
    ESFA AEB - Adult Skills (procured from Aug 2021) [AllocRef_AEBA] £56,102 £31,723 £87,825
    of which Learner Support £21,661 £15,182 £36,843
    ESFA AEB - National Skills Fund (procured from Aug 2021) [AllocRef_NSF] £64,495 £27,721 £92,216
    of which Level 3 Offer for 24 year olds and over £34,661 £15,596 £50,257
    of which Learner Support £29,834 £12,125 £41,959
    ESFA AEB - Short Term Funding Initiatives (procured from
    [AllocRef_STFI] £146,068 £61,138 £207,206
    Aug 2021)
    of which Short Term Funding Initiative 1 £31,080 £14,860 £45,940
    of which Short Term Funding Initiative 2 £42,153 £13,502 £55,655
    of which Short Term Funding Initiative 3 £37,948 £22,099 £60,047
    of which Short Term Funding Initiative 4 £34,887 £10,677 £45,564
    Total: £387,247
    Total Funding for this contract: £387,247
    Summary of Funding – Page 1
    """

    # There shouldn't be a T&C doc
    And   the pdf file does not contain the following text
    """
    Agreement Type Contract for Services
    """

    # There shouldn't be a Sch1 doc
    And   the pdf file does not contain the following text
    """
    SCHEDULE 1: SPECIFICATION & MONITORING
    """

    # There shouldn't be a Sch2 doc
    And   the pdf file does not contain the following text
    """  
    SCHEDULE 2: PAYMENT
    """
    
    # There shouldn't be a Funding Agreement for Adult Skills
    And   the pdf file does not contain the following text
    """  
    Funding Agreement – ESFA-Funded Adult Education Budget - Adult Skills (procured from Aug 2021)
    """

    # There shouldn't be a Funding Agreement for National Skills Fund
    And   the pdf file does not contain the following text
    """  
    Funding Agreement – ESFA-Funded Adult Education Budget - National Skills Fund (procured from Aug 2021)
    """

    # There shouldn't be a Funding Agreement for Short Term Funding Initiatives
    And   the pdf file does not contain the following text
    """  
    Funding Agreement – ESFA-Funded Adult Education Budget - Short Term Funding Initiatives (procured from Aug 2021)
    """

    # There shouldn't be a Sch3ON doc
    And   the pdf file does not contain the following text
    """  
    SCHEDULE 3: CHANGE CONTROL PROCEDURE
    """    
    
    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | AEBP21-087     | 3                     | 0                        | 2021-06-18 12:06:22.000 |
    
    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017087_AEBP21-087_v3.pdf' in 'AEB2021-2122-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A087a.pdf'





    # Part 6: Attempt to add a 22/23 contract by bulk upload (New Amendment) but fail (MBR-005)

    # Change the date
    Given the override date is '01/07/2022'

    # Bulk file
    And   there are no files prefixed '10017087' in the Sharepoint 'AEB2021-2223-Input-Appendices' folder
    And   there are no files prefixed 'AEB2021 AY 2223 26052022125431 v3_A087' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'AEB2021 AY 2223 26052022125431 v3_A087' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'AEB2021 AY 2223 26052022125431 v3_A087' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB2021 AY 2223 26052022125431 v3_A087' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB2021 AY 2223 26052022125431 v3_A087.xlsx' exists in the Datafiles folder and UKPRN '10017087' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
   #And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report
    And   'Failed' is displayed in field 'J2' on the 'Contract' tab of the result report

    # MBR-005
    And   '[Contract] This Master Contract cannot have more than one associated Contract in a draft status at the same time' is displayed in field 'J2' on the 'Contract' tab of the result report
 




    # Part 7: Publish and approve 21/22 contract

    # Change the date
    Given the override date is '03/07/2022'
    
    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'AEBP21-087'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-087' and ContractNumber 'AEBP21-087' and Version '3'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP21-087' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017087 | AEBP21-087         | 3                     | 0                        | Approved         | Approved                                  | True          | True                | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017087 | AEBP21-087         | 2                     | 0                        | Replaced         | Approved                                  | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017087 | AEBP21-087         | 1                     | 0                        | Withdrawn        | Withdrawn By Provider                     | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017087 | ESFA-087           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |





    # Part 8: Successfully add a 22/23 contract by bulk upload (New Amendment)

    # Change the date
    Given the override date is '05/07/2022'

    # Bulk file
    And   there are no files prefixed '10017087' in the Sharepoint 'AEB2021-2223-Input-Appendices' folder
    And   there are no files prefixed 'AEB2021 AY 2223 26052022125431 v3_A087' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'AEB2021 AY 2223 26052022125431 v3_A087' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'AEB2021 AY 2223 26052022125431 v3_A087' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB2021 AY 2223 26052022125431 v3_A087' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB2021 AY 2223 26052022125431 v3_A087.xlsx' exists in the Datafiles folder and UKPRN '10017087' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Retrieve parameters for 22/23
    When  I retrieve the latest contract details from CRM for provider '10017087' for FundingType 'AEB2021' and period '2223'

    # Check the SoF details for 22/23 and the rest of the docs
    Then  the file named '10017087_[ContractNo]_v1.pdf' in Sharepoint location 'AEB2021-2223-Input-Appendices' contains the following lines in order
    """ 
    SUMMARY OF FUNDING
    Organisation Name: 10017087 Co Ltd UKPRN: 10017087
    Master Contract Number: ESFA-087
    Allocation
    1 August 2022 to 31 July 2023 Contract Ref Aug 22 - Mar 23 Apr 23 - Jul 23 Total
    ESFA AEB - Adult Skills (procured from Aug 2021) [AllocRef_AEBA] £72,491 £24,015 £96,506
    of which Learner Support £37,806 £4,837 £42,643
    ESFA AEB - National Skills Fund (procured from Aug 2021) [AllocRef_NSF] £51,431 £35,475 £86,906
    of which Level 3 Free Courses for Jobs £20,180 £16,957 £37,137
    of which Learner Support £31,251 £18,518 £49,769
    ESFA AEB - Short Term Funding Initiatives (procured from
    [AllocRef_STFI] £139,113 £64,232 £203,345
    Aug 2021)
    of which Short Term Funding Initiative 1 £25,559 £10,144 £35,703
    of which Short Term Funding Initiative 2 £34,025 £19,658 £53,683
    of which Short Term Funding Initiative 3 £42,988 £23,330 £66,318
    of which Short Term Funding Initiative 4 £36,541 £11,100 £47,641
    Total: £386,757
    Total Funding for this contract: £774,004
    Summary of Funding – Page 1
    
    Agreement Type Contract for Services
    Funding Period 1 August 2021 to 31 July 2023
    Between the Secretary of State for Education
    And 10017087 Co Ltd
    Funding for ESFA Adult Education Budget (Contract for Services)
    Master Contract Number ESFA-087
    ACCEPTANCE BY THE CONTRACTOR
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by David Withey, Chief Executive of the Education and Skills Funding Agency
    This Contract is made on the date the Contract is digitally signed by the
    Contractor on the Manage Your Education & Skills Funding Service between:
    10017087 Co Ltd THE SECRETARY OF STATE FOR
    14 Daisy Way EDUCATION
    High Lane DEPARTMENT FOR EDUCATION
    Stockport 20 GREAT SMITH STREET
    AND
    Cheshire LONDON
    SK6 8EF SW1P 3BT
    Company No: AA017087
    Hereinafter called Hereinafter called
    the Contractor the Department
    ESFA Adult Education Budget (Procured) Version 4 (July 2022) - Page 2
    ESFA Adult Education Budget (Procured) Version 4 (July 2022) - Page 78
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    ESFA ADULT EDUCATION BUDGET CONTRACT FOR SERVICES
    ESFA Adult Education Budget (Procured) Schedule 1 Version 3 (July 2022) – Page 1
    ESFA Adult Education Budget (Procured) Schedule 1 Version 3 (July 2022) – Page 12
    
    SCHEDULE 2: PAYMENT
    ESFA ADULT EDUCATION BUDGET (CONTRACT FOR SERVICES)
    5. The Department will pay the Contractor on the 16 Working Day of each
    month.
    ESFA Adult Education Budget (Procured) Schedule 2 Version 3 (February 2023) – Page 1
    ESFA Adult Education Budget (Procured) Schedule 2 Version 3 (February 2023) – Page 2

    SCHEDULE 2
    Funding Agreement – ESFA-Funded Adult Education Budget - Adult Skills (procured from Aug 2021)
    Provider: 10017087 Co Ltd UKPRN: 10017087
    Master Contract Number: ESFA-087 Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: [AllocRef_AEBA]
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    ESFA AEB - Adult Skills £96,506 £10,115 £10,010 £8,214 £11,983 £6,515 £11,240 £10,859 £3,555 £3,725 £5,326 £6,855 £8,109
    of which Learner Support £42,643 £5,907 £2,457 £4,855 £7,722 £2,849 £5,790 £4,920 £3,306 £196 £1,575 £1,660 £1,406
    Total Funding £96,506 £10,115 £10,010 £8,214 £11,983 £6,515 £11,240 £10,859 £3,555 £3,725 £5,326 £6,855 £8,109
    Schedule 2 – Funding Agreement [AllocRef_AEBA] – Page 1 Ref (for internal use only):  [ContractNo] v1

    SCHEDULE 2
    Funding Agreement – ESFA-Funded Adult Education Budget - National Skills Fund (procured from Aug 2021)
    Provider: 10017087 Co Ltd UKPRN: 10017087
    Master Contract Number: ESFA-087 Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: [AllocRef_NSF]
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    ESFA AEB - National Skills Fund £86,906 £5,231 £9,753 £6,250 £4,583 £9,583 £6,759 £3,054 £6,218 £8,903 £10,909 £4,891 £10,772
    of which Level 3 Free Courses for Jobs £37,137 £4,282 £1,989 £917 £2,021 £6,660 £694 £577 £3,040 £3,602 £4,027 £2,753 £6,575
    of which Learner Support £49,769 £949 £7,764 £5,333 £2,562 £2,923 £6,065 £2,477 £3,178 £5,301 £6,882 £2,138 £4,197
    Total Funding £86,906 £5,231 £9,753 £6,250 £4,583 £9,583 £6,759 £3,054 £6,218 £8,903 £10,909 £4,891 £10,772
    Schedule 2 – Funding Agreement [AllocRef_NSF] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 2
    Funding Agreement – ESFA-Funded Adult Education Budget - Short Term Funding Initiatives (procured from Aug 2021)
    Provider: 10017087 Co Ltd UKPRN: 10017087
    Master Contract Number: ESFA-087 Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: [AllocRef_STFI]
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    ESFA AEB - Short Term Funding Initiative 1 £35,703 £3,859 £1,768 £5,930 £1,397 £1,206 £5,505 £2,670 £3,224 £1,068 £1,695 £5,654 £1,727
    ESFA AEB - Short Term Funding Initiative 2 £53,683 £3,446 £2,512 £5,315 £4,858 £389 £3,733 £7,491 £6,281 £5,687 £7,470 £2,120 £4,381
    ESFA AEB - Short Term Funding Initiative 3 £66,318 £7,661 £5,772 £7,215 £2,884 £2,088 £6,589 £6,876 £3,903 £6,981 £7,810 £1,101 £7,438
    ESFA AEB - Short Term Funding Initiative 4 £47,641 £4,328 £5,707 £5,792 £5,537 £6,302 £1,897 £2,937 £4,041 £729 £2,714 £2,597 £5,060
    Total Funding £203,345 £19,294 £15,759 £24,252 £14,676 £9,985 £17,724 £19,974 £17,449 £14,465 £19,689 £11,472 £18,606
    Schedule 2 – Funding Agreement [AllocRef_STFI] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 3: CHANGE CONTROL PROCEDURE
    ESFA Adult Education Budget (Procured) Schedule 3 Version 2 (July 2022) – Page 1
    ESFA Adult Education Budget (Procured) Schedule 9 Version 2 (July 2022) – Page 1
    """

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 1                     | 0                        | 2022-07-05 12:06:22.000 |
    
    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017087_[ContractNo]_v1.pdf' in 'AEB2021-2223-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A087b.pdf'





    # Part 9: Publish and approve 22/23 contract

    # Change the date
    Given the override date is '08/07/2022'
    
    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-087' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017087 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                                  | True          | True                | 01/08/2022        | 31/07/2023      | ?             |
    #
    | 10017087 | AEBP21-087         | 3                     | 0                        | Approved         | Approved                                  | True          | True                | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017087 | AEBP21-087         | 2                     | 0                        | Replaced         | Approved                                  | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017087 | AEBP21-087         | 1                     | 0                        | Withdrawn        | Withdrawn By Provider                     | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017087 | ESFA-087           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |





    # Part 10: NFA amend 22/23 and check docs

    # Change the date
    Given the override date is '13/07/2022'

    # Issue a non-financial VARIATION amendment on v1 to create v2
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract '[ContractNo]' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017087 | [ContractNo]       | 2                     | 0                        | Draft            | Awaiting Documentation                    | True          | False               | 01/08/2022        | 31/07/2023      | Variation     |
    | 10017087 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                                  | False         | True                | 01/08/2022        | 31/07/2023      | ?             |
    #
    | 10017087 | AEBP21-087         | 3                     | 0                        | Approved         | Approved                                  | True          | True                | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017087 | AEBP21-087         | 2                     | 0                        | Replaced         | Approved                                  | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017087 | AEBP21-087         | 1                     | 0                        | Withdrawn        | Withdrawn By Provider                     | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017087 | ESFA-087           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |

    # Check the SoF details for 22/23. The other doc parts should not be present
    Then  the file named '10017087_[ContractNo]_v2.pdf' in Sharepoint location 'AEB2021-2223-Input-Appendices' contains the following lines in order
    """ 
    SUMMARY OF FUNDING
    Organisation Name: 10017087 Co Ltd UKPRN: 10017087
    Master Contract Number: ESFA-087
    Allocation
    1 August 2022 to 31 July 2023 Contract Ref Aug 22 - Mar 23 Apr 23 - Jul 23 Total
    ESFA AEB - Adult Skills (procured from Aug 2021) [AllocRef_AEBA] £72,491 £24,015 £96,506
    of which Learner Support £37,806 £4,837 £42,643
    ESFA AEB - National Skills Fund (procured from Aug 2021) [AllocRef_NSF] £51,431 £35,475 £86,906
    of which Level 3 Free Courses for Jobs £20,180 £16,957 £37,137
    of which Learner Support £31,251 £18,518 £49,769
    ESFA AEB - Short Term Funding Initiatives (procured from
    [AllocRef_STFI] £139,113 £64,232 £203,345
    Aug 2021)
    of which Short Term Funding Initiative 1 £25,559 £10,144 £35,703
    of which Short Term Funding Initiative 2 £34,025 £19,658 £53,683
    of which Short Term Funding Initiative 3 £42,988 £23,330 £66,318
    of which Short Term Funding Initiative 4 £36,541 £11,100 £47,641
    Total: £386,757
    Total Funding for this contract: £774,004
    Summary of Funding – Page 1
    """

    # There shouldn't be a T&C doc
    And   the pdf file does not contain the following text
    """
    Agreement Type Contract for Services
    """

    # There shouldn't be a Sch1 doc
    And   the pdf file does not contain the following text
    """
    SCHEDULE 1: SPECIFICATION & MONITORING
    """

    # There shouldn't be a Sch2 doc
    And   the pdf file does not contain the following text
    """  
    SCHEDULE 2: PAYMENT
    """
    
    # There shouldn't be a Funding Agreement for Adult Skills
    And   the pdf file does not contain the following text
    """  
    Funding Agreement – ESFA-Funded Adult Education Budget - Adult Skills (procured from Aug 2021)
    """

    # There shouldn't be a Funding Agreement for National Skills Fund
    And   the pdf file does not contain the following text
    """  
    Funding Agreement – ESFA-Funded Adult Education Budget - National Skills Fund (procured from Aug 2021)
    """

    # There shouldn't be a Funding Agreement for Short Term Funding Initiatives
    And   the pdf file does not contain the following text
    """  
    Funding Agreement – ESFA-Funded Adult Education Budget - Short Term Funding Initiatives (procured from Aug 2021)
    """

    # There shouldn't be a Sch3ON doc
    And   the pdf file does not contain the following text
    """  
    SCHEDULE 3: CHANGE CONTROL PROCEDURE
    """    

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | [ContractNo]   | 2                     | 0                        | 2022-07-13 12:06:22.000 |
    
    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017087_[ContractNo]_v2.pdf' in 'AEB2021-2223-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A087c.pdf'





    # Part 11: Publish and approve 22/23 v2

    # Change the date
    Given the override date is '18/07/2022'
    
    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-087' and ContractNumber '[ContractNo]' and Version '2'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus                         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017087 | [ContractNo]       | 2                     | 0                        | Approved         | Approved                                  | True          | True                | 01/08/2022        | 31/07/2023      | Variation     |
    | 10017087 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                                  | False         | False               | 01/08/2022        | 31/07/2023      | ?             |
    #
    | 10017087 | AEBP21-087         | 3                     | 0                        | Approved         | Approved                                  | True          | True                | 01/08/2021        | 31/07/2022      | Variation     |
    | 10017087 | AEBP21-087         | 2                     | 0                        | Replaced         | Approved                                  | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017087 | AEBP21-087         | 1                     | 0                        | Withdrawn        | Withdrawn By Provider                     | False         | False               | 01/08/2021        | 31/07/2022      | ?             |
    | 10017087 | ESFA-087           | 1                     | 0                        | Draft            | ?                                         | False         | False               | 01/08/2021        | 31/07/2022      | ?             |


    # Tidy Up
    And   the override date is reset  
       
