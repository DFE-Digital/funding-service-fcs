Feature: EDSK2021TemplateVersioning 28484

@AcceptanceTest @Withdrawn20240103
Scenario: A093 Create and approve a 2021 EDSK contract with an ALLF allocation. Execute several non-financial updates with various document and template timestamps. Check document-parts produced
    Given there are no allocations marked as Under Termination for UKPRN '10017093' 
    And   there are no terminated or closed allocations for UKPRN '10017093' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017093' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | ALLF2021          |




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017093' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017093 Co Ltd' with UKPRN '10017093' and OrgId 'ORG0017093' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017093' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017093 | 117093 | 10017093 Co Ltd | 0              | Provider Under Change | Yes           | AA017093      | ?             | 14 Woolton Lodge       | Woolton Hill           | ?                      | ?                      | Newbury                | Berkshire              | RG20 9SU  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017093 |




    # Change the date
    Given the override date is '12/04/2020'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription    | ContractType                              | Period | CRMIntent    | OrgId      |
    | 10017093 | 10017093 Co Ltd      | ESFA-093             | EDSK-093       | 1                     | 01/08/2020        | 31/07/2021      | 20250.00      |                        | Conditions of Funding (Grant) (Employer)  | 2021   | New          | ORG0017093 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName        | UoPCode    | AllocationDescription    | CRMIntent    | DeliveryOrg |
    | 10017093 | EDSK-093       | ALLF-093      | ALLF              | ALLF2021                | AY                      | 01/08/2020          | 31/07/2021        | 20250.00        |                |            |                          | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription              | CRMIntent    | DeliveryOrg |
    | 10017093 | EDSK-093       | ALLF-093      | 5               | 0                     | 20250.00  | 12540.00  | 7710.00   | 808.00   | 1797.00  | 2533.00  | 1307.00  | 1283.00  | 374.00   | 3101.00  | 1337.00  | 2928.00  | 121.00   | 1140.00  | 3521.00  | Advanced Learner Loans Facility     | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-093'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-093' and actual ContractNumber 'EDSK-093'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-093' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017093 | EDSK-093           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017093 | ESFA-093           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '48' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '48' deliverable period rows in CRM linked to the latest version of contract 'EDSK-093'

	# Set v1 document creation timestamp (J104)
	Given the following document creation details exist in the ContractManagement.CreatedContract table
	| ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
	| EDSK-093       | 1                     | 0                        | 2020-04-12 09:12:35.000 |




    # Test 1 - Issue a NON-FINANCIAL(Variation) amendment after the S1 template has changed
	
	# Set document template timestamps for Contract Type = Conditions of Funding (Grant) (Employer)

	# Associate a timestamp with a document template (DocumentsDomain.UploadedDocumentTemplate) (J107)
	Given the following document templates have Upload timestamps as indicated
    | DocumentTemplateName                            | UploadTimestamp         |
    | EDSK2021_TAC_COFG_EMPLOYER_2020-08-01.docx      | 2020-03-12 18:12:35.000 |
    | EDSK2021_S1_LOANS_COFG.docx                     | 2020-04-12 20:05:17.000 |
    | EDSK2021_S2_LOANS_COFG_2020-08-01.docx          | 2020-03-12 18:12:35.000 |
    | EDSK2021_S3ON_COFG_EMPLOYER_2020-08-01.docx     | 2020-03-12 18:12:35.000 |

    # Change the date
    And   the override date is '21/08/2020 08:33'

    # Issue a non-financial VARIATION amendment on v1 to create v2
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'EDSK-093' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM (A check that gives the doc time to arrive in Sharepoint)
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017093 | EDSK-093           | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017093 | EDSK-093           | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017093 | ESFA-093           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Wait for row to arrive then update the CreatedDate (J106)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details are present in the ContractManagement.CreatedContract table 
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
	| EDSK-093       | 2                     | 0                        | 2020-08-21 08:33:00.000 |


	# Check the contents of the Appendices

	# There should be a Summary of Funding and a Schedule 1 document only
    Then  the file named '10017093_EDSK-093_v2.pdf' in Sharepoint location 'EDSK-2021-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2020/21
    Organisation Name: 10017093 Co Ltd UKPRN: 10017093

	Service Commencement and Duration
    5. Advanced Learner Loans Service Start Date: 1 June 2020.
    6. Advanced Learner Loans Expiry Date: 31 October 2021.
	Loans Bursary Reconciliation
	13.Where the Employer’s actual delivery in the final claim, as against the
    contract Allocation, will result or has already resulted in an overpayment by
    the Department to the Employer, the Department will deduct the amount
    owed over the remainder of the Financial Year as defined in Clause 26.1.5
    and may offset the overpayment against other payments being made to the
    Employer.  Where the overpayment cannot be recovered from future
    payments within the Financial Year, the Department will invoice the
    Employer for the remaining debt and the Employer will pay the invoice within
    30 days.
	"""

    # There should not be a Terms & Conditions document for CoFG(Employer)
    And   the pdf file does not contain the following text
    """
    EDSK Version 3 (September 2020) Page 1
    """

    # There should not be a Schedule 2 document for Loans CoFG
	And   the pdf file does not contain the following text
    """
    EDSK Schedule 2 – Advanced Learner Loans Version 1 (May 2020) – Page 1
    """

    # There should not be a Funding Agreement document for Loans
	And   the pdf file does not contain the following text
    """
    Funding Agreement – Advanced Learner Loans Facility
    """

    # There should not be a Schedule 3ON document for CoFG(Employer)
	And   the pdf file does not contain the following text
    """
	EDSK Schedule 3 Version 2 (July 2020) – Page 1
    """
  

    # Publish and approve

    # Change the date
    Given the override date is '23/08/2020'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-093'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-093' and actual ContractNumber 'EDSK-093'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-093' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017093 | EDSK-093           | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017093 | EDSK-093           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017093 | ESFA-093           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |





    # Test 2 - Issue a NON-FINANCIAL(Variation) amendment after both S2 and S3 templates change
	
	# Set document template timestamps for Contract Type = Conditions of Funding (Grant) (Employer)

	# Associate a timestamp with a document template (DocumentsDomain.UploadedDocumentTemplate) (J107)
	Given the following document templates have Upload timestamps as indicated
    | DocumentTemplateName                            | UploadTimestamp         |
    | EDSK2021_TAC_COFG_EMPLOYER_2020-08-01.docx      | 2020-03-12 18:12:35.000 |
    | EDSK2021_S1_LOANS_COFG.docx                     | 2020-04-12 20:05:17.000 |
    | EDSK2021_S2_LOANS_COFG_2020-08-01.docx          | 2020-09-03 09:15:10.000 |
    | EDSK2021_S3ON_COFG_EMPLOYER_2020-08-01.docx     | 2020-09-03 09:22:04.000 |

    # Change the date
    And   the override date is '03/09/2020 12:07'

    # Issue a non-financial VARIATION amendment on v2 to create v3
    When  a request is raised by advisor 'FCS2 Test' against version '2' subversion '0' of contract 'EDSK-093' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM (A check that gives the doc time to arrive in Sharepoint)
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017093 | EDSK-093           | 3                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017093 | EDSK-093           | 2                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017093 | EDSK-093           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017093 | ESFA-093           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Wait for row to arrive then update the CreatedDate (J106)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details are present in the ContractManagement.CreatedContract table 
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
	| EDSK-093       | 3                     | 0                        | 2020-09-03 12:07:00.000 |


	# Check the contents of the Appendices

	# There should be a Summary of Funding, a Schedule 2 and a Schedule 3 only
    Then  the file named '10017093_EDSK-093_v3.pdf' in Sharepoint location 'EDSK-2021-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2020/21
    Organisation Name: 10017093 Co Ltd UKPRN: 10017093

	SCHEDULE 2: PAYMENT
    ADVANCED LEARNER LOANS PAYMENT (PAY ON PROFILE)
    Advanced Learner Loans Bursary 
    3. The Department will pay the Employer the Funding set out in the Funding 
	Agreement of this Schedule on the 14 Working Day of each month. 
    EDSK Schedule 2 – Advanced Learner Loans Version 1 (May 2020) – Page 2

    SCHEDULE 3: NOT USED 
    SCHEDULE 4: NOT USED
    SCHEDULE 5: NOT USED
    SCHEDULE 6: GDPR
    SCHEDULE 7: SECURITY & DEPARTMENT POLICIES
	7.2 To facilitate the transfer of knowledge from the Employer to the
    Department and/or its Successor Employer, the Employer will provide,
    upon request, a detailed written explanation of the procedures and
    operations used to provide the Services, the change management
    process and other standards and procedures to the operations personnel
    of the Department and/or the Successor Employer.
	"""

    # There should not be a Terms & Conditions document for CoFG(Employer)
    And   the pdf file does not contain the following text
    """
    EDSK Version 3 (September 2020) Page 1
    """

    # There should not be a Schedule 1 Loans document for CoFG
	And   the pdf file does not contain the following text
    """
    EDSK Schedule 2 – Advanced Learner Loans Version 2 (July 2020) – Page 1
    """

    # There should not be a Funding Agreement document
	And   the pdf file does not contain the following text
    """
    Funding Agreement – Advanced Learner Loans Facility
    """
  

    # Publish and approve

    # Change the date
    Given the override date is '05/09/2020'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-093'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '3' actual MasterContractNumber 'ESFA-093' and actual ContractNumber 'EDSK-093'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-093' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017093 | EDSK-093           | 3                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017093 | EDSK-093           | 2                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017093 | EDSK-093           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017093 | ESFA-093           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |




    # Test 3 - Issue a NON-FINANCIAL(Variation) amendment after all four templates change
	
	# Set document template timestamps for Contract Type = Conditions of Funding (Grant) (Employer)

	# Associate a timestamp with a document template (DocumentsDomain.UploadedDocumentTemplate) (J107)
	Given the following document templates have Upload timestamps as indicated
    | DocumentTemplateName                            | UploadTimestamp         |
    | EDSK2021_TAC_COFG_EMPLOYER_2020-08-01.docx      | 2020-10-01 08:51:12.000 |
    | EDSK2021_S1_LOANS_COFG.docx                     | 2020-10-01 08:51:12.000 |
    | EDSK2021_S2_LOANS_COFG_2020-08-01.docx          | 2020-10-01 08:51:12.000 |
    | EDSK2021_S3ON_COFG_EMPLOYER_2020-08-01.docx     | 2020-10-01 08:51:12.000 |

    # Change the date
    And   the override date is '01/10/2020 15:34'

    # Issue a non-financial VARIATION amendment on v3 to create v4
    When  a request is raised by advisor 'FCS2 Test' against version '3' subversion '0' of contract 'EDSK-093' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM (A check that gives the doc time to arrive in Sharepoint)
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017093 | EDSK-093           | 4                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017093 | EDSK-093           | 3                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017093 | EDSK-093           | 2                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017093 | EDSK-093           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017093 | ESFA-093           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Wait for row to arrive then update the CreatedDate (J106)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details are present in the ContractManagement.CreatedContract table 
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
	| EDSK-093       | 4                     | 0                        | 2020-10-01 15:34:00.000 |


	# Check the contents of the Appendices

	# There should be a Summary of Funding, Terms & Conditions, Schedule 1, Schedule 2 and Schedule 3 docs
    Then  the file named '10017093_EDSK-093_v4.pdf' in Sharepoint location 'EDSK-2021-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2020/21
    Organisation Name: 10017093 Co Ltd UKPRN: 10017093

	Agreement Type Conditions of Funding (Grant) (Employers)
    Funding Period 1 August 2020 to 31 July 2021
    the Secretary of State for Education (acting through
    Between
    the Education and Skills Funding Agency)
    And 10017093 Co Ltd
    Funding for Advanced Learner Loans
    Master Agreement Number ESFA-093
    This Agreement is made on the date the Agreement is digitally signed by the
    Employer on the Manage Your Education & Skills Funding Service between:
    10017093 Co Ltd THE SECRETARY OF STATE FOR
    14 Woolton Lodge EDUCATION ACTING THROUGH
    Woolton Hill THE EDUCATION AND SKILLS
    Newbury FUNDING AGENCY, AN
    Berkshire EXECUTIVE AGENCY OF THE
    RG20 9SU DEPARTMENT OF EDUCATION
    AND CHEYLESMORE HOUSE
    QUINTON ROAD
    Company No: AA017093 COVENTRY
    CV1 2WT
    Hereinafter called Hereinafter called
    the Employer the Department

	SCHEDULE 1: SPECIFICATION & MONITORING
	Summary of Service
	1. Advanced Learner Loans provide a source of fees and support to help
    people aged 19 and over undertake general and technical qualifications at
    levels 3, 4, 5 and 6 that will be provided by the Employer.
	Service Commencement and Duration
    5. Advanced Learner Loans Service Start Date: 1 June 2020.
    6. Advanced Learner Loans Expiry Date: 31 October 2021.

	SCHEDULE 2: PAYMENT
    ADVANCED LEARNER LOANS PAYMENT (PAY ON PROFILE)
    Advanced Learner Loans Bursary

    SCHEDULE 3: NOT USED 
    SCHEDULE 4: NOT USED
    SCHEDULE 5: NOT USED
    SCHEDULE 6: GDPR
    SCHEDULE 7: SECURITY & DEPARTMENT POLICIES
	7.2 To facilitate the transfer of knowledge from the Employer to the
    Department and/or its Successor Employer, the Employer will provide,
    upon request, a detailed written explanation of the procedures and
    operations used to provide the Services, the change management
    process and other standards and procedures to the operations personnel
    of the Department and/or the Successor Employer.
	"""

    # There should not be a Funding Agreement document
	And   the pdf file does not contain the following text
    """
    Funding Agreement – Advanced Learner Loans Facility
    """
  

    # Publish and approve

    # Change the date
    Given the override date is '02/10/2020'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-093'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '4' actual MasterContractNumber 'ESFA-093' and actual ContractNumber 'EDSK-093'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-093' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017093 | EDSK-093           | 4                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017093 | EDSK-093           | 3                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017093 | EDSK-093           | 2                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017093 | EDSK-093           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017093 | ESFA-093           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |




    # Test 4 - Issue a NON-FINANCIAL(Variation) amendment where no templates have changed
	
	# Set document template timestamps for Contract Type = Conditions of Funding (Grant) (Employer)

	# Associate a timestamp with a document template (DocumentsDomain.UploadedDocumentTemplate) (J107)
	Given the following document templates have Upload timestamps as indicated
    | DocumentTemplateName                            | UploadTimestamp         |
    | EDSK2021_TAC_COFG_EMPLOYER_2020-08-01.docx      | 2020-10-01 08:51:12.000 |
    | EDSK2021_S1_LOANS_COFG.docx                     | 2020-10-01 08:51:12.000 |
    | EDSK2021_S2_LOANS_COFG_2020-08-01.docx          | 2020-10-01 08:51:12.000 |
    | EDSK2021_S3ON_COFG_EMPLOYER_2020-08-01.docx     | 2020-10-01 08:51:12.000 |

    # Change the date
    And   the override date is '23/10/2020 09:00'

    # Issue a non-financial VARIATION amendment on v4 to create v5
    When  a request is raised by advisor 'FCS2 Test' against version '4' subversion '0' of contract 'EDSK-093' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM (A check that gives the doc time to arrive in Sharepoint)
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017093 | EDSK-093           | 5                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017093 | EDSK-093           | 4                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017093 | EDSK-093           | 3                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017093 | EDSK-093           | 2                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017093 | EDSK-093           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017093 | ESFA-093           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Wait for row to arrive then update the CreatedDate (J106)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details are present in the ContractManagement.CreatedContract table 
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
	| EDSK-093       | 5                     | 0                        | 2020-10-23 09:00:00.000 |


	# Check the contents of the Appendices

	# There should only be a Summary of Funding doc
    Then  the file named '10017093_EDSK-093_v5.pdf' in Sharepoint location 'EDSK-2021-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2020/21
    Organisation Name: 10017093 Co Ltd UKPRN: 10017093
	"""

    # There should not be a Terms & Conditions document for Loans CofG(Employer)
    And   the pdf file does not contain the following text
    """
    EDSK Version 3 (September 2020) Page 1
    """

    # There should not be a Schedule 1 Loans document for CoFG
	And   the pdf file does not contain the following text
    """
    EDSK Schedule 1 – Advanced Learner Loans Version 2 (July 2020) – Page 1
    """

    # There should not be a Schedule 2 Loans document for CofG
	And   the pdf file does not contain the following text
    """
    EDSK Schedule 2 – Advanced Learner Loans Version 2 (July 2020) – Page 1
    """

    # There should not be a Funding Agreement document
	And   the pdf file does not contain the following text
    """
    Funding Agreement – Advanced Learner Loans Facility
    """

    # There should not be a Schedule 3ON document for CoFG(Employer)
	And   the pdf file does not contain the following text
    """
    EDSK Schedule 3 Version 2 (July 2020) – Page 1
    """
  

    # Publish and approve

    # Change the date
    Given the override date is '25/10/2020'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-093'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '5' actual MasterContractNumber 'ESFA-093' and actual ContractNumber 'EDSK-093'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-093' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017093 | EDSK-093           | 5                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017093 | EDSK-093           | 4                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017093 | EDSK-093           | 3                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017093 | EDSK-093           | 2                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017093 | EDSK-093           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017093 | ESFA-093           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |



 
    # Test 5 - Issue a NON-FINANCIAL(Notification) amendment where all templates have changed
	
	# Set document template timestamps for Contract Type = Conditions of Funding (Grant) (Employer)

	# Associate a timestamp with a document template (DocumentsDomain.UploadedDocumentTemplate) (J107)
	Given the following document templates have Upload timestamps as indicated
    | DocumentTemplateName                            | UploadTimestamp         |
    | EDSK2021_TAC_COFG_EMPLOYER_2020-08-01.docx      | 2020-11-01 08:51:12.000 |
    | EDSK2021_S1_LOANS_COFG.docx                     | 2020-11-01 08:51:12.000 |
    | EDSK2021_S2_LOANS_COFG_2020-08-01.docx          | 2020-11-01 08:51:12.000 |
    | EDSK2021_S3ON_COFG_EMPLOYER_2020-08-01.docx     | 2020-11-01 08:51:12.000 |

    # Change the date
    And   the override date is '04/11/2020 12:45'

    # Issue a non-financial NOTIFICATION amendment on v5 to create v6
    When  a request is raised by advisor 'FCS2 Test' against version '5' subversion '0' of contract 'EDSK-093' for a non-financial NOTIFICATION contract amendment

    # Check the CONTRACT version, status and dates in CRM (A check that gives the doc time to arrive in Sharepoint)
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017093 | EDSK-093           | 6                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2020        | 31/07/2021      | Notification  |
    | 10017093 | EDSK-093           | 5                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017093 | EDSK-093           | 4                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017093 | EDSK-093           | 3                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017093 | EDSK-093           | 2                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017093 | EDSK-093           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017093 | ESFA-093           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Wait for row to arrive then update the CreatedDate (J106)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details are present in the ContractManagement.CreatedContract table 
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
	| EDSK-093       | 6                     | 0                        | 2020-11-04 12:45:00.000 |


	# Check the contents of the Appendices

    # There should only be a Summary of Funding doc - even though all the templates have changed since the last contract was created
    Then  the file named '10017093_EDSK-093_v6.pdf' in Sharepoint location 'EDSK-2021-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2020/21
    Organisation Name: 10017093 Co Ltd UKPRN: 10017093
	"""

    # There should not be a Terms & Conditions document for Loans for CoFG(Employer)
    And   the pdf file does not contain the following text
    """
    EDSK Version 3 (September 2020) Page 1
    """

    # There should not be a Schedule 1 document for Loans for CoFG(Employer)
	And   the pdf file does not contain the following text
    """
    EDSK Schedule 1 – Advanced Learner Loans Version 2 (July 2020) – Page 1
    """

    # There should not be a Schedule 2 document for Loans for CoFG(Employer)
	And   the pdf file does not contain the following text
    """
    EDSK Schedule 2 – Advanced Learner Loans Version 1 (May 2020) – Page 1
    """

    # There should not be a Funding Agreement document
	And   the pdf file does not contain the following text
    """
    Funding Agreement – Advanced Learner Loans Facility
    """

    # There should not be a Schedule 3ON document for Loans for CoFG(Employer)
	And   the pdf file does not contain the following text
    """
    EDSK Schedule 3 Version 2 (July 2020) – Page 1
    """
  

    # Publish and approve

    # Change the date
    Given the override date is '05/11/2020'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-093'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '6' actual MasterContractNumber 'ESFA-093' and actual ContractNumber 'EDSK-093'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-093' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017093 | EDSK-093           | 6                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | Notification  |
    | 10017093 | EDSK-093           | 5                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017093 | EDSK-093           | 4                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017093 | EDSK-093           | 3                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017093 | EDSK-093           | 2                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017093 | EDSK-093           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017093 | ESFA-093           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

 
    # Tidy Up
    And   the override date is reset

@AcceptanceTest @Complete
Scenario: A094 Create and approve a 2021 EDSK contract with an ALLF allocation. Execute several bulk updates with various document and template timestamps. Check document-parts produced
    Given there are no allocations marked as Under Termination for UKPRN '10017094' 
    And   there are no terminated or closed allocations for UKPRN '10017094' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017094' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | ALLF2021          |




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017094' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017094 Co Ltd' with UKPRN '10017094' and OrgId 'ORG0017094' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017094' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017094 | 117094 | 10017094 Co Ltd | 0              | Provider Under Change | Yes           | AA017094      | ?             | 22 Woolton Lodge       | Woolton Hill           | ?                      | ?                      | Newbury                | Berkshire              | RG20 9SU  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017094 |




    # Change the date
    Given the override date is '01/04/2020'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription    | ContractType                           | Period | CRMIntent    | OrgId      |
    | 10017094 | 10017094 Co Ltd      | ESFA-094             | EDSK-094       | 1                     | 01/08/2020        | 31/07/2021      | 20250.00      |                        | Conditions of Funding (Grant) (Trust)  | 2021   | New          | ORG0017094 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName        | UoPCode    | AllocationDescription    | CRMIntent    | DeliveryOrg |
    | 10017094 | EDSK-094       | ALLF-094      | ALLF              | ALLF2021                | AY                      | 01/08/2020          | 31/07/2021        | 20250.00        |                |            |                          | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription              | CRMIntent    | DeliveryOrg |
    | 10017094 | EDSK-094       | ALLF-094      | 5               | 0                     | 20250.00  | 12540.00  | 7710.00   | 808.00   | 1797.00  | 2533.00  | 1307.00  | 1283.00  | 374.00   | 3101.00  | 1337.00  | 2928.00  | 121.00   | 1140.00  | 3521.00  | Advanced Learner Loans Facility     | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-094'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-094' and actual ContractNumber 'EDSK-094'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-094' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017094 | EDSK-094           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017094 | ESFA-094           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '48' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '48' deliverable period rows in CRM linked to the latest version of contract 'EDSK-094'

    # Insert row with following details (J104)
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-094       | 1                     | 0                        | 2020-04-01 09:00:00.000 |




    # Test 1 - Bulk amend after the T&C has changed

    # Change the date
    Given the override date is '09/04/2020 15:33'

    # Set document template timestamps for Contract Type = Conditions of Funding (Grant) (Trust)

    # Associate a timestamp with a document template (DocumentsDomain.UploadedDocumentTemplate) (J107)
    Given the following document templates have Upload timestamps as indicated
    | DocumentTemplateName                            | UploadTimestamp         |
    | EDSK2021_TAC_COFG_TRUST_2020-08-01.docx         | 2020-04-08 13:21:34.000 |
    | EDSK2021_S1_LOANS_COFG.docx                     | 2020-03-17 09:00:00.000 |
    | EDSK2021_S2_LOANS_COFG_2020-08-01.docx          | 2020-03-17 09:00:00.000 |
    | EDSK2021_S3ON_COFG_LA_TRUST_HEI_2020-08-01.docx | 2020-03-17 09:00:00.000 |

    # Bulk file (This does not change the financials)
    And   there are no files prefixed '10017094' in the Sharepoint 'EDSK-2021-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2021 26032020085508 v3_A094_1' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2021 26032020085508 v3_A094_1' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2021 26032020085508 v3_A094_1' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2021 26032020085508 v3_A094_1' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2021 26032020085508 v3_A094_1.xlsx' exists in the Datafiles folder and UKPRN '10017094' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Check the CONTRACT version, status and dates in CRM (Giving doc time to arrive in Sharepoint)
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017094 | EDSK-094           | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017094 | EDSK-094           | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017094 | ESFA-094           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Wait for row to arrive then update the CreatedDate (J106)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details are present in the ContractManagement.CreatedContract table 
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
	| EDSK-094       | 2                     | 0                        | 2020-04-09 15:33:00.000 |


	# Check the contents of the Appendices

	# There should be a Summary of Funding and a Terms and Conditions doc only
    Then  the file named '10017094_EDSK-094_v2.pdf' in Sharepoint location 'EDSK-2021-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2020/21
    Organisation Name: 10017094 Co Ltd UKPRN: 10017094
    Summary of Funding – Page 1

	Agreement Type Conditions of Funding (Grant) (Trusts)
    Funding Period 1 August 2020 to 31 July 2021
    the Secretary of State for Education (acting through
    Between
    the Education and Skills Funding Agency)
    And 10017094 Co Ltd
    Funding for Advanced Learner Loans
    Master Agreement Number ESFA-094
    EDSK Version 3 (September 2020) Page 1

	This Agreement is made on the date the Agreement is digitally signed by the
    Provider on the Manage Your Education & Skills Funding Service between:
    10017094 Co Ltd THE SECRETARY OF STATE FOR
    22 Woolton Lodge EDUCATION ACTING THROUGH
    Woolton Hill THE EDUCATION AND SKILLS
    Newbury FUNDING AGENCY, AN
    Berkshire EXECUTIVE AGENCY OF THE
    RG20 9SU DEPARTMENT OF EDUCATION
    AND CHEYLESMORE HOUSE
    QUINTON ROAD
    Company No: AA017094 COVENTRY
    CV1 2WT
    Hereinafter called Hereinafter called
    the Provider the Department
    EDSK Version 3 (September 2020) Page 2
	"""

    # There should not be a Schedule 1 document for Loans for CoFG(Trust)
    And   the pdf file does not contain the following text
    """
    EDSK Schedule 1 – Advanced Learner Loans Version 2 (July 2020) – Page 1
    """

    # There should not be a Schedule 2 document for Loans for CoFG(Trust)
	And   the pdf file does not contain the following text
    """
    EDSK Schedule 2 – Advanced Learner Loans Version 1 (May 2020) – Page 1
    """

    # There should not be a Funding Agreement document
	And   the pdf file does not contain the following text
    """
    Funding Agreement – Advanced Learner Loans Facility
    """
	
	# There should not be a Schedule 3ON document
	And   the pdf file does not contain the following text
    """
    EDSK Schedule 3 Version 2 (July 2020) – Page 1
	"""




    # Test 2 - Bulk update draft after the S1 and S3ON has changed *and* T&C was updated after the previous draft (so include it)

	# Change the date
    Given the override date is '28/04/2020 11:04'

    # Set document template timestamps for Contract Type = Conditions of Funding (Grant) (Trust)

    # Associate a timestamp with a document template (DocumentsDomain.UploadedDocumentTemplate) (J107)
    Given the following document templates have Upload timestamps as indicated
    | DocumentTemplateName                            | UploadTimestamp         |
    | EDSK2021_TAC_COFG_TRUST_2020-08-01.docx         | 2020-04-08 13:21:34.000 |
    | EDSK2021_S1_LOANS_COFG.docx                     | 2020-04-22 19:56:42.000 |
    | EDSK2021_S2_LOANS_COFG_2020-08-01.docx          | 2020-04-23 15:35:12.000 |
    | EDSK2021_S3ON_COFG_LA_TRUST_HEI_2020-08-01.docx | 2020-03-17 09:00:00.000 |

    # Bulk file (This does change the financials)
    And   there are no files prefixed '10017094' in the Sharepoint 'EDSK-2021-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2021 26032020085509 v3_A094_2' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2021 26032020085509 v3_A094_2' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2021 26032020085509 v3_A094_2' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2021 26032020085509 v3_A094_2' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2021 26032020085509 v3_A094_2.xlsx' exists in the Datafiles folder and UKPRN '10017094' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Check the CONTRACT version, status and dates in CRM (Giving doc time to arrive in Sharepoint)
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017094 | EDSK-094           | 2                     | 1                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017094 | EDSK-094           | 2                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017094 | EDSK-094           | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017094 | ESFA-094           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Wait for row to arrive then update the CreatedDate (J106)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details are present in the ContractManagement.CreatedContract table 
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
	| EDSK-094       | 2                     | 1                        | 2020-04-28 11:04:00.000 |


	# Check the contents of the Appendices

	# There should be a Summary of Funding, a Schedule 1, a Schedule 2 and a Funding Agreement only
    Then  the file named '10017094_EDSK-094_v2.pdf' in Sharepoint location 'EDSK-2021-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2020/21
    Organisation Name: 10017094 Co Ltd UKPRN: 10017094

    Agreement Type Conditions of Funding (Grant) (Trusts)
    Funding Period 1 August 2020 to 31 July 2021
    the Secretary of State for Education (acting through
    Between
    the Education and Skills Funding Agency)
    And 10017094 Co Ltd
    Funding for Advanced Learner Loans
    Master Agreement Number ESFA-094
    This Agreement is made on the date the Agreement is digitally signed by the
    Provider on the Manage Your Education & Skills Funding Service between:
    10017094 Co Ltd THE SECRETARY OF STATE FOR
    22 Woolton Lodge EDUCATION ACTING THROUGH
    Woolton Hill THE EDUCATION AND SKILLS
    Newbury FUNDING AGENCY, AN
    Berkshire EXECUTIVE AGENCY OF THE
    RG20 9SU DEPARTMENT OF EDUCATION
    AND CHEYLESMORE HOUSE
    QUINTON ROAD
    Company No: AA017094 COVENTRY
    CV1 2WT
    Hereinafter called Hereinafter called
    the Provider the Department

	SCHEDULE 1: SPECIFICATION & MONITORING
	Summary of Service
    1. Advanced Learner Loans provide a source of fees and support to help
    people aged 19 and over undertake general and technical qualifications at
    levels 3, 4, 5 and 6 that will be provided by the Provider.
	Service Commencement and Duration
    5. Advanced Learner Loans Service Start Date: 1 June 2020.
    6. Advanced Learner Loans Expiry Date: 31 October 2021.

	SCHEDULE 2: PAYMENT
	ADVANCED LEARNER LOANS PAYMENT (PAY ON PROFILE)
	3. The Department will pay the Provider the Funding set out in the Funding
    Agreement of this Schedule on the 14 Working Day of each month.

	Funding Agreement – Advanced Learner Loans Facility
	"""
	
	# There should not be a Schedule 3ON document
	And   the pdf file does not contain the following text
    """
    EDSK Schedule 3 Version 2 (July 2020) – Page 1
	"""
 	  

    # Tidy Up
	And   the override date is reset
	
@AcceptanceTest @Manual
Scenario: A095 Bulk create a new 2021 EDSK contract with all 10 allocs. CoFG HEI. (To help with manual checking)
    Given there are no allocations marked as Under Termination for UKPRN '10017095' 
    And   there are no terminated or closed allocations for UKPRN '10017095' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017095' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017095' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017095 Co Ltd' with UKPRN '10017095' and OrgId 'ORG0017095' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017095' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017095 | 117095 | 10017095 Co Ltd | 0              | Active                | Yes           | AA017095      | ?             | 65 Moffats Lane        | Brookmans  Park        | ?                      | ?                      | Hatfield               | Hertfordshire          | AL9 7RT   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017095 |


    

    # Change the date
    Given the override date is '23/08/2020'

    # Bulk file
    And   there are no files prefixed '10017095' in the Sharepoint 'EDSK-2021-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2021 19062020123230 v3_A095' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2021 19062020123230 v3_A095' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2021 19062020123230 v3_A095' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2021 19062020123230 v3_A095' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2021 19062020123230 v3_A095.xlsx' exists in the Datafiles folder and UKPRN '10017095' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10017095' for FundingType 'EDSK' and period '2021' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10017095' for FundingType 'EDSK' and period '2021'

    # Check the contents of the Appendices
    Then  the file named '10017095_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2021-Input-Appendices' contains the following lines in order
    """
    ESFA AEB - COVID-19 Skills Offer [AllocRef_AECS] £30,455 £14,697 £45,152
    of which High Value Courses for School and College £30,455 £14,697 £45,152
    Leavers
    
    SCHEDULE 2 – ESFA-FUNDED ADULT EDUCATION BUDGET
    Funding Agreement – ESFA AEB - COVID-19 Skills Offer
    Provider: 10017095 Co Ltd UKPRN: 10017095
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2020 End Date: 31/07/2021
    Contract Ref: [AllocRef_AECS]
    Cash (£) Aug 2020 Sep 2020 Oct 2020 Nov 2020 Dec 2020 Jan 2021 Feb 2021 Mar 2021 Apr 2021 May 2021 Jun 2021 Jul 2021
    ESFA AEB - High Value Courses for School and £45,152 £4,699 £4,105 £5,888 £5,383 £2,799 £4,072 £1,645 £1,864 £930 £3,733 £3,276 £6,758
    College Leavers
    Total Funding £45,152 £4,699 £4,105 £5,888 £5,383 £2,799 £4,072 £1,645 £1,864 £930 £3,733 £3,276 £6,758
    Schedule 2 – ESFA-Funded Adult Education Budget – Funding Agreement [AllocRef_AECS] – Page 1 Ref (for internal use only):  [ContractNo] v1
    """

    # Tidy Up
    And   the override date is reset

@AcceptanceTest @Withdrawn20231002
Scenario: A314 Create and approve a 2021 EDSK contract with two ALLF allocations each with a delivery org not equal to the contracting org. Issue Bulk and non-financial amendments checking doc parts produced
    Given there are no allocations marked as Under Termination for UKPRN '10017314' 
    And   there are no terminated or closed allocations for UKPRN '10017314' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017314' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | ALLF-3141     |
    | ALLF-3142     |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017314' 
    And   there is no Organisation data for UKPRN '10032404' 
    And   there is no Organisation data for UKPRN '10030026' 

    And   caseload advisor 'FCS2 Test' is assigned to provider 'ACME ACADEMY TRUST' with UKPRN '10017314' and OrgId 'ORG0017314' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017314' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name                        | SequenceNumber | Status   | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017314 | 117314 | ACME ACADEMY TRUST          | 0              | Active   | Yes           | AA017314      | ?             | 29 Waterside           | 44 - 48 Wharf Road     | Islington              | London                 | ?                      | ?                      | N1 7SH    |
    | 10032404 | 132404 | GREENDALE COMMUNITY ACADEMY | 0              | Active   | Yes           | AA032404      | 32404         | 9 Challoner Court      | Merchants Landing      | ?                      | ?                      | Bristol                | Avon                   | BS1 4RG   |
    | 10030026 | 130026 | TESTING ACADEMY             | 0              | Active   | Yes           | AA030026      | ?             | 4 High Street          | Delph                  | ?                      | ?                      | Saddleworth            | Greater Manchester     | OL4 7DJ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017314 |
    | 10032404 |
    | 10030026 |



    # Change the date
    Given the override date is '01/07/2020'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName               | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017314 | ACME ACADEMY TRUST      | ESFA-314             | EDSK-314       | 1                     | 01/08/2020        | 31/07/2021      | 65040.00      |                       | Conditions of Funding (Grant) (HEI)        | 2021   | New          | ORG0017314 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName      | UoPCode    | AllocationDescription       | CRMIntent    | DeliveryOrg |
    | 10017314 | EDSK-314       | ALLF-3141     | ALLF              | ALLF1920                | AY                      | 01/08/2020          | 31/07/2021        | 30716.00        |              |            |                             | New          | 10032404    |
    | 10017314 | EDSK-314       | ALLF-3142     | ALLF              | ALLF1920                | AY                      | 01/08/2020          | 31/07/2021        | 34324.00        |              |            |                             | New          | 10030026    |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription            | CRMIntent    | DeliveryOrg |
    | 10017314 | EDSK-314       | ALLF-3141     | 5               | 0                     | 30716.00  | 1845.00  | 93.00    | 3236.00  | 1760.00  | 348.00   | 2471.00  | 4053.00  | 1420.00  | 1367.00  | 7365.00  | 5274.00  | 1484.00  | Advanced Learner Loans Facility   | New          | 10032404    |
    | 10017314 | EDSK-314       | ALLF-3142     | 5               | 0                     | 34324.00  | 2127.00  | 357.00   | 3480.00  | 2322.00  | 623.00   | 2811.00  | 4277.00  | 1787.00  | 1668.00  | 7631.00  | 5569.00  | 1672.00  | Advanced Learner Loans Facility   | New          | 10030026    |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'EDSK-314' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-314' and actual ContractNumber 'EDSK-314'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-314' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017314 | EDSK-314           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017314 | ESFA-314           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '96' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '96' deliverable period rows in CRM linked to the latest version of contract 'EDSK-314'

    


    # Test 1 - Issue a NON-FINANCIAL(Variation) amendment after all four doc templates have changed

    # Change the date
    Given the override date is '11/08/2020 08:33'
	
    # Set document template timestamps for Contract Type = Conditions of Funding (Grant) (Employer)

    # Associate a timestamp with a document template (DocumentsDomain.UploadedDocumentTemplate) (J107)
    And   the following document templates have Upload timestamps as indicated
    | DocumentTemplateName                            | UploadTimestamp         |
    | EDSK2021_TAC_COFG_HEI_2020-08-01.docx           | 2020-08-01 12:00:00.000 |
    | EDSK2021_S1_LOANS_COFG.docx                     | 2020-08-01 12:00:00.000 |
    | EDSK2021_S2_LOANS_COFG_2020-08-01.docx          | 2020-08-01 12:00:00.000 |
    | EDSK2021_S3ON_COFG_LA_TRUST_HEI_2020-08-01.docx | 2020-08-01 12:00:00.000 |

    # Issue a non-financial VARIATION amendment on v1 to create v2
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'EDSK-314' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM (A check that gives the doc time to arrive in Sharepoint)
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017314 | EDSK-314           | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017314 | EDSK-314           | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017314 | ESFA-314           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Wait for row to arrive then update the CreatedDate (J106)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details are present in the ContractManagement.CreatedContract table 
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-314       | 2                     | 0                        | 2020-08-11 08:33:00.000 |




    # Check the contents of the Appendices

    # There should be a Summary of Funding, TAC, Schedule 1, Schedule 2 and Schedule 3 document produced
    Then  the file named '10017314_EDSK-314_v2.pdf' in Sharepoint location 'EDSK-2021-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2020/21
    Organisation Name: ACME ACADEMY TRUST UKPRN: 10017314

	Agreement Type Conditions of Funding (Grant) (HEI)
	Funding Period 1 August 2020 to 31 July 2021
    the Secretary of State for Education (acting through
    Between
    the Education and Skills Funding Agency)
    And ACME ACADEMY TRUST
    Funding for Advanced Learner Loans
    Master Agreement Number ESFA-314
    This Agreement is made on the date the Agreement is digitally signed by the
    Provider on the Manage Your Education & Skills Funding Service between: 
    ACME ACADEMY TRUST THE SECRETARY OF STATE FOR
    29 Waterside EDUCATION ACTING THROUGH
    44 - 48 Wharf Road THE EDUCATION AND SKILLS
    Islington FUNDING AGENCY, AN
    London EXECUTIVE AGENCY OF THE
    N1 7SH DEPARTMENT OF EDUCATION
    AND
    CHEYLESMORE HOUSE
    QUINTON ROAD
    Company No: AA017314 COVENTRY
    CV1 2WT
    Hereinafter called Hereinafter called
    the Provider the Department

    SCHEDULE 1: SPECIFICATION & MONITORING
    Summary of Service
	1. Advanced Learner Loans provide a source of fees and support to help
    people aged 19 and over undertake general and technical qualifications at
    levels 3, 4, 5 and 6 that will be provided by the Provider.

	ADVANCED LEARNER LOANS MONITORING (PAY ON PROFILE)
	Advanced Learner Loans Bursary
    3. The Department will pay the Provider the Funding set out in the Funding
    Agreement of this Schedule on the 14 Working Day of each month.

	SCHEDULE 7: SECURITY & DEPARTMENT POLICIES
	7.2 To facilitate the transfer of knowledge from the Provider to the Department
    and/or its Successor Provider, the Provider will provide, upon request, a
    detailed written explanation of the procedures and operations used to
    provide the Services, the change management process and other
    standards and procedures to the operations personnel of the Department
    and/or the Successor Provider.
    """

    # There should not be a Funding Agreement document
	And   the pdf file does not contain the following text
    """
    Funding Agreement – Advanced Learner Loans Facility
    """

  

    # Publish and approve

    # Change the date
    Given the override date is '23/08/2020'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-314'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-314' and actual ContractNumber 'EDSK-314'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-314' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017314 | EDSK-314           | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017314 | EDSK-314           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017314 | ESFA-314           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |


    # Test Delivery Orgs in CM feed

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '2' of contract 'EDSK-314' agree with the most recent entry for this contract in the ContractManagement feed




    # Test 2 - Issue a Bulk (notification) amendment after changing all four doc templates

    # Change the date
    Given the override date is '12/09/2020 09:45'
	
    # Set document template timestamps for Contract Type = Conditions of Funding (Grant) (Employer)

    # Associate a timestamp with a document template (DocumentsDomain.UploadedDocumentTemplate) (J107)
    And   the following document templates have Upload timestamps as indicated
    | DocumentTemplateName                            | UploadTimestamp         |
    | EDSK2021_TAC_COFG_HEI_2020-08-01.docx           | 2020-08-17 08:45:00.000 |
    | EDSK2021_S1_LOANS_COFG.docx                     | 2020-08-17 08:45:00.000 |
    | EDSK2021_S2_LOANS_COFG_2020-08-01.docx          | 2020-08-17 08:45:00.000 |
    | EDSK2021_S3ON_COFG_LA_TRUST_HEI_2020-08-01.docx | 2020-08-17 08:45:00.000 |



    # Bulk file (This does not change the financials)
    And   there are no files prefixed '10017314' in the Sharepoint 'EDSK-2021-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2021 31032020123855 v3_A314_1' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2021 31032020123855 v3_A314_1' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2021 31032020123855 v3_A314_1' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2021 31032020123855 v3_A314_1' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2021 31032020123855 v3_A314_1.xlsx' exists in the Datafiles folder and UKPRN '10017314' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Check the CONTRACT version, status and dates in CRM (Giving doc time to arrive in Sharepoint)
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017314 | EDSK-314           | 3                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2020        | 31/07/2021      | Notification  |
    | 10017314 | EDSK-314           | 2                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2020        | 31/07/2021      | Variation     |
    | 10017314 | EDSK-314           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2020        | 31/07/2021      | ?             |
    | 10017314 | ESFA-314           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |
    
    # Wait for row to arrive then update the CreatedDate (J106)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details are present in the ContractManagement.CreatedContract table 
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-314       | 3                     | 0                        | 2020-09-12 09:45:00.000 |





    # Check the contents of the Appendices

    # There should be a Summary of Funding only
    Then  the file named '10017314_EDSK-314_v3.pdf' in Sharepoint location 'EDSK-2021-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2020/21
    Organisation Name: ACME ACADEMY TRUST UKPRN: 10017314
    """

    # There should not be a Terms & Conditions document for Loans for CoFG(HEI)
    And   the pdf file does not contain the following text
    """
    EDSK Version 3 (September 2020) Page 1
    """

    # There should not be a Schedule 1 document for Loans for CoFG
	And   the pdf file does not contain the following text
    """
    EDSK Schedule 1 – Advanced Learner Loans Version 2 (July 2020) – Page 1
    """

    # There should not be a Schedule 2 document for Loans for CoFG
	And   the pdf file does not contain the following text
    """
    EDSK Schedule 2 – Advanced Learner Loans Version 1 (May 2020) – Page 1
    """

    # There should not be a Funding Agreement document
	And   the pdf file does not contain the following text
    """
    Funding Agreement – Advanced Learner Loans Facility
    """

    # There should not be a Schedule 3ON document
	And   the pdf file does not contain the following text
    """
    EDSK Schedule 3 Version 2 (July 2020) – Page 1
    """


    # Tidy up
    And the override date is reset 
                  
                  