Feature: Create18191619FundingContractsA 23177

@AcceptanceTest @Withdrawn20201209
@Long2Run @Long2Run123
Scenario: A256 Bulk load a new 1819 16-19 Funding contract for a 'Provider Under Change' with full 1619LR, NMF and SSF allocations and no Delivery Orgs. Check docs. Publish and approve
    Given there is no Contract, Task or Workflow data for UKPRN '10017256'

    # Set organisation and advisors 
	And   there is no Organisation data for UKPRN '10017256'
  # And   caseload advisor 'FCS2 Test' is assigned to provider '10017256 Co Ltd' with UKPRN '10017256' and OrgId 'ORG0017256' and has 'FCS1 Test' as a manager
 
    # Put data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017256 | 117256 | 10017256 Co Ltd | 0              | Provider Under Change | Yes           | AA017256      | ?             | 71 London Road         | ?                      | ?                      | ?                      | Sevenoaks              | Kent                   | TN13 1AX  |

#    # Put data in the CRM Organisation table J057
#    And   the following Organisations exist in CRM
#    | OrgId      | UKPRN    | UPIN   | Name            | Status                | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
#    | ORG0017256 | 10017256 | 117256 | 10017256 Co Ltd | Provider Under Change | AA017256      | ?             | 71 London Road         | ?                      | ?                      | ?                      | Sevenoaks              | Kent                   | TN13 1AX  |




    # Change the date
    Given the override date is '22/07/2018'

    # Bulk import to create a new 1819 16-19 Funding contract
    And   there are no files prefixed '10017256_1619F' in the Sharepoint '1619FUND-1819-Input-Appendices' folder
    And   there are no files prefixed '1619FUND AY 1819 17012019134632 v3_A256' in the Sharepoint 'Processed' folder
    And   there are no files prefixed '1619FUND AY 1819 17012019134632 v3_A256' in the Sharepoint 'Reports' folder
    And   spreadsheet '1619FUND AY 1819 17012019134632 v3_A256.xlsx' exists in the Datafiles folder and UKPRN '10017256' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
	Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Retrieve parameters
   #And   I retrieve the latest EFA contract details from CRM for provider '10017256' for FundingType '1619FUND' and period '1819' and Delivery Organisation '00000000'
    And   I retrieve the latest contract details from CRM for provider '10017256' for FundingType '1619FUND' and period '1819'

    # Check the contents of the Appendices
    And   a file for this contract exists in sharepoint location '1619FUND-1819-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    Payment Schedule Summary
    Provider: 10017256 Co Ltd UPIN: 117256 UKPRN: 10017256
    Master Contract Ref: [MasterContractNo] Start Date: 01/08/2018 End Date: 31/07/2019
    Cash (£) Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019 Apr 2019 May 2019 Jun 2019 Jul 2019
    16-19 Programme Funding 7,694 -406.92 -1,700.55 708.55 1,838.01 93.17 2,962.01 1,025.79 3,173.94
    16-19 Bursary Funds 8,218 -1,774.53 1,078.66 4,145.32 3,795.31 973.24
    16-19 Formula Protection Funding 14,839 -3,781.62 -2,767.03 3,636.68 748.75 4,165.42 2,030.38 3,120.62 2,685.96 4,324.05 675.79
    16-19 High Needs Element 2 17,904 3,669.46 3,108.95 2,665.86 3,161.82 602.81 4,695.10
    14-16 Programme Funding 11,477 -793.69 -1,487.06 4,654.95 1,891.86 3,616.58 1,131.53 2,083.26 379.57
    14-16 Pupil Premium 9,508 -4,422.09 -2,808.23 3,722.33 1,680.37 4,377.91 4,198.21 179.81 2,579.69
    14-16 Service Child Premium 9,896 -2,681.38 2,506.25 2,612.01 3,438.86 4,020.26
    16-19 Free Meals 12,070 -493.57 -1,314.77 126.94 655.67 3,266.57 2,156.23 113.27 4,125.22 2,632.11 802.33
    16-19 SPI Element 1 12,485 -2,287.16 4,548.21 4,747.03 2,790.71 1,501.65 1,184.56
    16-19 Capacity and Delivery 6,693 3,193.61 1,713.15 1,786.12 0.12
    16-19 Capacity and Delivery Bursary 5,948 -4,976.93 1,733.25 2,136.13 4,039.57 3,015.87 0.11
    Funds
    16-19 Transitional Protection 12,928 -4,762.44 -333.94 4,231.96 4,727.92 1,627.51 854.51 1,310.26 146.05 219.02 4,907.15
    16-19 Resource Management (16-19) 4,456 -4,815.31 166.15 2,697.64 569.03 3,649.36 2,189.01 0.12
    Traineeships 15,653 -1,474.39 -206.09 3,035.97 3,068.75 4,112.55 2,750.51 4,092.45 272.89 0.36
    High Needs Student Transitional -371 -3,268.98 -4,689.47 1,607.41 4,641.28 695.87 642.01 0.88
    Protection
    16-19 Recovery 18,362 -3,481.48 4,060.67 4,178.11 1,204.51 3,689.56 4,271.17 2,103.36 1,237.28 1,098.82
    16-19 Growth 15,378 -2,114.87 4,443.46 3,088.85 325.76 2,050.48 4,284.84 3,299.48
    19+ Continuing Learners Programme 11,533 -33.79 4,780.81 199.91 3,742.43 2,843.58 0.06
    Funding
    SSF Programme Funding 10,979 -508.92 -1,629.27 408.72 3,866.59 4,798.22 3,211.02 832.64
    SSF Bursary Funds 5,140 -3,763.21 1,678.68 1,625.81 4,375.23 1,222.92 0.57
    SSF Formula Protection Funding 10,593 -1,275.26 871.91 4,672.37 303.97 1,770.76 904.68 766.17 2,577.53 0.87
    SSF High Needs Element 2 9,856 -1,362.89 -902.14 2,755.25 1,307.57 1,718.88 2,967.74 3,371.59
    SSF Maintained Special Element 2 14,262 4,216.61 779.83 3,773.52 851.81 4,640.23
    Maintained Special SSF Bursary Support 7,346 -2,129.23 -562.79 4,725.24 3,826.39 1,486.29 0.10
    SSF Free Meals 6,708 -2,216.87 -175.02 2,174.64 2,279.39 3,687.87 957.99
    SSF Capacity and Delivery 9,666 -722.42 2,861.01 1,380.54 1,453.52 4,692.47 0.88
    Ref (for internal use only):  [ContractNo]
    Page 1 of 3 of the Payment Schedules

    Payment Schedule Summary
    Provider: 10017256 Co Ltd UPIN: 117256 UKPRN: 10017256
    Master Contract Ref: [MasterContractNo] Start Date: 01/08/2018 End Date: 31/07/2019
    Cash (£) Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019 Apr 2019 May 2019 Jun 2019 Jul 2019
    SSF Capacity and Delivery Bursary 7,564 -2,643.86 -3,636.36 1,803.53 3,423.51 3,707.97 2,682.28 2,226.93
    Funds
    16-19 Resource Management (SSF) 5,318 -4,010.47 2,735.15 144.36 3,760.84 1,254.69 1,433.42 0.01
    Free School Meals SSF 24,022 -262.66 323.08 4,249.38 1,823.63 1,096.08 3,793.62 3,614.89 1,783.43 3,720.64 3,879.91
    Residential Bursary Fund 14,422 3,758.97 3,123.51 3,229.24 254.66 4,055.62
    Closing Schools 723 -3,232.34 -1,878.41 816.17 4,359.68 657.55 0.35
    Cadets Vocational Programme 7,648 -3,619.13 -1,664.91 4,181.96 2,594.76 214.46 413.28 3,407.96 2,118.91 0.71
    NMF Pre-16 Funding (NMSS) 11,470 -1,865.73 -4,526.97 234.56 2,277.52 3,830.95 4,201.07 4,108.98 3,209.62
    Pre-16 Universal Infant Free School 15,307 -1,438.74 1,642.04 1,874.63 2,826.36 4,254.93 1,365.01 4,782.67 0.10
    Meals
    Primary PE and Sport Premium 0
    Residential Support Scheme 4,807 -297.29 2,224.65 307.53 1,312.13 1,259.98
    19+ Continuing Learners in SFC 20,576 -1,011.76 -3,926.69 2,171.77 3,050.52 4,689.61 4,677.92 4,795.35 1,821.76 4,307.52
    (Student Support)
    Area Review Transition Grant 12,118 -117.58 -2,305.39 1,715.02 3,526.38 4,604.95 109.71 4,584.85 0.06
    16+ Factor Removal (DSG) SSF 10,529 -1,311.89 182.68 1,133.41 743.19 4,624.06 1,272.92 3,884.63
    Alternative Completions - Sporting 6,571 -2,378.37 -1,278.13 1,292.03 922.91 4,286.71 3,725.21 0.64
    Excellence
    Alternative Completions - Sea Fishing 12,608 -1,738.88 -1,238.92 1,219.06 360.41 4,835.54 4,148.19 585.57 4,233.83 203.20
    Alternative Completions - Creative 2,778 -4,513.29 -3,286.22 2,700.51 1,239.16 4,339.58 2,297.62 0.64
    Sector
    Strategic College Improvement Fund 8,864 -2,251.52 -4,312.48 3,249.34 1,418.87 3,355.09 4,181.96 2,594.76 214.46 413.52
    (SCIF)
    Principals Reference Group (PRG) 9,148 -1,611.04 1,801.66 3,143.59 637.45 816.17 4,359.68 0.49
    National Leaders of Further Education 2,497 -4,386.45 3,758.97 3,124.48
    (NLFE)
    Forensic Unit 12,153 -1,791.76 4,055.12 4,637.72 1,153.51 287.43 3,810.85 0.13
    Isles of Scilly 10,336 2,403.37 2,138.01 690.32 2,350.49 2,753.38 0.43
    Maths Centre for Excellence 1619 2,690 -3,659.33 161.58 3,156.27 519.03 234.56 2,277.89
    Teachers Pay Grant (NMSS) 14,662 -884.91 3,632.13 1,206.38 3,176.37 1,166.18 3,103.41 3,262.02 0.42
    1619BF - Discretionary 10,861 -3,319.98 -1,491.62 4,604.95 109.71 4,584.85 3,705.11 2,667.73 0.25
    Young Offenders Institute 18,287 -4,866.32 1,133.41 743.19 4,624.06 1,272.92 3,883.82 2,773.48 730.52 4,742.47 3,249.45
    Ref (for internal use only):  [ContractNo]
    Page 2 of 3 of the Payment Schedules

    Payment Schedule Summary
    Provider: 10017256 Co Ltd UPIN: 117256 UKPRN: 10017256
    Master Contract Ref: [MasterContractNo] Start Date: 01/08/2018 End Date: 31/07/2019
    Cash (£) Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019 Apr 2019 May 2019 Jun 2019 Jul 2019
    Core Cities Youth Contract 4,575 -371.28 -3,886.49 287.43 3,810.85 2,330.41 2,404.08
    19+ Continuing Learners 10,276 -2,892.99 -4,353.68 2,350.49 2,753.38 4,128.09 4,657.82 3,632.89
    LA Other 2 8,839 -3,832.62 1,166.18 3,103.41 3,262.02 1,378.67 3,599.36 161.98
    LA Youth Contract 11,668 4,392.46 869.04 2,191.87 4,213.73 0.90
    Exceptional Support 10,503 -2,165.87 -3,372.86 3,070.62 340.31 3,672.33 4,848.22 393.18 2,244.75 1,472.32
    TechBacc 3,152 -2,218.74 2,065.03 1,609.27 1,695.91 0.53
    DADA 14,933 -244.43 3,546.48 1,589.17 267.33 3,936.71 1,345.91 1,325.81 2,455.24 710.78
    Improvement Support Grant 20,688 796.07 3,196.47 4,161.86 466.16 3,652.23 3,685.01 4,730.20
	Basic Skills Maths 1619 19,214 -3,675.11 1,850.39 1,250.00 1,850.56 3,121.29 2,222.66 3,002.92 3,150.81 2,902.71 3,537.55
    Basic Skills Maths SSF 19,506 -3,001.11 2,340.39 500.00 1,890.56 2,153.29 6,234.66 2,879.92 3,005.81 2,092.71 1,409.55
    Total Funding 638,534 -102,432.94 -76,275.17 0.00 98,368.45 84,316.11 91,127.76 82,553.82 88,383.73 95,401.77 76,542.42 112,793.40 87,754.21
    Ref (for internal use only):  [ContractNo]
	Page 3 of 3 of the Payment Schedules
    """
    


    # Associate an Advisor with the main provider
    Given caseload advisor 'FCS2 Test' is assigned to UKPRN '10017256'

   #And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Publish the contract
    And   the latest version of contract '[ContractNo]' is in a state of 'Published to Provider'
   
    # Inject an SFS contract approval message.
   #When  an AEB contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved in CRM
    Then  the latest version of contract '[ContractNo]' is in status 'Approved'

    # Check the deliverable counts in CRM 
   #And   there are 'nnn' deliverable periods in CRM linked to the latest version of contract 'xxxx-256' and allocation 'xxxx-256' 
   #And   there are 'nnn' deliverable period rows in CRM linked to the latest version of contract 'xxxx-256' 
    And   there are '732' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 

   # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017256 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017256 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |


    # Tidy up
    And   the override date is reset

@AcceptanceTest @Withdrawn20201209
@Long2Run @Long2Run123
Scenario: A257 Bulk load a new 1819 16-19 Funding contract with short 1619LR, NMF and SSF allocations and 3 Delivery Orgs. Check docs. Publish and approve
    Given there is no Contract, Task or Workflow data for UKPRN '10017257'
    And   there is no Organisation data for UKPRN '10017257'

    # Set organisation and advisors 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017257 Co Ltd' with UKPRN '10017257' and OrgId 'ORG0017257' and has 'FCS1 Test' as a manager
    And   UPIN '117257' is associated with UKPRN '10017257' in the CRM Organisation table 
 
    # Put data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name                              | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017257 | 117257 | 10017257 Co Ltd                   | 0              | Active | Yes           | AA017257      | ?             | 23 Keytes Lane         | Barford                | ?                      | ?                      | Warwick                | Warwickshire           | CV35 8EP  |
    | 10020019 | 121690 | EGLANTINE CATERING LIMITED        | 0              | Active | Yes           | AA121690      | 121690        | 71 London Road         | ?                      | ?                      | ?                      | Sevenoaks              | Kent                   | TN13 1AX  |
    | 10020068 | 125568 | COMMUNITY TRAINING PORTAL LIMITED | 0              | Active | Yes           | AA125568      | 125568        | 9 Challoner Court      | Merchants Landing      | ?                      | ?                      | Bristol                | Avon                   | BS1 4RG   |
    | 10020172 | 122759 | CARE-EX SERVICES LIMITED          | 0              | Active | Yes           | AA122759      | ?             | 15 Princeton Mews      | 167-169 London Road    | Kingston upon Thames   | ?                      | ?                      | Surrey                 | KT2 6PT   |

     # Put data in the CRM Organisation table J057
    And   the following Organisations exist in CRM
    | UKPRN    | Organisation ID | UPIN   | Name                              | Status | CompanyNumber | CharityNumber | AddressLine1      | AddressLine2        | AddressLine3         | AddressLine4 | Town      | County       | Postcode |
    | 10017257 | ORG0017257      | 117257 | 10017257 Co Ltd                   | Active | AA017257      | ?             | 23 Keytes Lane    | Barford             | ?                    | ?            | Warwick   | Warwickshire | CV35 8EP |
    | 10020019 | ORG0020019      | 121690 | EGLANTINE CATERING LIMITED        | Active | AA121690      | 121690        | 71 London Road    | ?                   | ?                    | ?            | Sevenoaks | Kent         | TN13 1AX |
    | 10020068 | ORG0020068      | 125568 | COMMUNITY TRAINING PORTAL LIMITED | Active | AA125568      | 125568        | 9 Challoner Court | Merchants Landing   | ?                    | ?            | Bristol   | Avon         | BS1 4RG  |
    | 10020172 | ORG0020172      | 122759 | CARE-EX SERVICES LIMITED          | Active | AA122759      | ?             | 15 Princeton Mews | 167-169 London Road | Kingston upon Thames | ?            | ?         | Surrey       | KT2 6PT  |
 
 
 
    # Change the date
    And   the override date is '22/07/2018'

    # Bulk import to create a new 1819 16-19 Funding contract
    And   there are no files prefixed '10017257_1619F' in the Sharepoint '1619FUND-1819-Input-Appendices' folder
    And   there are no files prefixed '1619FUND AY 1819 17012019163117 v3_A257' in the Sharepoint 'Processed' folder
    And   there are no files prefixed '1619FUND AY 1819 17012019163117 v3_A257' in the Sharepoint 'Reports' folder

    And   spreadsheet '1619FUND AY 1819 17012019163117 v3_A257.xlsx' exists in the Datafiles folder and UKPRN '10017257' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Retrieve parameters for first Delivery Org
    And   I retrieve the latest EFA contract details from CRM for provider '10017257' for FundingType '1619FUND' and period '1819' and Delivery Organisation '10020172'
   #And   I retrieve the latest contract details from CRM for provider '10017257' for FundingType '1619FUND' and period '1819'

    # Check the contents of the Appendices
    And   a file for this contract exists in sharepoint location '1619FUND-1819-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    Payment Schedule Summary
    Provider: 10017257 Co Ltd UPIN: 117257 UKPRN: 10017257
    Master Contract Ref: [MasterContractNo] Start Date: 01/08/2018 End Date: 31/07/2019
    Cash (£) Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019 Apr 2019 May 2019 Jun 2019 Jul 2019
    16-19 Programme Funding 7,587 -837.77 -1,871.47 2,694.77 685.58 2,621.79 3,088.05 1,205.71 0.34
    16-19 Bursary Funds 5,820 -3,185.21 -6,803.41 209.72 4,446.26 5,256.68 1,868.89 2,271.78 543.11 1,212.18
    16-19 Formula Protection Funding 8,291 -3,819.13 2,330.22 585.39 2,138.82 202.61 2,350.32 1,748.61 2,754.16
    16-19 High Needs Element 2 11,243 -2,325.67 -884.09 4,657.64 1,207.21 2,297.44 3,176.19 1,166.01 1,948.27
    14-16 Programme Funding 10,864 -4,246.12 -3,659.51 3,599.18 1,841.68 3,652.06 4,730.62 235.38 4,710.52 0.19
    14-16 Pupil Premium 5,161 -1,184.23 2,793.41 308.36 1,259.08 869.86 1,114.13 0.39
    14-16 Service Child Premium 21,955 -6,431.98 -5,985.90 3,611.84 4,741.29 4,889.53 3,355.21 5,433.73 4,827.93 996.01 3,001.53 3,515.81
    16-19 Free Meals 21,081 -1,753.13 -4,822.59 3,604.11 4,086.16 4,867.87 187.43 8,762.40 3,975.22 411.61 1,761.01 0.91
    16-19 SPI Element 1 27,495 -3,413.63 -4,182.13 1,575.81 6,732.10 2,162.61 1,066.18 4,680.44 2,849.96 8,952.80 7,070.86
    16-19 Capacity and Delivery 23,552 -4,834.72 -1,397.44 4,446.44 77.05 7,084.47 4,933.68 1,751.67 3,591.74 4,201.17 3,697.94
    16-19 Capacity and Delivery Bursary 5,438 -5,451.16 -3,423.97 1,621.76 2,529.32 1,837.32 3,732.15 629.93 3,961.86 0.79
    Funds
    16-19 Transitional Protection 22,881 -3,638.31 1,028.58 7,669.76 3,831.87 3,388.78 6,526.63 4,073.69
    16-19 Resource Management (16-19) 12,355 -4,863.86 -1,508.26 691.24 4,757.83 4,340.51 308.46 3,967.62 1,854.46 2,807.00
    High Needs Student Transitional 2,321 -1,459.11 1,231.46 1,072.84 1,475.73 0.08
    Protection
    16-19 Growth 31,536 -599.00 -3,882.98 6,817.76 3,916.16 4,768.32 5,270.77 3,590.21 3,897.05 3,643.07 4,114.64
    19+ Continuing Learners Programme 29,702 -713.35 -2,327.07 4,153.49 4,648.22 3,517.22 5,297.61 8,914.10 881.53 4,575.69 754.56
    Funding
    SSF Programme Funding 4,078 -2,563.41 2,319.65 3,376.12 944.93 0.71
    SSF Bursary Funds 7,636 -7,864.51 -4,824.19 3,981.78 2,024.46 1,989.73 1,387.03 2,809.78 2,339.75 3,767.33 2,024.84
    SSF Formula Protection Funding 8,574 -1,000.45 -626.34 2,077.34 1,052.64 3,114.71 1,581.37 2,374.73
    SSF High Needs Element 2 4,168 -1,940.07 1,727.32 523.91 3,856.84
    SSF Capacity and Delivery 5,506 -2,129.31 -1,242.56 449.84 2,544.68 3,443.53 2,439.82
    SSF Capacity and Delivery Bursary 13,176 -761.69 832.63 356.77 4,620.42 4,428.03 3,699.28 0.56
    Funds
    16-19 Resource Management (SSF) 20,896 -3,961.22 2,500.32 919.68 2,044.56 5,853.18 8,621.70 1,971.59 2,130.21 815.98
    Free School Meals SSF 8,424 -4,708.64 -8,249.91 2,804.31 676.71 5,390.28 946.89 3,315.53 2,943.41 5,305.42
    Residential Bursary Fund 16,565 -5,502.99 1,631.01 749.12 1,472.39 7,594.94 4,400.54 816.62 843.83 4,559.54
    Closing Schools 36,954 -3,529.59 -2,657.21 3,987.18 4,665.89 2,803.86 9,189.92 5,718.74 4,988.98 8,606.46 1,890.35 1,289.42
    Ref (for internal use only):  [ContractNo]
    Page 1 of 11 of the Payment Schedules

    Payment Schedule Summary
    Provider: 10017257 Co Ltd UPIN: 117257 UKPRN: 10017257
    Master Contract Ref: [MasterContractNo] Start Date: 01/08/2018 End Date: 31/07/2019
    Cash (£) Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019 Apr 2019 May 2019 Jun 2019 Jul 2019
    Cadets Vocational Programme 44,125 -3,316.11 -7,140.59 6,069.74 2,507.35 9,941.19 1,750.02 8,647.87 6,112.00 6,893.42 12,660.11
    NMF Pre-16 Funding (NMSS) 10,674 -4,606.06 -2,992.18 3,540.38 1,497.42 558.37 4,016.24 4,947.85 3,711.98
    Pre-16 Universal Infant Free School 12,249 -833.09 4,674.87 1,237.11 4,231.79 1,627.32 1,311.00
    Meals
    Primary PE and Sport Premium 0
    Residential Support Scheme 13,467 -2,340.22 675.61 2,612.81 2,123.28 3,108.77 4,621.01 2,665.74
    19+ Continuing Learners in SFC 17,547 4,694.97 1,786.93 4,654.77 73.89 3,617.41 2,718.56 0.47
    (Student Support)
    Area Review Transition Grant 9,386 378.46 907.21 3,722.16 4,377.73 0.44
    16+ Factor Removal (DSG) SSF 10,656 -3,868.44 2,579.05 411.23 4,800.72 4,853.61 1,369.69 510.14
    Alternative Completions - Sporting 20,358 -4,902.14 4,906.47 3,904.59 4,519.96 4,284.66 4,516.26 3,050.26 77.94
    Excellence
    Alternative Completions - Sea Fishing 17,439 -2,465.27 -1,878.66 1,728.43 109.45 2,632.91 3,632.86 2,738.66 1,078.48 3,564.53 6,297.61
    Alternative Completions - Creative 18,685 -2,805.61 3,156.01 5,490.78 2,574.41 5,788.92 4,480.49
    Sector
    1619BF - Discretionary 20,346 -9,071.94 -5,035.66 3,247.58 2,947.65 4,000.10 7,451.52 502.81 4,378.03 7,432.42 4,491.61 1.88
    Young Offenders Institute 33,930 -1,522.51 -1,539.82 4,933.70 2,987.85 5,336.57 8,614.73 4,952.80 3,875.22 762.53 5,528.93
    Core Cities Youth Contract 23,343 -5,782.38 -2,952.97 6,421.90 6,018.02 5,067.29 2,551.61 3,308.80 3,817.42 505.49 4,387.82
    19+ Continuing Learners 9,122 -2,438.35 3,487.51 2,482.91 4,293.28 420.84 875.81
    LA Other 2 7,275 -4,646.26 -344.61 4,472.01 3,434.63 948.58 1,900.31 1,510.34
    LA Youth Contract 5,629 -1,658.35 -4,059.65 2,852.03 2,885.79 294.01 3,910.49 1,404.34 0.34
    Exceptional Support 6,922 -3,452.94 1,424.44 823.73 1,827.33 1,774.45 4,524.87 0.12
    TechBacc 11,310 -2,298.82 4,260.51 2,905.89 1,457.22 1,867.53 3,117.67
    DADA 17,907 -677.52 -1,498.72 4,895.98 781.35 2,282.91 1,554.35 4,251.88 4,073.17 2,243.60
    Improvement Support Grant 17,329 -7,740.53 -4,012.59 4,857.30 6,887.60 1,610.01 1,768.63 5,364.94 3,141.55 5,452.09
    Basic Skills Maths 1619 14,577 -3,316.11 2,900.39 958.56 2,220.29 1,123.66 2,102.92 1,085.81 3,250.71 4,250.55
    Basic Skills Maths SSF 18,854 -3,025.11 1,850.39 100.00 750.56 1,273.29 2,245.66 3,122.92 3,875.81 4,002.71 4,657.55
    Total Funding 734,389 -138,598.56 -99,941.16 0.00 114,842.05 71,863.83 123,553.54 104,321.34 106,175.02 118,555.92 109,383.24 105,871.05 118,362.29
    Ref (for internal use only):  [ContractNo]
    Page 2 of 11 of the Payment Schedules

    Payment Schedule
    Provider: CARE-EX SERVICES LIMITED UPIN: 122759 UKPRN: 10020172
    Master Contract Ref: [MasterContractNo] Start Date: 01/08/2018 End Date: 31/07/2019
    Contract Ref: [AllocRef_16LR]
    Cash (£) Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019 Apr 2019 May 2019 Jun 2019 Jul 2019
    16-19 Bursary Funds 4,912 -3,692.18 4,446.26 2,403.29 543.11 1,211.52
    14-16 Service Child Premium 10,190 -3,991.14 -4,599.84 4,889.53 3,355.21 4,149.31 996.01 1,875.74 3,515.18
    16-19 Capacity and Delivery 10,866 -1,397.44 4,446.44 77.05 2,859.24 678.75 4,201.17 0.79
    16-19 Capacity and Delivery Bursary 4,616 -1,130.07 -1,610.93 2,529.32 1,081.64 3,115.98 629.93 0.13
    Funds
    16-19 Transitional Protection 14,215 -3,638.31 1,028.58 4,393.38 3,831.87 3,388.78 3,884.74 1,325.96
    16-19 Resource Management (16-19) 5,996 -4,579.92 -63.78 691.24 4,340.51 308.46 638.37 1,854.46 2,806.66
    High Needs Student Transitional 2,321 -1,459.11 1,231.46 1,072.84 1,475.73 0.08
    Protection
    Total Funding 53,116 -13,339.44 -12,823.28 0.00 6,166.26 7,052.63 16,858.54 14,643.57 5,136.52 5,099.99 7,365.14 8,095.75 8,860.32
    Ref (for internal use only):  [ContractNo]
    Page 3 of 11 of the Payment Schedules

    Payment Schedule
    Provider: CARE-EX SERVICES LIMITED UPIN: 122759 UKPRN: 10020172
    Master Contract Ref: [MasterContractNo] Start Date: 01/08/2018 End Date: 31/07/2019
    Contract Ref: [AllocRef_SSF]
    Cash (£) Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019 Apr 2019 May 2019 Jun 2019 Jul 2019
    SSF Programme Funding 4,078 -2,563.41 2,319.65 3,376.12 944.93 0.71
    SSF Bursary Funds 4,868 -3,063.37 -4,824.19 1,989.73 1,387.03 2,392.62 2,339.75 3,767.33 879.10
    Free School Meals SSF 4,396 -4,708.64 -3,781.69 2,804.31 676.71 3,756.03 2,295.67 3,353.61
    Total Funding 13,342 -7,772.01 -11,169.29 0.00 5,123.96 676.71 3,756.03 1,989.73 7,058.82 2,392.62 3,284.68 3,767.33 4,233.42
    Ref (for internal use only):  [ContractNo]
    Page 4 of 11 of the Payment Schedules

    Payment Schedule
    Provider: CARE-EX SERVICES LIMITED UPIN: 122759 UKPRN: 10020172
    Master Contract Ref: [MasterContractNo] Start Date: 01/08/2018 End Date: 31/07/2019
    Contract Ref: [AllocRef_NMF]
    Cash (£) Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019 Apr 2019 May 2019 Jun 2019 Jul 2019
    Residential Bursary Fund 5,098 3,531.05 1,566.95
    Closing Schools 8,688 -512.56 1,892.97 1,575.73 4,232.08 411.52 590.24 498.02
    Cadets Vocational Programme 17,704 -2,480.45 4,338.82 2,507.35 4,443.57 3,955.04 4,939.67
    Alternative Completions - Sporting 10,994 3,579.01 4,287.45 3,050.26 77.28
    Excellence
    Alternative Completions - Sea Fishing 3,279 -2,465.27 -1,878.66 1,728.43 109.45 3,632.86 2,152.19
    Alternative Completions - Creative 13,525 -2,805.61 3,156.01 2,171.51 2,574.41 3,949.11 4,479.57
    Sector
    1619BF - Discretionary 12,994 -4,601.71 -4,014.11 3,247.58 1,489.09 3,300.45 4,378.03 4,834.78 4,358.92 0.97
    Young Offenders Institute 13,136 -1,539.82 2,441.81 4,906.75 4,093.55 907.48 517.26 762.53 1,046.44
    Core Cities Youth Contract 15,510 -1,815.81 1,652.76 4,137.81 4,719.42 2,551.61 370.13 3,894.08
    Improvement Support Grant 8,717 -2,892.26 -4,012.59 2,997.39 4,624.79 1,610.01 1,768.63 1,199.69 3,421.34
    Total Funding 109,645 -14,580.66 -14,438.19 0.00 13,960.94 15,321.10 21,375.34 21,044.47 12,480.97 13,141.73 10,500.84 8,761.95 22,076.51
    Ref (for internal use only):  [ContractNo]
    Page 5 of 11 of the Payment Schedules
    """

    # Retrieve parameters for second Delivery Org
    And   I retrieve the latest EFA contract details from CRM for provider '10017257' for FundingType '1619FUND' and period '1819' and Delivery Organisation '10020068'
   #And   I retrieve the latest contract details from CRM for provider '10017257' for FundingType '1619FUND' and period '1819'

    # Check the contents of the Appendices
    And   a file for this contract exists in sharepoint location '1619FUND-1819-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    Payment Schedule
    Provider: COMMUNITY TRAINING PORTAL LIMITED UPIN: 125568 UKPRN: 10020068
    Master Contract Ref: [MasterContractNo] Start Date: 01/08/2018 End Date: 31/07/2019
    Contract Ref: [AllocRef_16LR]
    Cash (£) Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019 Apr 2019 May 2019 Jun 2019 Jul 2019
    16-19 Formula Protection Funding 8,291 -3,819.13 2,330.22 585.39 2,138.82 202.61 2,350.32 1,748.61 2,754.16
    16-19 High Needs Element 2 11,243 -2,325.67 -884.09 4,657.64 1,207.21 2,297.44 3,176.19 1,166.01 1,948.27
    14-16 Programme Funding 10,864 -4,246.12 -3,659.51 3,599.18 1,841.68 3,652.06 4,730.62 235.38 4,710.52 0.19
    14-16 Pupil Premium 5,161 -1,184.23 2,793.41 308.36 1,259.08 869.86 1,114.13 0.39
    16-19 Free Meals 8,513 -286.36 -4,822.59 4,086.16 3,821.79 4,099.83 1,613.78 0.39
    16-19 SPI Element 1 16,986 -2,461.49 -4,182.13 4,204.57 2,162.61 4,680.44 2,849.96 4,786.19 4,945.85
    16-19 Growth 14,490 -200.71 -3,882.98 3,252.85 787.91 4,151.71 3,590.21 3,147.11 3,643.07 0.83
    19+ Continuing Learners Programme 13,335 -713.35 -1,961.54 331.15 3,517.22 2,235.59 4,595.79 4,575.69 754.45
    Funding
    Total Funding 88,883 -14,052.83 -20,577.07 0.00 16,964.45 5,459.46 13,214.07 16,089.40 13,101.82 15,468.54 10,618.64 22,191.99 10,404.53
    Ref (for internal use only):  [ContractNo]
    Page 6 of 11 of the Payment Schedules

    Payment Schedule
    Provider: COMMUNITY TRAINING PORTAL LIMITED UPIN: 125568 UKPRN: 10020068
    Master Contract Ref: [MasterContractNo] Start Date: 01/08/2018 End Date: 31/07/2019
    Contract Ref: [AllocRef_SSF]
    Cash (£) Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019 Apr 2019 May 2019 Jun 2019 Jul 2019
    SSF Capacity and Delivery 5,506 -2,129.31 -1,242.56 449.84 2,544.68 3,443.53 2,439.82
    SSF Capacity and Delivery Bursary 13,176 -761.69 832.63 356.77 4,620.42 4,428.03 3,699.28 0.56
    Funds
    16-19 Resource Management (SSF) 7,424 -1,934.51 919.68 3,987.34 3,636.33 815.16
    Total Funding 26,106 -4,825.51 -1,242.56 0.00 1,282.47 356.77 8,084.78 0.00 8,415.37 7,079.86 3,699.28 0.00 3,255.54
    Ref (for internal use only):  [ContractNo]
    Page 7 of 11 of the Payment Schedules
    
    Payment Schedule
    Provider: COMMUNITY TRAINING PORTAL LIMITED UPIN: 125568 UKPRN: 10020068
    Master Contract Ref: [MasterContractNo] Start Date: 01/08/2018 End Date: 31/07/2019
    Contract Ref: [AllocRef_NMF]
    Cash (£) Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019 Apr 2019 May 2019 Jun 2019 Jul 2019
    Residential Bursary Fund 4,918 -4,911.12 1,631.01 223.53 1,472.39 4,815.89 869.49 816.62 0.19
    Closing Schools 16,450 -1,336.59 2,094.21 4,665.89 1,228.13 2,900.97 1,618.34 3,978.54 1,300.11 0.40
    Cadets Vocational Programme 17,530 -3,084.75 772.36 3,587.33 1,545.36 4,242.91 4,063.19 2,232.71 4,170.89
    Basic Skills Maths SSF 18,854 -3,025.11 1,850.39 100.00 750.56 1,273.29 2,245.66 3,122.92 3,875.81 4,002.71 4,657.55
    Total Funding 57,752 -7,936.23 -2,570.95 0.00 3,825.22 6,412.34 1,228.13 6,333.01 11,507.88 9,853.66 12,734.16 7,535.53 8,829.03
    Ref (for internal use only):  [ContractNo]
    Page 8 of 11 of the Payment Schedules
    """    

    # Retrieve parameters for third Delivery Org
    And   I retrieve the latest EFA contract details from CRM for provider '10017257' for FundingType '1619FUND' and period '1819' and Delivery Organisation '10020019'
   #And   I retrieve the latest contract details from CRM for provider '10017257' for FundingType '1619FUND' and period '1819'

    # Check the contents of the Appendices
    And   a file for this contract exists in sharepoint location '1619FUND-1819-Input-Appendices'
    And   the pdf file contains the following page lines in order
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
   #And   the pdf file which contains a upin and the following parameterized lines in order
    """
    Payment Schedule
    Provider: EGLANTINE CATERING LIMITED UPIN: 121690 UKPRN: 10020019
    Master Contract Ref: [MasterContractNo] Start Date: 01/08/2018 End Date: 31/07/2019
    Contract Ref: [AllocRef_16LR]
    Cash (£) Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019 Apr 2019 May 2019 Jun 2019 Jul 2019
    16-19 Programme Funding 7,587 -837.77 -1,871.47 2,694.77 685.58 2,621.79 3,088.05 1,205.71 0.34
    16-19 Bursary Funds 908 -3,185.21 -3,111.23 209.72 2,853.39 1,868.89 2,271.78 0.66
    14-16 Service Child Premium 11,765 -2,440.84 -1,386.06 3,611.84 4,741.29 1,284.42 4,827.93 1,125.79 0.63
    16-19 Free Meals 12,568 -1,466.77 3,604.11 1,046.08 187.43 4,662.57 3,975.22 411.61 147.23 0.52
    16-19 SPI Element 1 10,509 -952.14 1,575.81 2,527.53 1,066.18 4,166.61 2,125.01
    16-19 Capacity and Delivery 12,686 -4,834.72 4,225.23 4,933.68 1,072.92 3,591.74 3,697.15
    16-19 Capacity and Delivery Bursary 822 -4,321.09 -1,813.04 1,621.76 755.68 616.17 3,961.86 0.66
    Funds
    16-19 Transitional Protection 8,666 3,276.38 2,641.89 2,747.73
    16-19 Resource Management (16-19) 6,359 -283.94 -1,444.48 4,757.83 3,329.25 0.34
    16-19 Growth 17,046 -398.29 3,564.91 3,128.25 4,768.32 1,119.06 749.94 4,113.81
    19+ Continuing Learners Programme 16,367 -365.53 3,822.34 4,648.22 3,062.02 4,318.31 881.53 0.11
    Funding
    Total Funding 105,283 -18,720.77 -9,991.81 0.00 18,010.49 10,564.31 28,858.66 9,410.81 13,769.90 21,810.54 8,276.71 10,607.20 12,686.96
    Ref (for internal use only):  [ContractNo]
    Page 9 of 11 of the Payment Schedules

    Payment Schedule
    Provider: EGLANTINE CATERING LIMITED UPIN: 121690 UKPRN: 10020019
    Master Contract Ref: [MasterContractNo] Start Date: 01/08/2018 End Date: 31/07/2019
    Contract Ref: [AllocRef_SSF]
    Cash (£) Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019 Apr 2019 May 2019 Jun 2019 Jul 2019
    SSF Bursary Funds 2,768 -4,801.14 3,981.78 2,024.46 417.16 1,145.74
    SSF Formula Protection Funding 8,574 -1,000.45 -626.34 2,077.34 1,052.64 3,114.71 1,581.37 2,374.73
    SSF High Needs Element 2 4,168 -1,940.07 1,727.32 523.91 3,856.84
    16-19 Resource Management (SSF) 13,472 -2,026.71 2,500.32 2,044.56 1,865.84 4,985.37 1,971.59 2,130.21 0.82
    Free School Meals SSF 4,028 -4,468.22 1,634.25 946.89 1,019.86 2,943.41 1,951.81
    Total Funding 33,010 -9,768.37 -5,094.56 0.00 8,559.44 3,751.78 1,634.25 2,991.45 2,885.70 6,455.17 8,029.71 4,235.49 9,329.94
    Ref (for internal use only):  [ContractNo]
    Page 10 of 11 of the Payment Schedules

    Payment Schedule
    Provider: EGLANTINE CATERING LIMITED UPIN: 121690 UKPRN: 10020019
    Master Contract Ref: [MasterContractNo] Start Date: 01/08/2018 End Date: 31/07/2019
    Contract Ref: [AllocRef_NMF]
    Cash (£) Aug 2018 Sep 2018 Oct 2018 Nov 2018 Dec 2018 Jan 2019 Feb 2019 Mar 2019 Apr 2019 May 2019 Jun 2019 Jul 2019
    Residential Bursary Fund 6,549 -591.87 525.59 2,779.05 843.83 2,992.40
    Closing Schools 11,816 -3,529.59 -808.06 4,957.84 2,406.25 3,370.64 4,627.92 791.00
    Cadets Vocational Programme 8,891 -3,316.11 -1,575.39 958.56 1,910.29 204.66 449.92 2,048.81 4,660.71 3,549.55
    NMF Pre-16 Funding (NMSS) 10,674 -4,606.06 -2,992.18 3,540.38 1,497.42 558.37 4,016.24 4,947.85 3,711.98
    Pre-16 Universal Infant Free School 12,249 -833.09 4,674.87 1,237.11 4,231.79 1,627.32 1,311.00
    Meals
    Primary PE and Sport Premium 0
    Residential Support Scheme 13,467 -2,340.22 675.61 2,612.81 2,123.28 3,108.77 4,621.01 2,665.74
    19+ Continuing Learners in SFC 17,547 4,694.97 1,786.93 4,654.77 73.89 3,617.41 2,718.56 0.47
    (Student Support)
    Area Review Transition Grant 9,386 378.46 907.21 3,722.16 4,377.73 0.44
    16+ Factor Removal (DSG) SSF 10,656 -3,868.44 2,579.05 411.23 4,800.72 4,853.61 1,369.69 510.14
    Alternative Completions - Sporting 9,364 -4,902.14 4,906.47 325.58 232.51 4,284.66 4,516.26 0.66
    Excellence
    Alternative Completions - Sea Fishing 14,160 2,632.91 2,738.66 1,078.48 3,564.53 4,145.42
    Alternative Completions - Creative 5,160 3,319.27 1,839.81 0.92
    Sector
    1619BF - Discretionary 7,352 -4,470.23 -1,021.55 2,947.65 2,511.01 4,151.07 502.81 2,597.64 132.69 0.91
    Young Offenders Institute 20,794 -1,522.51 2,491.89 2,987.85 429.82 4,521.18 4,045.32 3,357.96 4,482.49
    Core Cities Youth Contract 7,833 -3,966.57 -2,952.97 4,769.14 1,880.21 347.87 2,938.67 3,817.42 505.49 493.74
    19+ Continuing Learners 9,122 -2,438.35 3,487.51 2,482.91 4,293.28 420.84 875.81
    LA Other 2 7,275 -4,646.26 -344.61 4,472.01 3,434.63 948.58 1,900.31 1,510.34
    LA Youth Contract 5,629 -1,658.35 -4,059.65 2,852.03 2,885.79 294.01 3,910.49 1,404.34 0.34
    Exceptional Support 6,922 -3,452.94 1,424.44 823.73 1,827.33 1,774.45 4,524.87 0.12
    TechBacc 11,310 -2,298.82 4,260.51 2,905.89 1,457.22 1,867.53 3,117.67
    DADA 17,907 -677.52 -1,498.72 4,895.98 781.35 2,282.91 1,554.35 4,251.88 4,073.17 2,243.60
    Improvement Support Grant 8,612 -4,848.27 1,859.91 2,262.81 4,165.25 3,141.55 2,030.75
    Basic Skills Maths 1619 14,577 -3,316.11 2,900.39 958.56 2,220.29 1,123.66 2,102.92 1,085.81 3,250.71 4,250.55
    Total Funding 247,252 -47,602.74 -22,033.45 0.00 40,948.82 22,268.73 28,543.74 31,818.90 31,818.04 37,253.81 44,874.08 40,675.81 38,686.04
    Ref (for internal use only):  [ContractNo]
    Page 11 of 11 of the Payment Schedules
	"""    

   #And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Publish the contract
    And   the latest version of contract '[ContractNo]' is in a state of 'Published to Provider'
   
    # Inject an SFS contract approval message.
   #When  an AEB contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved in CRM
    Then  the latest version of contract '[ContractNo]' is in status 'Approved'

    # Check the deliverable counts in CRM 
   #And   there are 'nnn' deliverable periods in CRM linked to the latest version of contract 'xxxx-436' and allocation 'xxxx-436' 
   #And   there are 'nnn' deliverable period rows in CRM linked to the latest version of contract 'xxxx-436' 
    And   there are '900' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 

    # Tidy up
    And   the override date is reset
  
