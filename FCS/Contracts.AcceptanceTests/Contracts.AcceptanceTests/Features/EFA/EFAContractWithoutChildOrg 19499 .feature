Feature: EFAContractWithoutChildOrg 19499 

@AcceptanceTest @Withdrawn20200717
Scenario: A124 Bulk load a three-allocation 1718 EFA contract with a full set of deliverables but no Delivery Org. Check contract docs
    Given there is no Contract, Task or Workflow data for UKPRN '10017124'
    And   there is no Organisation data for UKPRN '10017124'
   #And   caseload advisor 'FCS2 Test' is assigned to provider '10017124 Co Ltd' with UKPRN '10017124' and OrgId 'ORG0017124' and has 'FCS1 Test' as a manager

    # Bulk import to create a new EFA contract
    And   there are no files prefixed '10017124_1619F' in the Sharepoint '1619FUND-1718-Input-Appendices' folder
    And   there are no files prefixed '1619FUND AY 1718 19062017182754 v3_A124' in the Sharepoint 'Processed' folder
    And   there are no files prefixed '1619FUND AY 1718 19062017182754 v3_A124' in the Sharepoint 'Reports' folder
    And   the override date is '19/07/2017'
    And   spreadsheet '1619FUND AY 1718 19062017182754 v3_A124.xlsx' exists in the Datafiles folder and UKPRN '10017124' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report
	And   the Organisation in CRM has a UPIN associated with UKPRN '10017124'

    # Retrieve parameters
    And   I retrieve the latest EFA contract details from CRM for provider '10017124' for FundingType '1619FUND' and period '1718'
   #And   I retrieve the latest EFA contract details from CRM for provider '10017124' for FundingType '1619FUND' and period '1718' and Delivery Organisation '10171241'

    # Check the contents of the Appendices
    And   a file for this contract exists in sharepoint location '1619FUND-1718-Input-Appendices'
   #And   the pdf file contains the following simple lines in order
   #And   the pdf file contains the following parameterized lines in order
    And   the pdf file which contains a upin and the following parameterized lines in order
    """
    Payment Schedule Summary
    Provider: NACRO UPIN: [UPIN] UKPRN: 10017124
    Master Contract Ref: [MasterContractNo] Start Date: 01/08/2017 End Date: 31/07/2018
    Cash (£) Aug 2017 Sep 2017 Oct 2017 Nov 2017 Dec 2017 Jan 2018 Feb 2018 Mar 2018 Apr 2018 May 2018 Jun 2018 Jul 2018
    16-19 Total Programme Funding 14,800 -3,581.49 -4,742.04 2,354.36 3,107.26 1,349.76 3,160.13 4,238.71 4,694.46 4,218.86
    16-19 Bursary Funds 2,678 -2,768.72 -2,821.59 748.06 715.28 1,805.52 4,324.35 675.08 0.03
    16-19 Formula Protection Funding 14,060 1,891.17 2,301.48 4,767.43 3,953.23 768.16 377.94 0.59
    16-19 High Needs Element 2 16,607 -4,135.33 1,679.67 4,376.22 4,198.51 2,367.03 4,304.25 3,815.71 0.94
    14-16 Programme Funding 4,203 -206.79 -3,675.56 1,752.65 1,435.41 4,092.75 272.21 80.81 451.53
    14-16 Pupil Premium 2,745 -4,689.16 -600.99 4,641.59 3,392.72 0.85
    16-19 Free Meals in FE 22,346 -2,267.75 2,863.01 1,203.81 3,689.86 4,732.48 4,171.96 3,727.88 4,224.76
    16-19 High Needs SPI Element 1 21,435 -4,696.59 330.31 4,594.95 4,667.93 4,402.56 4,679.61 647.55 4,614.06 2,194.62
    19+ Continuing Learners Programme 2,667 -4,983.06 -1,875.72 1,685.91 4,785.35 2,743.39 310.21 0.93
    Funding
    SSF Total Programme Funding 10,809 3,066.87 3,171.62 90.11 4,479.59 0.81
    SSF Bursary Funds 21,495 -977.49 -476.53 659.04 1,115.79 639.93 4,902.58 4,975.55 4,711.19 4,988.23 956.71
    SSF Formula Protection Funding 6,513 -83.32 -2,524.82 3,454.89 1,994.54 3,051.02 620.69
    SSF High Needs Element 2 16,394 3,950.86 3,600.84 777.46 4,406.62 3,124.98 533.24
    Maintained Special SSF Element 2 7,189 -4,532.91 2,767.54 830.33 2,978.04 1,062.92 2,067.52 2,015.56
    Maintained Special SSF Student Support 6,641 -1,577.77 -4,492.71 2,925.17 2,490.51 4,129.58 480.32 2,575.15 110.76
    Residential Bursary Fund 17,734 -147.68 2,035.93 4,349.69 1,791.66 4,065.22 1,771.56 1,156.19 2,711.44
    Closing Schools 1,204 -1,768.98 -1,481.51 2,055.04 2,141.68 257.77
    Cadets Vocational Programme 2,632 -3,136.59 -3,829.94 4,521.98 2,214.65 1,229.16 1,632.05 0.70
    NMF Pre-16 Funding (NMSS) 15,423 -1,941.27 -2,035.35 2,921.11 3,324.01 3,272.12 4,699.71 1,811.76 277.44 3,093.47
    SSF Free Meals 4,604 -1,262.77 2,960.13 2,272.77 633.69 0.19
    Pre-16 Universal Infant Free School 16,609 -2,329.25 4,070.46 4,599.21 3,574.51 2,464.16 3,119.74 1,110.17
    Meals
    Primary PE and Sport Premium 0
    Residential Support Scheme 4,950 -1,976.23 3,542.73 104.95 3,099.64 178.91
    19+ Continuing Learners in SFC 4,696 137.73 507.84 4,050.37 0.07
    (Student Support)
    Area Review Transition Grant 13,672 4,156.11 1,605.51 4,897.34 3,013.05
    16+ Factor Removal (DSG) SSF 3,289 -4,764.32 336.55 2,187.13 2,728.53 706.67 2,094.05 0.40
    Total Funding 255,395 -31,973.88 -48,410.35 0.00 36,696.22 37,846.75 46,919.66 36,134.90 51,099.30 27,846.54 38,883.00 34,655.94 25,697.05
    Ref (for internal use only):  [ContractNo]
    Page 1 of 1 of the Payment Schedules
    """

	# Tidy up
	And   the override date is reset
