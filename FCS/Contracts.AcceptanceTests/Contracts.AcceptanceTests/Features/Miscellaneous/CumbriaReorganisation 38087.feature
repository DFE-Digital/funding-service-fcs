Feature: CumbriaReorganisation 38087

@AcceptanceTest @Manual
Scenario: A796 Bulk load an EDSK contract with 1619ED allocs for a Contracting Org and 3 Delivery Orgs.
    Given there is no Contract, Task or Workflow data for UKPRN '10017796' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017796' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | 1619ED2223        |



    # Organisation and Advisors for a Contracting Org (and three Delivery Orgs)
    Given there is no Organisation data in CRM for UKPRN '10017796' 
    And   there is no Organisation data in CRM for UKPRN '10001530' 
    And   there is no Organisation data in CRM for UKPRN '10001558' 
    And   there is no Organisation data in CRM for UKPRN '10001564' 

    And   there is no caseload advisor for UKPRN '10017796' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017796 | 
    | 10001530 | 
    | 10001558 | 
    | 10001564 | 
      
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017796' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider 'Trumpton County Council' with UKPRN '10017796' and OrgId 'ORG0017796' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name                     | SequenceNumber | Status     | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017796 | 117796 | Trumpton County Council  | 0              | Active     | Yes           | AA017796      | ?             | 4 Denville Road        | Lemington Spa          | ?                      | ?                      | ?                      | ?                      | CV32 5UW  |
    | 10001530 | 001530 | Codsall High School      | 0              | Active     | Yes           | AA001530      | ?             | 28 Albion Raod         | Lemington Spa          | ?                      | ?                      | ?                      | ?                      | CV33 6AS  |
    | 10001558 | 001558 | St Annes Convent School  | 0              | Active     | Yes           | AA001558      | ?             | 12 St Annes Road       | Lemington Spa          | ?                      | ?                      | ?                      | ?                      | CV13 2HG  |
    | 10001564 | 001564 | Priory Hill School       | 0              | Active     | Yes           | AA001564      | ?             | 9 Walsal Avenue        | Lemington Spa          | ?                      | ?                      | ?                      | ?                      | CV22 9LK  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017796 |
    | 10001530 |
    | 10001558 |
    | 10001564 |




    # Bulk create an EDSK contract with a Contracting Org and three Delivery Orgs
    
    # Change the date
    Given the override date is '02/07/2022'
    
    # Bulk file with 'New' intent
    And   there are no files prefixed '10017796' in the Sharepoint 'EDSK-2223-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2223 28022023113517 v3_A796' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2223 28022023113517 v3_A796' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2223 28022023113517 v3_A796' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2223 28022023113517 v3_A796' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2223 28022023113517 v3_A796.xlsx' exists in the Datafiles folder and UKPRN '10017796' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

   #And   the contract exists in CRM
    # Contract is now at 'Draft\Awaiting Documentation'

    # Retrieve parameters for the Contracting Org (10017796)
    When  I retrieve the latest EFA contract details from CRM for provider '10017796' for FundingType 'EDSK' and period '2223' and Delivery Organisation '10017796'

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017796_[ContractNo]_v1.pdf' in 'EDSK-2223-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A796.pdf'



    # Check the contents of the Appendix docs for the Contracting Org (10017796)
    Then  the file named '10017796_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2223-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2022/23
    Organisation Name: Trumpton County Council UKPRN: 10017796
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 22 - Mar 23 Apr 23 - Jul 23 2022/23 Total
    16 to 19 Education
    Trumpton County Council [AllocRef_16ED] £72,994 £44,365 £117,359
    Total Funding for this contract: £488,564
    Summary of Funding – Page 1

    Agreement Type Non-Maintained Special Schools (NMSS)
    Funding Period 1 August 2022 to 31 July 2023
    Between the Secretary of State for Education
    And Trumpton County Council
    Funding for 16 to 19 Education
    Master Agreement Number [MasterContractNo]
    ACCEPTANCE BY THE NMSS
    BY ACCEPTING THIS AGREEMENT VIA THE MANAGE YOUR EDUCATION &
    SKILLS FUNDING SERVICE THE PERSON TAKING THIS ACTION ON BEHALF OF
    THE NMSS REPRESENTS AND WARRANTS THAT THE NMSS HAS READ AND
    UNDERSTOOD THIS AGREEMENT, THE NMSS AGREES TO BE BOUND BY THIS
    AGREEMENT AND THAT HE/SHE IS DULY AUTHORISED TO ACCEPT THIS
    AGREEMENT AND LEGALLY BIND THE NMSS.
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    by David Withey, Chief Executive of the Education and Skills Funding Agency
    EDSK NMSS Version 1 (July 2022) Page 1
    This Agreement is made on the date the Agreement is digitally signed by the
    NMSS on the Manage Your Education & Skills Funding Service between:
    Trumpton County Council THE SECRETARY OF STATE FOR
    4 Denville Road EDUCATION
    Lemington Spa DEPARTMENT FOR EDUCATION
    CV32 5UW 20 GREAT SMITH STREET
    AND
    LONDON
    SW1P 3BT
    Company No: AA017796
    Hereinafter called Hereinafter called
    the NMSS the Department
    EDSK NMSS Version 1 (July 2022) Page 2
    EDSK NMSS Version 1 (July 2022) Page 59
    
    SCHEDULE 1: SPECIFICATION & MONITORING
    NON-MAINTAINED SPECIAL SCHOOL SPECIFICATION
    EDSK Schedule 1 – NMSS Version 1 (July 2022) – Page 1
    EDSK Schedule 1 – NMSS Version 1 (July 2022) – Page 11
    
    SCHEDULE 2: PAYMENT
    NON-MAINTAINED SPECIAL SCHOOL EDUCATION PAYMENTS
    EDSK Schedule 2 – NMSS Version 1 (July 2022) – Page 1
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: Trumpton County Council UKPRN: 10017796
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    SSF Programme Funding £62,068 £7,108.00 £5,356.00 £548.00 £7,023.00 £5,611.00 £7,734.00 £1,365.00 £6,683.00 £6,630.00 £4,677.00 £2,586.00 £6,747.00
    SSF Bursary Funds £55,291 £2,214.00 £4,135.00 £6,323.00 £3,488.00 £6,153.00 £3,997.00 £4,624.00 £632.00 £6,768.00 £7,991.00 £7,057.00 £1,909.00
    Total Funding £117,359 £9,322.00 £9,491.00 £6,871.00 £10,511.00 £11,764.00 £11,731.00 £5,989.00 £7,315.00 £13,398.00 £12,668.00 £9,643.00 £8,656.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
    
    SCHEDULE 3: NOT USED
    EDSK Schedule 3 - NMSS Version 1 (July 2022) – Page 1
    EDSK Schedule 9 – NMSS Version 1 (July 2022) – Page 5
    """



    # Retrieve parameters for Codsall High School (10001530)
    When  I retrieve the latest EFA contract details from CRM for provider '10017796' for FundingType 'EDSK' and period '2223' and Delivery Organisation '10001530'

    # Check the SoF and FA docs for Codsall High School (10001530)
    Then  the file named '10017796_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2223-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2022/23
    Codsall High School [AllocRef_16ED] £94,317 £41,595 £135,912
    Summary of Funding – Page 1
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: Codsall High School UKPRN: 10001530
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    16-19 Bursary Funds £38,565 £2,131.00 £2,896.00 £2,714.00 £1,643.00 £2,747.00 £7,385.00 £1,420.00 £1,303.00 £3,766.00 £4,328.00 £4,753.00 £3,479.00
    SSF High Needs Element 2 £48,646 £1,452.00 £4,934.00 £327.00 £4,085.00 £4,987.00 £4,392.00 £6,176.00 £6,665.00 £975.00 £4,255.00 £4,477.00 £5,921.00
    Maintained Special SSF Bursary Support £48,701 £7,429.00 £6,633.00 £3,183.00 £5,581.00 £497.00 £3,575.00 £6,516.00 £5,646.00 £4,032.00 £922.00 £2,301.00 £2,386.00
    Total Funding £135,912 £11,012.00 £14,463.00 £6,224.00 £11,309.00 £8,231.00 £15,352.00 £14,112.00 £13,614.00 £8,773.00 £9,505.00 £11,531.00 £11,786.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
    """
    


    # Retrieve parameters for St Annes Convent School (10001558)
    When  I retrieve the latest EFA contract details from CRM for provider '10017796' for FundingType 'EDSK' and period '2223' and Delivery Organisation '10001558'

    # Check the SoF and FA docs for St Annes Convent School (10001558)
    Then  the file named '10017796_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2223-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2022/23
    St Annes Convent School [AllocRef_16ED] £123,983 £71,633 £195,616
    Summary of Funding – Page 1

    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: St Annes Convent School UKPRN: 10001558
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    16-19 Programme Funding £52,905 £7,300.00 £1,675.00 £538.00 £6,059.00 £3,288.00 £3,649.00 £6,791.00 £3,203.00 £3,903.00 £6,027.00 £7,608.00 £2,864.00
    16-19 High Needs Element 2 £47,853 £4,923.00 £2,969.00 £878.00 £5,040.00 £506.00 £2,923.00 £7,222.00 £4,387.00 £7,052.00 £4,897.00 £5,524.00 £1,532.00
    14-16 Programme Funding £49,265 £5,556.00 £7,275.00 £6,341.00 £1,192.00 £735.00 £4,217.00 £7,562.00 £3,368.00 £2,159.00 £1,564.00 £3,348.00 £5,948.00
    14-16 Pupil Premium £45,593 £258.00 £3,538.00 £1,649.00 £3,093.00 £6,713.00 £5,916.00 £2,466.00 £2,753.00 £7,732.00 £2,859.00 £3,687.00 £4,929.00
    Total Funding £195,616 £18,037.00 £15,457.00 £9,406.00 £15,384.00 £11,242.00 £16,705.00 £24,041.00 £13,711.00 £20,846.00 £15,347.00 £20,167.00 £15,273.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
    """



    # Retrieve parameters for Priory Hill School (10001564)
    When  I retrieve the latest EFA contract details from CRM for provider '10017796' for FundingType 'EDSK' and period '2223' and Delivery Organisation '10001564'

    # Check the SoF and FA docs for Priory Hill School (10001564)
    Then  the file named '10017796_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2223-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2022/23
    Priory Hill School [AllocRef_16ED] £29,689 £9,988 £39,677
    Summary of Funding – Page 1
    
    SCHEDULE 2 – 16 TO 19 EDUCATION
    Funding Agreement – 16 to 19 Education
    Provider: Priory Hill School UKPRN: 10001564
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 31/07/2023
    Contract Ref: [AllocRef_16ED]
    Cash (£) Aug 2022 Sep 2022 Oct 2022 Nov 2022 Dec 2022 Jan 2023 Feb 2023 Mar 2023 Apr 2023 May 2023 Jun 2023 Jul 2023
    16-19 Free Meals £39,677 £3,315.00 £2,317.00 £3,696.00 £3,781.00 £3,526.00 £4,291.00 £7,837.00 £926.00 £2,030.00 £6,669.00 £703.00 £586.00
    Total Funding £39,677 £3,315.00 £2,317.00 £3,696.00 £3,781.00 £3,526.00 £4,291.00 £7,837.00 £926.00 £2,030.00 £6,669.00 £703.00 £586.00
    Schedule 2 – 16 to 19 Education – Funding Agreement [AllocRef_16ED] – Page 1 Ref (for internal use only):  [ContractNo] v1
    """      




    # Publish and approve the contract

    # Change the date
    Given the override date is '04/07/2022'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Check the deliverable count in CRM includes all the monitoring deliverables
    Then  there are '120' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017796 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2022        | 31/07/2023      | ?             |
    | 10017796 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2022        | 31/07/2023      | ?             |



    # Tidy Up
    Given the override date is reset

      