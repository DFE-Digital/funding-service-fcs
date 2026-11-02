Feature: Create2021EDSKcontractWithALLFalloc 28865

@AcceptanceTest @Withdrawn20230123
Scenario: A434 Bulk create a new 2021 EDSK contract with just an ALLF allocation. Publish and approve. Check CRM and docs
    Given there are no allocations marked as Under Termination for UKPRN '10017434' 
    And   there are no terminated or closed allocations for UKPRN '10017434' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017434' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017434' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | ALLF2021          |




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017434' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017434 Co Ltd' with UKPRN '10017434' and OrgId 'ORG0017434' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017434' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017434 | 117434 | 10017434 Co Ltd | 0              | Locked Restructure    | Yes           | AA017434      | ?             | 51 Stephens House      | Bank Court             | ?                      | ?                      | Hemel Hempstead        | Hertfordshire          | HP1 1DH   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017434 |




    # Change the date
    Given the override date is '15/07/2020'

    # Bulk NEW file - Conditions of Funding (Grant)(LA)
    And   there are no files prefixed '10017434' in the Sharepoint 'EDSK-2021-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2021 23032020093454 v3_A434' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2021 23032020093454 v3_A434' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2021 23032020093454 v3_A434' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2021 23032020093454 v3_A434' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2021 23032020093454 v3_A434.xlsx' exists in the Datafiles folder and UKPRN '10017434' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Retrieve parameters
   #And   I retrieve the latest EFA contract details from CRM for provider '10017434' for FundingType 'EDSK' and period '2021' and Delivery Organisation '00000000'
    And   I retrieve the latest contract details from CRM for provider '10017434' for FundingType 'EDSK' and period '2021'

    # Check the contents of the Appendices
   #And   a file for this contract exists in sharepoint location 'EDSK-2021-Input-Appendices'
   #And   the pdf file contains the following page lines in order
    And   the file named '10017434_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2021-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2020/21
    Organisation Name: 10017434 Co Ltd UKPRN: 10017434
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 20 - Mar 21 Apr 21 - Jul 21 2020/21 Total
    Advanced Learner Loans Facility [AllocRef_ALLF] £33,860 £11,219 £45,079
    Total Funding for this contract: £45,079
    Summary of Funding – Page 1

    Agreement Type Conditions of Funding (Grant) (Local Authorities)
    Funding Period 1 August 2020 to 31 July 2021
    the Secretary of State for Education (acting through
    Between
    the Education and Skills Funding Agency)
    And 10017434 Co Ltd
    Funding for Advanced Learner Loans
    Master Agreement Number [MasterContractNo]
    51 Stephens House EDUCATION ACTING THROUGH
    Bank Court THE EDUCATION AND SKILLS
    Hemel Hempstead FUNDING AGENCY, AN
    Hertfordshire EXECUTIVE AGENCY OF THE
    HP1 1DH DEPARTMENT OF EDUCATION
    AND CHEYLESMORE HOUSE
    QUINTON ROAD
    Company No: AA017434 COVENTRY
    CV1 2WT
    Hereinafter called Hereinafter called
    the Provider the Department

	SCHEDULE 1: SPECIFICATION & MONITORING
    Summary of Service
    1. Advanced Learner Loans provide a source of fees and support to help
    people aged 19 and over undertake general and technical qualifications at
    levels 3, 4, 5 and 6 that will be provided by the Provider.

    SCHEDULE 2: PAYMENT
	ADVANCED LEARNER LOANS PAYMENT (PAY ON PROFILE)
	3. The Department will pay the Provider the Funding set out in the Funding
    Agreement of this Schedule on the 14 Working Day of each month.


    SCHEDULE 2 – ADVANCED LEARNER LOANS
    Funding Agreement – Advanced Learner Loans Facility
    Provider: 10017434 Co Ltd UKPRN: 10017434
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2020 End Date: 31/07/2021
    Contract Ref: [AllocRef_ALLF]
    Cash (£) Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021 Apr 2021 May 2021 Jun 2021 Jul 2021
    Advanced Learner Loans Facility £45,079 £4,973 £3,561 £5,684 £7,266 £4,633 £4,580 £2,627 £536 £4,697 £164 £2,085 £4,273
    Total Funding £45,079 £4,973 £3,561 £5,684 £7,266 £4,633 £4,580 £2,627 £536 £4,697 £164 £2,085 £4,273
    Schedule 2 – Advanced Learner Loans – Funding Agreement [AllocRef_ALLF] – Page 1 Ref (for internal use only):  [ContractNo] v1

	SCHEDULE 7: SECURITY & DEPARTMENT POLICIES
	7.2 To facilitate the transfer of knowledge from the Provider to the Department
    and/or its Successor Provider, the Provider will provide, upon request, a
    detailed written explanation of the procedures and operations used to
    provide the Services, the change management process and other
    standards and procedures to the operations personnel of the Department
    and/or the Successor Provider.
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017434_[ContractNo]_v1.pdf' in 'EDSK-2021-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A434.pdf'
	   	 
    # Contract status is now at 'Awaiting Documentation'




    # Change the date
    Given the override date is '23/07/2020'
	
	# Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
	When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017434 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017434 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '48' deliverable period rows in CRM linked to the latest version of contract 'EDSK-434'
    And   there are '48' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'



	# Tidy Up
	And   the override date is reset
	  
@AcceptanceTest @Withdrawn20230123
@ADP
Scenario: A433 Create and approve a new 2021 EDSK contract with just an ALLF allocation. Bulk amend and approve. Consume actuals 3x. Check CRM, financials and CDA
    Given there are no allocations marked as Under Termination for UKPRN '10017433' 
    And   there are no terminated or closed allocations for UKPRN '10017433' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017433' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017433' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | ALLF-433      |

    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | ALLF-433      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | ALLF2021          |




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017433' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017433 Co Ltd' with UKPRN '10017433' and OrgId 'ORG0017433' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017433' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017433 | 117433 | 10017433 Co Ltd | 0              | Active                | Yes           | AA017433      | ?             | 9 Ronaldshaw Park      | Ayr                    | ?                      | ?                      | ?                      | ?                      | KA7 2TJ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017433 |




    # Change the date
    Given the override date is '11/07/2020'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription  | ContractType                           | Period | CRMIntent    | OrgId      |
    | 10017433 | 10017433 Co Ltd      | ESFA-433             | EDSK-433       | 1                     | 01/08/2020        | 31/07/2021      | 20745.00      |                      | Conditions of Funding (Grant) (Trust)  | 2021   | New          | ORG0017433 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName   | UoPCode    | AllocationDescription   | CRMIntent    | DeliveryOrg |
    | 10017433 | EDSK-433       | ALLF-433      | ALLF              | ALLF2021                | AY                      | 01/08/2020          | 31/07/2021        | 20745.00        |           |            |                         | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription            | CRMIntent    | DeliveryOrg |
    | 10017433 | EDSK-433       | ALLF-433      | 5               | 0                     | 20745.00  | 10402.00  | 10343.00  | 3317.00  | 604.00   | 1340.00  | 115.00   | 90.00    | 2882.00  | 1909.00  | 145.00   | 1736.00  | 2630.00  | 3648.00  | 2329.00  | Advanced Learner Loans Facility   | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-433'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-433' and actual ContractNumber 'EDSK-433'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-433' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017433 | EDSK-433           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017433 | ESFA-433           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

#    # Check the deliverable count in CRM includes all the monitoring deliverables
#    And   there are '48' deliverable period rows in CRM linked to the latest version of contract 'EDSK-433'



    # Change the date
    Given the override date is '26/07/2020'

    # Bulk file to amend contract
    And   there are no files prefixed '10017433' in the Sharepoint 'EDSK-2021-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2021 24032020073516 v3_A433' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2021 24032020073516 v3_A433' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2021 24032020073516 v3_A433' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2021 24032020073516 v3_A433' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2021 24032020073516 v3_A433.xlsx' exists in the Datafiles folder and UKPRN '10017433' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report




	# Change the date
	Given the override date is '27/07/2020'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-433'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-433' and actual ContractNumber 'EDSK-433'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-433' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017433 | EDSK-433           | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017433 | EDSK-433           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017433 | ESFA-433           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '48' deliverable period rows in CRM linked to the latest version of contract 'EDSK-433'




    # Add actuals to the contract

    # Change the date
    Given the override date is '04/09/2020'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017433'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Aug 2020
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR2021        | R01                  | ORG0017433     | CM             | 202008 | ALLF2021                | ALLF-433                 | ?          | 2               | 0            | 941.61      |
    | ILR2021        | R01                  | ORG0017433     | CM             | 202008 | ALLF2021                | ALLF-433                 | ?          | 6               | 0            | 561.78      |
    | ILR2021        | R01                  | ORG0017433     | CM             | 202008 | ALLF2021                | ALLF-433                 | ?          | 7               | 0            | 1166.76     |
    | ILR2021        | R01                  | ORG0017433     | CM             | 202009 | ALLF2021                | ALLF-433                 | ?          | 2               | 0            | 805.40      |
    | ILR2021        | R01                  | ORG0017433     | CM             | 202009 | ALLF2021                | ALLF-433                 | ?          | 6               | 0            | 378.77      |
    | ILR2021        | R01                  | ORG0017433     | CM             | 202009 | ALLF2021                | ALLF-433                 | ?          | 7               | 0            | 2440.72     |
    | ILR2021        | R01                  | ORG0017433     | CM             | 202010 | ALLF2021                | ALLF-433                 | ?          | 2               | 0            | 358.65      |
    | ILR2021        | R01                  | ORG0017433     | CM             | 202010 | ALLF2021                | ALLF-433                 | ?          | 6               | 0            | 1343.57     |
    | ILR2021        | R01                  | ORG0017433     | CM             | 202010 | ALLF2021                | ALLF-433                 | ?          | 7               | 0            | 222.66      |
    | ILR2021        | R01                  | ORG0017433     | CM             | 202011 | ALLF2021                | ALLF-433                 | ?          | 2               | 0            | 1533.86     |
    | ILR2021        | R01                  | ORG0017433     | CM             | 202011 | ALLF2021                | ALLF-433                 | ?          | 6               | 0            | 604.81      |
    | ILR2021        | R01                  | ORG0017433     | CM             | 202011 | ALLF2021                | ALLF-433                 | ?          | 7               | 0            | 1428.34     |
    | ILR2021        | R01                  | ORG0017433     | CM             | 202012 | ALLF2021                | ALLF-433                 | ?          | 2               | 0            | 498.61      |
    | ILR2021        | R01                  | ORG0017433     | CM             | 202012 | ALLF2021                | ALLF-433                 | ?          | 6               | 0            | 2115.19     |
    | ILR2021        | R01                  | ORG0017433     | CM             | 202012 | ALLF2021                | ALLF-433                 | ?          | 7               | 0            | 2433.31     |
    | ILR2021        | R01                  | ORG0017433     | CM             | 202101 | ALLF2021                | ALLF-433                 | ?          | 2               | 0            | 225.49      |
    | ILR2021        | R01                  | ORG0017433     | CM             | 202101 | ALLF2021                | ALLF-433                 | ?          | 6               | 0            | 1459.32     |
    | ILR2021        | R01                  | ORG0017433     | CM             | 202101 | ALLF2021                | ALLF-433                 | ?          | 7               | 0            | 576.63      |
    | ILR2021        | R01                  | ORG0017433     | CM             | 202102 | ALLF2021                | ALLF-433                 | ?          | 2               | 0            | 1218.29     |
    | ILR2021        | R01                  | ORG0017433     | CM             | 202102 | ALLF2021                | ALLF-433                 | ?          | 6               | 0            | 362.50      |
    | ILR2021        | R01                  | ORG0017433     | CM             | 202102 | ALLF2021                | ALLF-433                 | ?          | 7               | 0            | 172.30      |
    | ILR2021        | R01                  | ORG0017433     | CM             | 202103 | ALLF2021                | ALLF-433                 | ?          | 2               | 0            | 465.61      |
    | ILR2021        | R01                  | ORG0017433     | CM             | 202103 | ALLF2021                | ALLF-433                 | ?          | 6               | 0            | 2067.56     |
    | ILR2021        | R01                  | ORG0017433     | CM             | 202103 | ALLF2021                | ALLF-433                 | ?          | 7               | 0            | 1666.09     |
    | ILR2021        | R01                  | ORG0017433     | CM             | 202104 | ALLF2021                | ALLF-433                 | ?          | 2               | 0            | 2107.44     |
    | ILR2021        | R01                  | ORG0017433     | CM             | 202104 | ALLF2021                | ALLF-433                 | ?          | 6               | 0            | 1722.52     |
    | ILR2021        | R01                  | ORG0017433     | CM             | 202104 | ALLF2021                | ALLF-433                 | ?          | 7               | 0            | 1709.94     |
    | ILR2021        | R01                  | ORG0017433     | CM             | 202105 | ALLF2021                | ALLF-433                 | ?          | 2               | 0            | 299.68      |
    | ILR2021        | R01                  | ORG0017433     | CM             | 202105 | ALLF2021                | ALLF-433                 | ?          | 6               | 0            | 2124.44     |
    | ILR2021        | R01                  | ORG0017433     | CM             | 202105 | ALLF2021                | ALLF-433                 | ?          | 7               | 0            | 118.18      |
    | ILR2021        | R01                  | ORG0017433     | CM             | 202106 | ALLF2021                | ALLF-433                 | ?          | 2               | 0            | 2182.90     |
    | ILR2021        | R01                  | ORG0017433     | CM             | 202106 | ALLF2021                | ALLF-433                 | ?          | 6               | 0            | 500.92      |
    | ILR2021        | R01                  | ORG0017433     | CM             | 202106 | ALLF2021                | ALLF-433                 | ?          | 7               | 0            | 2060.38     |
    | ILR2021        | R01                  | ORG0017433     | CM             | 202107 | ALLF2021                | ALLF-433                 | ?          | 2               | 0            | 1691.44     |
    | ILR2021        | R01                  | ORG0017433     | CM             | 202107 | ALLF2021                | ALLF-433                 | ?          | 6               | 0            | 1119.98     |
    | ILR2021        | R01                  | ORG0017433     | CM             | 202107 | ALLF2021                | ALLF-433                 | ?          | 7               | 0            | 519.17      |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    #Check CRM

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | EDSK-433       | ALLF-433           | 2               | 12328.98  | 941.61   | 805.40   | 358.65   | 1533.86  | 498.61   | 225.49   | 1218.29  | 465.61   | 2107.44  | 299.68   | 2182.90  | 1691.44  | 
    | EDSK-433       | ALLF-433           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-433       | ALLF-433           | 6               | 14361.36  | 561.78   | 378.77   | 1343.57  | 604.81   | 2115.19  | 1459.32  | 362.50   | 2067.56  | 1722.52  | 2124.44  | 500.92   | 1119.98  | 
    | EDSK-433       | ALLF-433           | 7               | 14514.48  | 1166.76  | 2440.72  | 222.66   | 1428.34  | 2433.31  | 576.63   | 172.30   | 1666.09  | 1709.94  | 118.18   | 2060.38  | 519.17   | 

    # Actuals are not paid by the SFA but RECONCILIATION fields will have non-zero values for deliverable 7 to reflect what has been paid by the Student Loans Company 
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | EDSK-433       | ALLF-433           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-433       | ALLF-433           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-433       | ALLF-433           | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-433       | ALLF-433           | 7               | 1166.76   | 1166.76  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | EDSK-433       | ALLF-433           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-433       | ALLF-433           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-433       | ALLF-433           | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-433       | ALLF-433           | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Actuals are not paid by the SFA but NET fields will have non-zero values for deliverable 7 to reflect what has been paid by the Student Loans Company 
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | EDSK-433       | ALLF-433           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-433       | ALLF-433           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-433       | ALLF-433           | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-433       | ALLF-433           | 7               | 1166.76   | 1166.76  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 



    # Check ADP

    # Check all activity has completed
    When  there are no messages left in the system

    # Check that certain entries have not been written to the AllocationDelivery.AllocationDeliveryEntry table
    Then  the AllocationDelivery.AllocationDeliveryEntry table does not contain an ItemType '3' event for version '2' of contract number 'EDSK-433' and allocation number 'ALLF-433'
    Then  the AllocationDelivery.AllocationDeliveryEntry table does not contain an ItemType '4' event for version '2' of contract number 'EDSK-433' and allocation number 'ALLF-433'

    # Check that the relevant events are on the ADP feed
    Then  the ADP feed includes the following values
    | AllocationDeliveryEntryCategory   | ADCode | ContractNumber  | ContractVersionNumber | SubVersionNumber | AllocationNumber | DeliveryOrganisationUKPRN | DeliveryOrganisationProvider |
    | NewContractAllocationApproved     | 0      | EDSK-433        | 1                     | 0                | ALLF-433         | ?                         | ?                            |
    | AmendedContractAllocationApproved | 1      | EDSK-433        | 2                     | 0                | ALLF-433         | ?                         | ?                            |
    | ContractAllocationActualsReceived | 2      | EDSK-433        | 2                     | 0                | ALLF-433         | ?                         | ?                            |

    # Check the ADP feed event header information
    And   the Allocation Delivery feed includes the following event information
    | UKPRN    | ContractNumber  | ContractVersion | ContractSubVersion | CategoryTerm                        | CategoryLabel                        | Title                                                                            |
    | 10017433 | EDSK-433        | 1               | 0                  | NewContractAllocationApproved       | New Contract Allocation Approved     | New Contract EDSK-433: 1.0 with Allocation ALLF-433 was Approved                 |
    | 10017433 | EDSK-433        | 2               | 0                  | AmendedContractAllocationApproved   | Amended Contract Allocation Approved | Amendment to Contract EDSK-433: 2.0 with Allocation ALLF-433 was Approved        |
    | 10017433 | EDSK-433        | 2               | 0                  | ContractAllocationActualsReceived   | Contract Allocation Actuals Received | Actuals for Allocation ALLF-433 of Contract EDSK-433: 2.0 have been received     |

    # Check financials on the ADP feed
    And   the Allocation Delivery Monitoring Service atom feed contains the following Allocation Delivery Performance events and values
    | AllocationDeliveryEntryCategory   | ContractNumber  | VersionNumber | AllocationNumber | DeliverableCode | Period | ActualValue | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | NetPayment |
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 2               | 202008 | 941.61      | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 2               | 202009 | 805.40      | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 2               | 202010 | 358.65      | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 2               | 202011 | 1533.86     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 2               | 202012 | 498.61      | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 2               | 202101 | 225.49      | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 2               | 202102 | 1218.29     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 2               | 202103 | 465.61      | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 2               | 202104 | 2107.44     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 2               | 202105 | 299.68      | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 2               | 202106 | 2182.90     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 2               | 202107 | 1691.44     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    #
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 5               | 202008 | 0.00        | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 5               | 202009 | 0.00        | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 5               | 202010 | 0.00        | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 5               | 202011 | 0.00        | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 5               | 202012 | 0.00        | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 5               | 202101 | 0.00        | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 5               | 202102 | 0.00        | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 5               | 202103 | 0.00        | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 5               | 202104 | 0.00        | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 5               | 202105 | 0.00        | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 5               | 202106 | 0.00        | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 5               | 202107 | 0.00        | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    #
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 6               | 202008 | 561.78      | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 6               | 202009 | 378.77      | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 6               | 202010 | 1343.57     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 6               | 202011 | 604.81      | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 6               | 202012 | 2115.19     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 6               | 202101 | 1459.32     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 6               | 202102 | 362.50      | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 6               | 202103 | 2067.56     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 6               | 202104 | 1722.52     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 6               | 202105 | 2124.44     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 6               | 202106 | 500.92      | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 6               | 202107 | 1119.98     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    #
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 7               | 202008 | 1166.76     | 0.00           | 0.00             | 1166.76               | 0.00           | 1166.76    |
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 7               | 202009 | 2440.72     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 7               | 202010 | 222.66      | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 7               | 202011 | 1428.34     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 7               | 202012 | 2433.31     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 7               | 202101 | 576.63      | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 7               | 202102 | 172.30      | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 7               | 202103 | 1666.09     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 7               | 202104 | 1709.94     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 7               | 202105 | 118.18      | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 7               | 202106 | 2060.38     | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 7               | 202107 | 519.17      | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00       |

    # Check Planned data on the ADP feed
    And   the Allocation Delivery Monitoring Service atom feed contains the following Planned data
    | AllocationDeliveryEntryCategory   | ContractNumber  | VersionNumber | AllocationNumber | DeliverableCode | Period | PlannedValue | PlannedVolume |
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 5               | 202008 | 6042.00      | 0             |
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 5               | 202009 | 4291.00      | 0             |
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 5               | 202010 | 7233.00      | 0             |
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 5               | 202011 | 5957.00      | 0             |
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 5               | 202012 | 4545.00      | 0             |
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 5               | 202101 | 6669.00      | 0             |
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 5               | 202102 | 8299.00      | 0             |
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 5               | 202103 | 5617.00      | 0             |
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 5               | 202104 | 5534.00      | 0             |
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 5               | 202105 | 3611.00      | 0             |
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 5               | 202106 | 1520.00      | 0             |
    | ContractAllocationActualsReceived | EDSK-433        | 2             | ALLF-433         | 5               | 202107 | 5682.00      | 0             |





    # Add actuals to the contract again (Figures change for previous period)

    # Change the date
    Given the override date is '04/10/2020'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Pull actuals from DC for Sep 2020
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR2021        | R02                  | ORG0017433     | CM             | 202008 | ALLF2021                | ALLF-433                 | ?          | 2               | 0            | 342.69      |
    | ILR2021        | R02                  | ORG0017433     | CM             | 202008 | ALLF2021                | ALLF-433                 | ?          | 6               | 0            | 1072.41     |
    | ILR2021        | R02                  | ORG0017433     | CM             | 202008 | ALLF2021                | ALLF-433                 | ?          | 7               | 0            | 1693.26     |
    | ILR2021        | R02                  | ORG0017433     | CM             | 202009 | ALLF2021                | ALLF-433                 | ?          | 2               | 0            | 850.69      |
    | ILR2021        | R02                  | ORG0017433     | CM             | 202009 | ALLF2021                | ALLF-433                 | ?          | 6               | 0            | 768.49      |
    | ILR2021        | R02                  | ORG0017433     | CM             | 202009 | ALLF2021                | ALLF-433                 | ?          | 7               | 0            | 294.83      |
    | ILR2021        | R02                  | ORG0017433     | CM             | 202010 | ALLF2021                | ALLF-433                 | ?          | 2               | 0            | 726.60      |
    | ILR2021        | R02                  | ORG0017433     | CM             | 202010 | ALLF2021                | ALLF-433                 | ?          | 6               | 0            | 2248.92     |
    | ILR2021        | R02                  | ORG0017433     | CM             | 202010 | ALLF2021                | ALLF-433                 | ?          | 7               | 0            | 1679.09     |
    | ILR2021        | R02                  | ORG0017433     | CM             | 202011 | ALLF2021                | ALLF-433                 | ?          | 2               | 0            | 2047.23     |
    | ILR2021        | R02                  | ORG0017433     | CM             | 202011 | ALLF2021                | ALLF-433                 | ?          | 6               | 0            | 1816.88     |
    | ILR2021        | R02                  | ORG0017433     | CM             | 202011 | ALLF2021                | ALLF-433                 | ?          | 7               | 0            | 2135.69     |
    | ILR2021        | R02                  | ORG0017433     | CM             | 202012 | ALLF2021                | ALLF-433                 | ?          | 2               | 0            | 345.91      |
    | ILR2021        | R02                  | ORG0017433     | CM             | 202012 | ALLF2021                | ALLF-433                 | ?          | 6               | 0            | 2065.29     |
    | ILR2021        | R02                  | ORG0017433     | CM             | 202012 | ALLF2021                | ALLF-433                 | ?          | 7               | 0            | 2307.03     |
    | ILR2021        | R02                  | ORG0017433     | CM             | 202101 | ALLF2021                | ALLF-433                 | ?          | 2               | 0            | 2032.25     |
    | ILR2021        | R02                  | ORG0017433     | CM             | 202101 | ALLF2021                | ALLF-433                 | ?          | 6               | 0            | 1955.26     |
    | ILR2021        | R02                  | ORG0017433     | CM             | 202101 | ALLF2021                | ALLF-433                 | ?          | 7               | 0            | 1140.18     |
    | ILR2021        | R02                  | ORG0017433     | CM             | 202102 | ALLF2021                | ALLF-433                 | ?          | 2               | 0            | 1173.54     |
    | ILR2021        | R02                  | ORG0017433     | CM             | 202102 | ALLF2021                | ALLF-433                 | ?          | 6               | 0            | 959.05      |
    | ILR2021        | R02                  | ORG0017433     | CM             | 202102 | ALLF2021                | ALLF-433                 | ?          | 7               | 0            | 2395.75     |
    | ILR2021        | R02                  | ORG0017433     | CM             | 202103 | ALLF2021                | ALLF-433                 | ?          | 2               | 0            | 1556.04     |
    | ILR2021        | R02                  | ORG0017433     | CM             | 202103 | ALLF2021                | ALLF-433                 | ?          | 6               | 0            | 114.04      |
    | ILR2021        | R02                  | ORG0017433     | CM             | 202103 | ALLF2021                | ALLF-433                 | ?          | 7               | 0            | 1773.29     |
    | ILR2021        | R02                  | ORG0017433     | CM             | 202104 | ALLF2021                | ALLF-433                 | ?          | 2               | 0            | 445.82      |
    | ILR2021        | R02                  | ORG0017433     | CM             | 202104 | ALLF2021                | ALLF-433                 | ?          | 6               | 0            | 1727.47     |
    | ILR2021        | R02                  | ORG0017433     | CM             | 202104 | ALLF2021                | ALLF-433                 | ?          | 7               | 0            | 434.74      |
    | ILR2021        | R02                  | ORG0017433     | CM             | 202105 | ALLF2021                | ALLF-433                 | ?          | 2               | 0            | 1306.33     |
    | ILR2021        | R02                  | ORG0017433     | CM             | 202105 | ALLF2021                | ALLF-433                 | ?          | 6               | 0            | 961.32      |
    | ILR2021        | R02                  | ORG0017433     | CM             | 202105 | ALLF2021                | ALLF-433                 | ?          | 7               | 0            | 1037.02     |
    | ILR2021        | R02                  | ORG0017433     | CM             | 202106 | ALLF2021                | ALLF-433                 | ?          | 2               | 0            | 537.90      |
    | ILR2021        | R02                  | ORG0017433     | CM             | 202106 | ALLF2021                | ALLF-433                 | ?          | 6               | 0            | 301.31      |
    | ILR2021        | R02                  | ORG0017433     | CM             | 202106 | ALLF2021                | ALLF-433                 | ?          | 7               | 0            | 1862.90     |
    | ILR2021        | R02                  | ORG0017433     | CM             | 202107 | ALLF2021                | ALLF-433                 | ?          | 2               | 0            | 472.74      |
    | ILR2021        | R02                  | ORG0017433     | CM             | 202107 | ALLF2021                | ALLF-433                 | ?          | 6               | 0            | 1209.45     |
    | ILR2021        | R02                  | ORG0017433     | CM             | 202107 | ALLF2021                | ALLF-433                 | ?          | 7               | 0            | 1950.58     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check CRM and PaaS

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | EDSK-433       | ALLF-433           | 2               | 11837.74  | 342.69   | 850.69   | 726.60   | 2047.23  | 345.91   | 2032.25  | 1173.54  | 1556.04  | 445.82   | 1306.33  | 537.90   | 472.74   | 
    | EDSK-433       | ALLF-433           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-433       | ALLF-433           | 6               | 15199.89  | 1072.41  | 768.49   | 2248.92  | 1816.88  | 2065.29  | 1955.26  | 959.05   | 114.04   | 1727.47  | 961.32   | 301.31   | 1209.45  | 
    | EDSK-433       | ALLF-433           | 7               | 18704.36  | 1693.26  | 294.83   | 1679.09  | 2135.69  | 2307.03  | 1140.18  | 2395.75  | 1773.29  | 434.74   | 1037.02  | 1862.90  | 1950.58  | 

    # Actuals are not paid by the SFA but RECONCILIATION fields will have non-zero values for deliverable 7 to reflect what has been paid by the Student Loans Company 
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | EDSK-433       | ALLF-433           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-433       | ALLF-433           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-433       | ALLF-433           | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-433       | ALLF-433           | 7               | 1988.09   | 1693.26  | 294.83   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | EDSK-433       | ALLF-433           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-433       | ALLF-433           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-433       | ALLF-433           | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-433       | ALLF-433           | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Actuals are not paid by the SFA but NET fields will have non-zero values for deliverable 7 to reflect what has been paid by the Student Loans Company 
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | EDSK-433       | ALLF-433           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-433       | ALLF-433           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-433       | ALLF-433           | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-433       | ALLF-433           | 7               | 1988.09   | 1693.26  | 294.83   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 




    # Add actuals to the contract (Figures change again)

    # Change the date
    Given the override date is '04/12/2020'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Nov 2020
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR2021        | R04                  | ORG0017433     | CM             | 202008 | ALLF2021                | ALLF-433                 | ?          | 2               | 0            | 1493.63     |
    | ILR2021        | R04                  | ORG0017433     | CM             | 202008 | ALLF2021                | ALLF-433                 | ?          | 6               | 0            | 1262.24     |
    | ILR2021        | R04                  | ORG0017433     | CM             | 202008 | ALLF2021                | ALLF-433                 | ?          | 7               | 0            | 245.91      |
    | ILR2021        | R04                  | ORG0017433     | CM             | 202009 | ALLF2021                | ALLF-433                 | ?          | 2               | 0            | 1676.37     |
    | ILR2021        | R04                  | ORG0017433     | CM             | 202009 | ALLF2021                | ALLF-433                 | ?          | 6               | 0            | 890.51      |
    | ILR2021        | R04                  | ORG0017433     | CM             | 202009 | ALLF2021                | ALLF-433                 | ?          | 7               | 0            | 1581.53     |
    | ILR2021        | R04                  | ORG0017433     | CM             | 202010 | ALLF2021                | ALLF-433                 | ?          | 2               | 0            | 1958.14     |
    | ILR2021        | R04                  | ORG0017433     | CM             | 202010 | ALLF2021                | ALLF-433                 | ?          | 6               | 0            | 1129.35     |
    | ILR2021        | R04                  | ORG0017433     | CM             | 202010 | ALLF2021                | ALLF-433                 | ?          | 7               | 0            | 1362.64     |
    | ILR2021        | R04                  | ORG0017433     | CM             | 202011 | ALLF2021                | ALLF-433                 | ?          | 2               | 0            | 1871.98     |
    | ILR2021        | R04                  | ORG0017433     | CM             | 202011 | ALLF2021                | ALLF-433                 | ?          | 6               | 0            | 1366.28     |
    | ILR2021        | R04                  | ORG0017433     | CM             | 202011 | ALLF2021                | ALLF-433                 | ?          | 7               | 0            | 266.43      |
    | ILR2021        | R04                  | ORG0017433     | CM             | 202012 | ALLF2021                | ALLF-433                 | ?          | 2               | 0            | 466.80      |
    | ILR2021        | R04                  | ORG0017433     | CM             | 202012 | ALLF2021                | ALLF-433                 | ?          | 6               | 0            | 1213.22     |
    | ILR2021        | R04                  | ORG0017433     | CM             | 202012 | ALLF2021                | ALLF-433                 | ?          | 7               | 0            | 1981.43     |
    | ILR2021        | R04                  | ORG0017433     | CM             | 202101 | ALLF2021                | ALLF-433                 | ?          | 2               | 0            | 704.39      |
    | ILR2021        | R04                  | ORG0017433     | CM             | 202101 | ALLF2021                | ALLF-433                 | ?          | 6               | 0            | 102.74      |
    | ILR2021        | R04                  | ORG0017433     | CM             | 202101 | ALLF2021                | ALLF-433                 | ?          | 7               | 0            | 2455.99     |
    | ILR2021        | R04                  | ORG0017433     | CM             | 202102 | ALLF2021                | ALLF-433                 | ?          | 2               | 0            | 801.38      |
    | ILR2021        | R04                  | ORG0017433     | CM             | 202102 | ALLF2021                | ALLF-433                 | ?          | 6               | 0            | 1999.81     |
    | ILR2021        | R04                  | ORG0017433     | CM             | 202102 | ALLF2021                | ALLF-433                 | ?          | 7               | 0            | 1150.69     |
    | ILR2021        | R04                  | ORG0017433     | CM             | 202103 | ALLF2021                | ALLF-433                 | ?          | 2               | 0            | 1909.60     |
    | ILR2021        | R04                  | ORG0017433     | CM             | 202103 | ALLF2021                | ALLF-433                 | ?          | 6               | 0            | 2448.17     |
    | ILR2021        | R04                  | ORG0017433     | CM             | 202103 | ALLF2021                | ALLF-433                 | ?          | 7               | 0            | 2436.61     |
    | ILR2021        | R04                  | ORG0017433     | CM             | 202104 | ALLF2021                | ALLF-433                 | ?          | 2               | 0            | 1108.84     |
    | ILR2021        | R04                  | ORG0017433     | CM             | 202104 | ALLF2021                | ALLF-433                 | ?          | 6               | 0            | 1229.48     |
    | ILR2021        | R04                  | ORG0017433     | CM             | 202104 | ALLF2021                | ALLF-433                 | ?          | 7               | 0            | 305.51      |
    | ILR2021        | R04                  | ORG0017433     | CM             | 202105 | ALLF2021                | ALLF-433                 | ?          | 2               | 0            | 413.57      |
    | ILR2021        | R04                  | ORG0017433     | CM             | 202105 | ALLF2021                | ALLF-433                 | ?          | 6               | 0            | 1930.86     |
    | ILR2021        | R04                  | ORG0017433     | CM             | 202105 | ALLF2021                | ALLF-433                 | ?          | 7               | 0            | 704.64      |
    | ILR2021        | R04                  | ORG0017433     | CM             | 202106 | ALLF2021                | ALLF-433                 | ?          | 2               | 0            | 1456.40     |
    | ILR2021        | R04                  | ORG0017433     | CM             | 202106 | ALLF2021                | ALLF-433                 | ?          | 6               | 0            | 1231.84     |
    | ILR2021        | R04                  | ORG0017433     | CM             | 202106 | ALLF2021                | ALLF-433                 | ?          | 7               | 0            | 1663.37     |
    | ILR2021        | R04                  | ORG0017433     | CM             | 202107 | ALLF2021                | ALLF-433                 | ?          | 2               | 0            | 345.19      |
    | ILR2021        | R04                  | ORG0017433     | CM             | 202107 | ALLF2021                | ALLF-433                 | ?          | 6               | 0            | 1820.48     |
    | ILR2021        | R04                  | ORG0017433     | CM             | 202107 | ALLF2021                | ALLF-433                 | ?          | 7               | 0            | 482.36      |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    #Check CRM
	
    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | EDSK-433       | ALLF-433           | 2               | 14206.29  | 1493.63  | 1676.37  | 1958.14  | 1871.98  | 466.80   | 704.39   | 801.38   | 1909.60  | 1108.84  | 413.57   | 1456.40  | 345.19   | 
    | EDSK-433       | ALLF-433           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-433       | ALLF-433           | 6               | 16624.98  | 1262.24  | 890.51   | 1129.35  | 1366.28  | 1213.22  | 102.74   | 1999.81  | 2448.17  | 1229.48  | 1930.86  | 1231.84  | 1820.48  | 
    | EDSK-433       | ALLF-433           | 7               | 14637.11  | 245.91   | 1581.53  | 1362.64  | 266.43   | 1981.43  | 2455.99  | 1150.69  | 2436.61  | 305.51   | 704.64   | 1663.37  | 482.36   | 

    # Actuals are not paid by the SFA but RECONCILIATION fields will have non-zero values for deliverable 7 to reflect what has been paid by the Student Loans Company 
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | EDSK-433       | ALLF-433           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-433       | ALLF-433           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-433       | ALLF-433           | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-433       | ALLF-433           | 7               | 3456.51   | 245.91   | 1581.53  | 1362.64  | 266.43   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | EDSK-433       | ALLF-433           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-433       | ALLF-433           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-433       | ALLF-433           | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-433       | ALLF-433           | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Actuals are not paid by the SFA but NET fields will have non-zero values for deliverable 7 to reflect what has been paid by the Student Loans Company 
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | EDSK-433       | ALLF-433           | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-433       | ALLF-433           | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-433       | ALLF-433           | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-433       | ALLF-433           | 7               | 3456.51   | 245.91   | 1581.53  | 1362.64  | 266.43   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 




#	# Run CDA report
#    Given there is no CDA report named 'CDA Last Approved Version A433.csv'
#
#    Then  the contracts are in the replicated CRM database as follows
#    | ContractNumber | ContractVersionNumber |
#    | EDSK-433       | 2                     |
#
#    When  the following CDA report is run
#    | FundingStreamPeriod  | Version               | Suffix |
#    | ALLF2021             | Last Approved Version | A433   |
#
#    Then  a report named 'CDA Last Approved Version A433.csv' is created
#
#    # Check the contents of the CDA report
#    And   the following rows are present in the report
#    | FundingStreamPeriodCode | UKPRN    | ProviderName                | DeliveryUKPRN | DeliveryProviderName        | ContractAllocationNumber | ContractNumber | MasterContractReference | ContractAllocationStartDate | ContractAllocationEndDate | ContractVersionNumber | ContractStatus | ContractSubStatus       | DeliverableDescription                               | Deliverable                                                     | DeliverableParent                                               | DeliverablePeriod | DeliverableYear | FinancialYear | PlanningUnit | PlannedValue | ActualEarned | PlannedVolume | ActualVolume | PayableDeliverable | ProfilePayment | BalancingPayment | ReconciliationPayment | CappingPayment | TotalNetPayment | PaymentHeld | PaymentPosted | UnitOfProcurement | LEP    | SubnominalProfile | SubnominalReconciliation | SubnominalCapping | DeliverableMonth |
#    | ALLF2021                | 10017433 | 10017433 Co Ltd             |               |                             | ALLF-433                 | EDSK-433       | ESFA-433                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                |                                                      | Advanced Learner Loans Facility                                 |                                                                 | 8                 | 2020            | 2020/21       |              | 6042         | 0            |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Aug              |
#    | ALLF2021                | 10017433 | 10017433 Co Ltd             |               |                             | ALLF-433                 | EDSK-433       | ESFA-433                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                |                                                      | Advanced Learner Loans Facility                                 |                                                                 | 9                 | 2020            | 2020/21       |              | 4291         | 0            |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Sep              |
#    | ALLF2021                | 10017433 | 10017433 Co Ltd             |               |                             | ALLF-433                 | EDSK-433       | ESFA-433                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                |                                                      | Advanced Learner Loans Facility                                 |                                                                 | 10                | 2020            | 2020/21       |              | 7233         | 0            |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Oct              |
#    | ALLF2021                | 10017433 | 10017433 Co Ltd             |               |                             | ALLF-433                 | EDSK-433       | ESFA-433                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                |                                                      | Advanced Learner Loans Facility                                 |                                                                 | 11                | 2020            | 2020/21       |              | 5957         | 0            |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Nov              |
#    | ALLF2021                | 10017433 | 10017433 Co Ltd             |               |                             | ALLF-433                 | EDSK-433       | ESFA-433                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                |                                                      | Advanced Learner Loans Facility                                 |                                                                 | 12                | 2020            | 2020/21       |              | 4545         | 0            |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Dec              |
#    | ALLF2021                | 10017433 | 10017433 Co Ltd             |               |                             | ALLF-433                 | EDSK-433       | ESFA-433                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                |                                                      | Advanced Learner Loans Facility                                 |                                                                 | 1                 | 2021            | 2020/21       |              | 6669         | 0            |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jan              |
#    | ALLF2021                | 10017433 | 10017433 Co Ltd             |               |                             | ALLF-433                 | EDSK-433       | ESFA-433                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                |                                                      | Advanced Learner Loans Facility                                 |                                                                 | 2                 | 2021            | 2020/21       |              | 8299         | 0            |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Feb              |
#    | ALLF2021                | 10017433 | 10017433 Co Ltd             |               |                             | ALLF-433                 | EDSK-433       | ESFA-433                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                |                                                      | Advanced Learner Loans Facility                                 |                                                                 | 3                 | 2021            | 2020/21       |              | 5617         | 0            |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Mar              |
#    | ALLF2021                | 10017433 | 10017433 Co Ltd             |               |                             | ALLF-433                 | EDSK-433       | ESFA-433                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                |                                                      | Advanced Learner Loans Facility                                 |                                                                 | 4                 | 2021            | 2021/22       |              | 5534         | 0            |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Apr              |
#    | ALLF2021                | 10017433 | 10017433 Co Ltd             |               |                             | ALLF-433                 | EDSK-433       | ESFA-433                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                |                                                      | Advanced Learner Loans Facility                                 |                                                                 | 5                 | 2021            | 2021/22       |              | 3611         | 0            |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | May              |
#    | ALLF2021                | 10017433 | 10017433 Co Ltd             |               |                             | ALLF-433                 | EDSK-433       | ESFA-433                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                |                                                      | Advanced Learner Loans Facility                                 |                                                                 | 6                 | 2021            | 2021/22       |              | 1520         | 0            |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jun              |
#    | ALLF2021                | 10017433 | 10017433 Co Ltd             |               |                             | ALLF-433                 | EDSK-433       | ESFA-433                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                |                                                      | Advanced Learner Loans Facility                                 |                                                                 | 7                 | 2021            | 2021/22       |              | 5682         | 0            |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jul              |
#    #
#    | ALLF2021                | 10017433 | 10017433 Co Ltd             |               |                             | ALLF-433                 | EDSK-433       | ESFA-433                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                | Loans Approved - Paid                                | Loans Approved - Paid                                           | Advanced Learner Loans Facility                                 | 8                 | 2020            | 2020/21       |              | 0            | 1166.76      |               |              | Yes                | 0.00           | 0.00             | 1166.76               | 0.00           | 1166.76         |             | No            |                   |        |                   |                          |                   | Aug              |
#    | ALLF2021                | 10017433 | 10017433 Co Ltd             |               |                             | ALLF-433                 | EDSK-433       | ESFA-433                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                | Loans Approved - Paid                                | Loans Approved - Paid                                           | Advanced Learner Loans Facility                                 | 9                 | 2020            | 2020/21       |              | 0            | 2440.72      |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Sep              |
#    | ALLF2021                | 10017433 | 10017433 Co Ltd             |               |                             | ALLF-433                 | EDSK-433       | ESFA-433                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                | Loans Approved - Paid                                | Loans Approved - Paid                                           | Advanced Learner Loans Facility                                 | 10                | 2020            | 2020/21       |              | 0            | 222.66       |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Oct              |
#    | ALLF2021                | 10017433 | 10017433 Co Ltd             |               |                             | ALLF-433                 | EDSK-433       | ESFA-433                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                | Loans Approved - Paid                                | Loans Approved - Paid                                           | Advanced Learner Loans Facility                                 | 11                | 2020            | 2020/21       |              | 0            | 1428.34      |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Nov              |
#    | ALLF2021                | 10017433 | 10017433 Co Ltd             |               |                             | ALLF-433                 | EDSK-433       | ESFA-433                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                | Loans Approved - Paid                                | Loans Approved - Paid                                           | Advanced Learner Loans Facility                                 | 12                | 2020            | 2020/21       |              | 0            | 2433.31      |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Dec              |
#    | ALLF2021                | 10017433 | 10017433 Co Ltd             |               |                             | ALLF-433                 | EDSK-433       | ESFA-433                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                | Loans Approved - Paid                                | Loans Approved - Paid                                           | Advanced Learner Loans Facility                                 | 1                 | 2021            | 2020/21       |              | 0            | 576.63       |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jan              |
#    | ALLF2021                | 10017433 | 10017433 Co Ltd             |               |                             | ALLF-433                 | EDSK-433       | ESFA-433                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                | Loans Approved - Paid                                | Loans Approved - Paid                                           | Advanced Learner Loans Facility                                 | 2                 | 2021            | 2020/21       |              | 0            | 172.3        |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Feb              |
#    | ALLF2021                | 10017433 | 10017433 Co Ltd             |               |                             | ALLF-433                 | EDSK-433       | ESFA-433                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                | Loans Approved - Paid                                | Loans Approved - Paid                                           | Advanced Learner Loans Facility                                 | 3                 | 2021            | 2020/21       |              | 0            | 1666.09      |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Mar              |
#    | ALLF2021                | 10017433 | 10017433 Co Ltd             |               |                             | ALLF-433                 | EDSK-433       | ESFA-433                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                | Loans Approved - Paid                                | Loans Approved - Paid                                           | Advanced Learner Loans Facility                                 | 4                 | 2021            | 2021/22       |              | 0            | 1709.94      |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Apr              |
#    | ALLF2021                | 10017433 | 10017433 Co Ltd             |               |                             | ALLF-433                 | EDSK-433       | ESFA-433                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                | Loans Approved - Paid                                | Loans Approved - Paid                                           | Advanced Learner Loans Facility                                 | 5                 | 2021            | 2021/22       |              | 0            | 118.18       |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | May              |
#    | ALLF2021                | 10017433 | 10017433 Co Ltd             |               |                             | ALLF-433                 | EDSK-433       | ESFA-433                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                | Loans Approved - Paid                                | Loans Approved - Paid                                           | Advanced Learner Loans Facility                                 | 6                 | 2021            | 2021/22       |              | 0            | 2060.38      |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jun              |
#    | ALLF2021                | 10017433 | 10017433 Co Ltd             |               |                             | ALLF-433                 | EDSK-433       | ESFA-433                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                | Loans Approved - Paid                                | Loans Approved - Paid                                           | Advanced Learner Loans Facility                                 | 7                 | 2021            | 2021/22       |              | 0            | 519.17       |               |              | Yes                | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jul              |
#    #
#	 | ALLF2021                | 10017433 | 10017433 Co Ltd             |               |                             | ALLF-433                 | EDSK-433       | ESFA-433                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                | Loans Approved - Scheduled                           | Loans Approved - Scheduled                                      | Advanced Learner Loans Facility                                 | 8                 | 2020            | 2020/21       |              | 0            | 561.78       |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Aug              |
#    | ALLF2021                | 10017433 | 10017433 Co Ltd             |               |                             | ALLF-433                 | EDSK-433       | ESFA-433                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                | Loans Approved - Scheduled                           | Loans Approved - Scheduled                                      | Advanced Learner Loans Facility                                 | 9                 | 2020            | 2020/21       |              | 0            | 378.77       |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Sep              |
#    | ALLF2021                | 10017433 | 10017433 Co Ltd             |               |                             | ALLF-433                 | EDSK-433       | ESFA-433                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                | Loans Approved - Scheduled                           | Loans Approved - Scheduled                                      | Advanced Learner Loans Facility                                 | 10                | 2020            | 2020/21       |              | 0            | 1343.57      |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Oct              |
#    | ALLF2021                | 10017433 | 10017433 Co Ltd             |               |                             | ALLF-433                 | EDSK-433       | ESFA-433                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                | Loans Approved - Scheduled                           | Loans Approved - Scheduled                                      | Advanced Learner Loans Facility                                 | 11                | 2020            | 2020/21       |              | 0            | 604.81       |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Nov              |
#    | ALLF2021                | 10017433 | 10017433 Co Ltd             |               |                             | ALLF-433                 | EDSK-433       | ESFA-433                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                | Loans Approved - Scheduled                           | Loans Approved - Scheduled                                      | Advanced Learner Loans Facility                                 | 12                | 2020            | 2020/21       |              | 0            | 2115.19      |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Dec              |
#    | ALLF2021                | 10017433 | 10017433 Co Ltd             |               |                             | ALLF-433                 | EDSK-433       | ESFA-433                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                | Loans Approved - Scheduled                           | Loans Approved - Scheduled                                      | Advanced Learner Loans Facility                                 | 1                 | 2021            | 2020/21       |              | 0            | 1459.32      |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jan              |
#    | ALLF2021                | 10017433 | 10017433 Co Ltd             |               |                             | ALLF-433                 | EDSK-433       | ESFA-433                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                | Loans Approved - Scheduled                           | Loans Approved - Scheduled                                      | Advanced Learner Loans Facility                                 | 2                 | 2021            | 2020/21       |              | 0            | 362.5        |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Feb              |
#    | ALLF2021                | 10017433 | 10017433 Co Ltd             |               |                             | ALLF-433                 | EDSK-433       | ESFA-433                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                | Loans Approved - Scheduled                           | Loans Approved - Scheduled                                      | Advanced Learner Loans Facility                                 | 3                 | 2021            | 2020/21       |              | 0            | 2067.56      |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Mar              |
#    | ALLF2021                | 10017433 | 10017433 Co Ltd             |               |                             | ALLF-433                 | EDSK-433       | ESFA-433                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                | Loans Approved - Scheduled                           | Loans Approved - Scheduled                                      | Advanced Learner Loans Facility                                 | 4                 | 2021            | 2021/22       |              | 0            | 1722.52      |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Apr              |
#    | ALLF2021                | 10017433 | 10017433 Co Ltd             |               |                             | ALLF-433                 | EDSK-433       | ESFA-433                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                | Loans Approved - Scheduled                           | Loans Approved - Scheduled                                      | Advanced Learner Loans Facility                                 | 5                 | 2021            | 2021/22       |              | 0            | 2124.44      |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | May              |
#    | ALLF2021                | 10017433 | 10017433 Co Ltd             |               |                             | ALLF-433                 | EDSK-433       | ESFA-433                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                | Loans Approved - Scheduled                           | Loans Approved - Scheduled                                      | Advanced Learner Loans Facility                                 | 6                 | 2021            | 2021/22       |              | 0            | 500.92       |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jun              |
#    | ALLF2021                | 10017433 | 10017433 Co Ltd             |               |                             | ALLF-433                 | EDSK-433       | ESFA-433                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                | Loans Approved - Scheduled                           | Loans Approved - Scheduled                                      | Advanced Learner Loans Facility                                 | 7                 | 2021            | 2021/22       |              | 0            | 1119.98      |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jul              |
#    #
#	 | ALLF2021                | 10017433 | 10017433 Co Ltd             |               |                             | ALLF-433                 | EDSK-433       | ESFA-433                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                | Loans Submitted                                      | Loans Submitted                                                 | Advanced Learner Loans Facility                                 | 8                 | 2020            | 2020/21       |              | 0            | 941.61       |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Aug              |
#    | ALLF2021                | 10017433 | 10017433 Co Ltd             |               |                             | ALLF-433                 | EDSK-433       | ESFA-433                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                | Loans Submitted                                      | Loans Submitted                                                 | Advanced Learner Loans Facility                                 | 9                 | 2020            | 2020/21       |              | 0            | 805.4        |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Sep              |
#    | ALLF2021                | 10017433 | 10017433 Co Ltd             |               |                             | ALLF-433                 | EDSK-433       | ESFA-433                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                | Loans Submitted                                      | Loans Submitted                                                 | Advanced Learner Loans Facility                                 | 10                | 2020            | 2020/21       |              | 0            | 358.65       |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Oct              |
#    | ALLF2021                | 10017433 | 10017433 Co Ltd             |               |                             | ALLF-433                 | EDSK-433       | ESFA-433                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                | Loans Submitted                                      | Loans Submitted                                                 | Advanced Learner Loans Facility                                 | 11                | 2020            | 2020/21       |              | 0            | 1533.86      |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Nov              |
#    | ALLF2021                | 10017433 | 10017433 Co Ltd             |               |                             | ALLF-433                 | EDSK-433       | ESFA-433                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                | Loans Submitted                                      | Loans Submitted                                                 | Advanced Learner Loans Facility                                 | 12                | 2020            | 2020/21       |              | 0            | 498.61       |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Dec              |
#    | ALLF2021                | 10017433 | 10017433 Co Ltd             |               |                             | ALLF-433                 | EDSK-433       | ESFA-433                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                | Loans Submitted                                      | Loans Submitted                                                 | Advanced Learner Loans Facility                                 | 1                 | 2021            | 2020/21       |              | 0            | 225.49       |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jan              |
#    | ALLF2021                | 10017433 | 10017433 Co Ltd             |               |                             | ALLF-433                 | EDSK-433       | ESFA-433                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                | Loans Submitted                                      | Loans Submitted                                                 | Advanced Learner Loans Facility                                 | 2                 | 2021            | 2020/21       |              | 0            | 1218.29      |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Feb              |
#    | ALLF2021                | 10017433 | 10017433 Co Ltd             |               |                             | ALLF-433                 | EDSK-433       | ESFA-433                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                | Loans Submitted                                      | Loans Submitted                                                 | Advanced Learner Loans Facility                                 | 3                 | 2021            | 2020/21       |              | 0            | 465.61       |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Mar              |
#    | ALLF2021                | 10017433 | 10017433 Co Ltd             |               |                             | ALLF-433                 | EDSK-433       | ESFA-433                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                | Loans Submitted                                      | Loans Submitted                                                 | Advanced Learner Loans Facility                                 | 4                 | 2021            | 2021/22       |              | 0            | 2107.44      |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Apr              |
#    | ALLF2021                | 10017433 | 10017433 Co Ltd             |               |                             | ALLF-433                 | EDSK-433       | ESFA-433                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                | Loans Submitted                                      | Loans Submitted                                                 | Advanced Learner Loans Facility                                 | 5                 | 2021            | 2021/22       |              | 0            | 299.68       |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | May              |
#    | ALLF2021                | 10017433 | 10017433 Co Ltd             |               |                             | ALLF-433                 | EDSK-433       | ESFA-433                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                | Loans Submitted                                      | Loans Submitted                                                 | Advanced Learner Loans Facility                                 | 6                 | 2021            | 2021/22       |              | 0            | 2182.9       |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jun              |
#    | ALLF2021                | 10017433 | 10017433 Co Ltd             |               |                             | ALLF-433                 | EDSK-433       | ESFA-433                | 01/08/2020                  | 31/07/2021                | 2                     | Approved       | Approved                | Loans Submitted                                      | Loans Submitted                                                 | Advanced Learner Loans Facility                                 | 7                 | 2021            | 2021/22       |              | 0            | 1691.44      |               |              | No                 | 0.00           | 0.00             | 0.00                  | 0.00           | 0.00            |             | No            |                   |        |                   |                          |                   | Jul              |


	# Tidy Up
	And   the override date is reset
	  
@AcceptanceTest @Withdrawn20230123
Scenario: A432 Bulk create eight 2021 EDSK(ALLF) contracts using all the Contract Types. Check document parts
    # 1/8
    Given there are no allocations marked as Under Termination for UKPRN '10039935' 
    And   there are no terminated or closed allocations for UKPRN '10039935' 
    And   there is no Contract, Task or Workflow data for UKPRN '10039935' 
    # 2/8
    Given there are no allocations marked as Under Termination for UKPRN '10039936' 
    And   there are no terminated or closed allocations for UKPRN '10039936' 
    And   there is no Contract, Task or Workflow data for UKPRN '10039936'
    # 3/8
    Given there are no allocations marked as Under Termination for UKPRN '10039956' 
    And   there are no terminated or closed allocations for UKPRN '10039956' 
    And   there is no Contract, Task or Workflow data for UKPRN '10039956'
    # 4/8
    Given there are no allocations marked as Under Termination for UKPRN '10039958' 
    And   there are no terminated or closed allocations for UKPRN '10039958' 
    And   there is no Contract, Task or Workflow data for UKPRN '10039958'
    # 5/8
    Given there are no allocations marked as Under Termination for UKPRN '10040011' 
    And   there are no terminated or closed allocations for UKPRN '10040011' 
    And   there is no Contract, Task or Workflow data for UKPRN '10040011'
    # 6/8
    Given there are no allocations marked as Under Termination for UKPRN '10040038' 
    And   there are no terminated or closed allocations for UKPRN '10040038' 
    And   there is no Contract, Task or Workflow data for UKPRN '10040038'
    # 7/8
    Given there are no allocations marked as Under Termination for UKPRN '10040042' 
    And   there are no terminated or closed allocations for UKPRN '10040042' 
    And   there is no Contract, Task or Workflow data for UKPRN '10040042'
    # 8/8
    Given there are no allocations marked as Under Termination for UKPRN '10040097' 
    And   there are no terminated or closed allocations for UKPRN '10040097' 
    And   there is no Contract, Task or Workflow data for UKPRN '10040097'

    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 



    # Set organisation and advisors 
    # 1/8
    Given there is no Organisation data for UKPRN '10039935' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10039935 Co Ltd' with UKPRN '10039935' and OrgId 'ORG0039935' and has 'FCS1 Test' as a manager 
    # 2/8
    Given there is no Organisation data for UKPRN '10039936' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10039936 Co Ltd' with UKPRN '10039936' and OrgId 'ORG0039936' and has 'FCS1 Test' as a manager 
    # 3/8
    Given there is no Organisation data for UKPRN '10039956' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10039956 Co Ltd' with UKPRN '10039956' and OrgId 'ORG0039956' and has 'FCS1 Test' as a manager 
    # 4/8
    Given there is no Organisation data for UKPRN '10039958' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10039958 Co Ltd' with UKPRN '10039958' and OrgId 'ORG0039958' and has 'FCS1 Test' as a manager 
    # 5/8
    Given there is no Organisation data for UKPRN '10040011' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10040011 Co Ltd' with UKPRN '10040011' and OrgId 'ORG0040011' and has 'FCS1 Test' as a manager 
    # 6/8
    Given there is no Organisation data for UKPRN '10040038' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10040038 Co Ltd' with UKPRN '10040038' and OrgId 'ORG0040038' and has 'FCS1 Test' as a manager 
    # 7/8
    Given there is no Organisation data for UKPRN '10040042' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10040042 Co Ltd' with UKPRN '10040042' and OrgId 'ORG0040042' and has 'FCS1 Test' as a manager 
    # 8/8
    Given there is no Organisation data for UKPRN '10040097' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10040097 Co Ltd' with UKPRN '10040097' and OrgId 'ORG0040097' and has 'FCS1 Test' as a manager 


    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10039935 | 139935 | 10039935 Co Ltd | 0              | Provider Under Change | Yes           | AA039935      | ?             | 11 Exchange Street     | Norwich                | Norfolk                | ?                      | ?                      | ?                      | NR2 4AU   |
    | 10039936 | 139936 | 10039936 Co Ltd | 0              | Provider Under Change | Yes           | AA039936      | ?             | 12 Exchange Street     | Norwich                | Norfolk                | ?                      | ?                      | ?                      | NR2 4AU   |
    | 10039956 | 139956 | 10039956 Co Ltd | 0              | Provider Under Change | Yes           | AA039956      | ?             | 13 Exchange Street     | Norwich                | Norfolk                | ?                      | ?                      | ?                      | NR2 4AU   |
    | 10039958 | 139958 | 10039958 Co Ltd | 0              | Provider Under Change | Yes           | AA039958      | ?             | 14 Exchange Street     | Norwich                | Norfolk                | ?                      | ?                      | ?                      | NR2 4AU   |
    | 10040011 | 140011 | 10040011 Co Ltd | 0              | Provider Under Change | Yes           | AA040011      | ?             | 15 Exchange Street     | Norwich                | Norfolk                | ?                      | ?                      | ?                      | NR2 4AU   |
    | 10040038 | 140038 | 10040038 Co Ltd | 0              | Provider Under Change | Yes           | AA040038      | ?             | 16 Exchange Street     | Norwich                | Norfolk                | ?                      | ?                      | ?                      | NR2 4AU   |
    | 10040042 | 140042 | 10040042 Co Ltd | 0              | Provider Under Change | Yes           | AA040042      | ?             | 17 Exchange Street     | Norwich                | Norfolk                | ?                      | ?                      | ?                      | NR2 4AU   |
    | 10040097 | 140097 | 10040097 Co Ltd | 0              | Provider Under Change | Yes           | AA040097      | ?             | 18 Exchange Street     | Norwich                | Norfolk                | ?                      | ?                      | ?                      | NR2 4AU   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10039935 |
	| 10039936 |
	| 10039956 |
	| 10039958 |
	| 10040011 |
	| 10040038 |
	| 10040042 |
	| 10040097 |




    # Change the date
    Given the override date is '23/07/2020'

    # Bulk file to create 8 new ALLF contracts
    And   there are no files prefixed '10039935' in the Sharepoint 'EDSK-2021-Input-Appendices' folder
	And   there are no files prefixed '10039936' in the Sharepoint 'EDSK-2021-Input-Appendices' folder
	And   there are no files prefixed '10039956' in the Sharepoint 'EDSK-2021-Input-Appendices' folder
	And   there are no files prefixed '10039958' in the Sharepoint 'EDSK-2021-Input-Appendices' folder
	And   there are no files prefixed '10040011' in the Sharepoint 'EDSK-2021-Input-Appendices' folder
	And   there are no files prefixed '10040038' in the Sharepoint 'EDSK-2021-Input-Appendices' folder
	And   there are no files prefixed '10040042' in the Sharepoint 'EDSK-2021-Input-Appendices' folder
	And   there are no files prefixed '10040097' in the Sharepoint 'EDSK-2021-Input-Appendices' folder

    And   there are no files prefixed 'EDSK AY 2021 24032020191129 v3_A432' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2021 24032020191129 v3_A432' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2021 24032020191129 v3_A432' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2021 24032020191129 v3_A432' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2021 24032020191129 v3_A432.xlsx' exists in the Datafiles folder and UKPRN '10039935' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report




    # Retrieve parameters for 1/8 - Conditions of Funding (Grant) (Employer) Param=Employer
    Then  I retrieve the latest contract details from CRM for provider '10039935' for FundingType 'EDSK' and period '2021'

    # Check the contents of the Appendices
    And   the file named '10039935_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2021-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2020/21
    Organisation Name: 10039935 Co Ltd UKPRN: 10039935

    Agreement Type Conditions of Funding (Grant) (Employers)

	SCHEDULE 1: SPECIFICATION & MONITORING
	Summary of Service

    SCHEDULE 2: PAYMENT
    ADVANCED LEARNER LOANS PAYMENT (PAY ON PROFILE)

    Funding Agreement – Advanced Learner Loans Facility
    Provider: 10039935 Co Ltd UKPRN: 10039935

    SCHEDULE 7: SECURITY & DEPARTMENT POLICIES
	"""



    # Retrieve parameters for 2/8 - Conditions of Funding (Grant) (Trust) Param=Provider
    And   I retrieve the latest contract details from CRM for provider '10039936' for FundingType 'EDSK' and period '2021'

    # Check the contents of the Appendices
    And   the file named '10039936_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2021-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2020/21
    Organisation Name: 10039936 Co Ltd UKPRN: 10039936

    Agreement Type Conditions of Funding (Grant) (Trusts)
    
	SCHEDULE 1: SPECIFICATION & MONITORING
	Summary of Service

    SCHEDULE 2: PAYMENT
    ADVANCED LEARNER LOANS PAYMENT (PAY ON PROFILE)

    Funding Agreement – Advanced Learner Loans Facility
    Provider: 10039936 Co Ltd UKPRN: 10039936

    SCHEDULE 7: SECURITY & DEPARTMENT POLICIES
	"""



    # Retrieve parameters for 3/8 - Conditions of Funding (Grant) (College) Param=College
    And   I retrieve the latest contract details from CRM for provider '10039956' for FundingType 'EDSK' and period '2021'

    # Check the contents of the Appendices
    And   the file named '10039956_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2021-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2020/21
    Organisation Name: 10039956 Co Ltd UKPRN: 10039956

    Agreement Type Conditions of Funding (Grant) (Colleges)
    
	SCHEDULE 1: SPECIFICATION & MONITORING
    Summary of Service

    SCHEDULE 2: PAYMENT
    ADVANCED LEARNER LOANS PAYMENT (PAY ON PROFILE)

    Funding Agreement – Advanced Learner Loans Facility
    Provider: 10039956 Co Ltd UKPRN: 10039956

    SCHEDULE 9: COLLEGE GOVERNANCE
	"""



    # Retrieve parameters for 4/8 - Conditions of Funding (Grant) (HEI) Param=Provider
    And   I retrieve the latest contract details from CRM for provider '10039958' for FundingType 'EDSK' and period '2021'

    # Check the contents of the Appendices
    And   the file named '10039958_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2021-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2020/21
    Organisation Name: 10039958 Co Ltd UKPRN: 10039958

    Agreement Type Conditions of Funding (Grant) (HEI)

    SCHEDULE 1: SPECIFICATION & MONITORING
    Summary of Service

    SCHEDULE 2: PAYMENT
    ADVANCED LEARNER LOANS PAYMENT (PAY ON PROFILE)

    Funding Agreement – Advanced Learner Loans Facility
    Provider: 10039958 Co Ltd UKPRN: 10039958

    SCHEDULE 7: SECURITY & DEPARTMENT POLICIES
	"""



    # Retrieve parameters for 5/8 - Conditions of Funding (Grant) (LA) Param=Provider
    And   I retrieve the latest contract details from CRM for provider '10040011' for FundingType 'EDSK' and period '2021'

    # Check the contents of the Appendices
    And   the file named '10040011_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2021-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2020/21
    Organisation Name: 10040011 Co Ltd UKPRN: 10040011

    Agreement Type Conditions of Funding (Grant) (Local Authorities)

    SCHEDULE 1: SPECIFICATION & MONITORING
    Summary of Service

    SCHEDULE 2: PAYMENT
    ADVANCED LEARNER LOANS PAYMENT (PAY ON PROFILE)

    Funding Agreement – Advanced Learner Loans Facility
    Provider: 10040011 Co Ltd UKPRN: 10040011

    SCHEDULE 7: SECURITY & DEPARTMENT POLICIES
	"""



#    # Retrieve parameters for 6/8 - Conditions of Funding (Grant) (NMSS) Param=Provider
#    And   I retrieve the latest contract details from CRM for provider '10040038' for FundingType 'EDSK' and period '2021'
#
#    # Check the contents of the Appendices
#    And   the file named '10040038_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2021-Input-Appendices' contains the following lines in order
#    """
#    SUMMARY OF FUNDING 2020/21
#    Organisation Name: 10040038 Co Ltd UKPRN: 10040038
#
#    EDSK2021_S1_LOANS_COFG_2020-08-01.docx
#    EDSK2021_S2_LOANS_COFG_2020-08-01.docx
#
#    Funding Agreement – Advanced Learner Loans Facility
#    Provider: 10040038 Co Ltd UKPRN: 10040038
#	 """



#    # Retrieve parameters for 7/8 - Conditions of Funding (Grant) (SPI) Param=Provider
#    And   I retrieve the latest contract details from CRM for provider '10040042' for FundingType 'EDSK' and period '2021'
#
#    # Check the contents of the Appendices
#    And   the file named '10040042_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2021-Input-Appendices' contains the following lines in order
#    """
#    SUMMARY OF FUNDING 2020/21
#    Organisation Name: 10040042 Co Ltd UKPRN: 10040042
#
#    EDSK2021_S1_LOANS_COFG_2020-08-01.docx
#    EDSK2021_S2_LOANS_COFG_2020-08-01.docx
#
#    Funding Agreement – Advanced Learner Loans Facility
#    Provider: 10040042 Co Ltd UKPRN: 10040042
#	 """



    # Retrieve parameters for 8/8 - Contract for Services (ITP) Param=Contractor
    And   I retrieve the latest contract details from CRM for provider '10040097' for FundingType 'EDSK' and period '2021'

    # Check the contents of the Appendices
    And   the file named '10040097_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2021-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2020/21
    Organisation Name: 10040097 Co Ltd UKPRN: 10040097

    Agreement Type Contract for Services

    SCHEDULE 1: SPECIFICATION & MONITORING
    Summary of Service

    SCHEDULE 2: PAYMENT
    ADVANCED LEARNER LOANS PAYMENT (PAY ON ACTUALS)

    Funding Agreement – Advanced Learner Loans Facility
    Provider: 10040097 Co Ltd UKPRN: 10040097

    SCHEDULE 3: CHANGE CONTROL PROCEDURE 
	"""


    # Tidy Up
	And   the override date is reset
	   
