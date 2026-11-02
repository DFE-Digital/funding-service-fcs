Feature: BulkImportValidationForProvInAdmin13701

@AcceptanceTest @Withdrawn20200717
Scenario: A428 Create and approve a 1718 AGE contract for a provider 'In Administration' then bulk amend and approve. Change the status to 'Dissolved'. Bulk amend. Fail: UDC-013 and UDC-014
    Given there is no Contract, Task or Workflow data for UKPRN '10017428'
    And   there are no notifications of type 'Caseload re-assigned'

	And   there is no Organisation data for UKPRN '10017428'
    
    # Put data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017428 | 117428 | 10017428 Co Ltd | 0              | In Administration     | Yes           | AA017428      | ?             | 71 London Road         | ?                      | ?                      | ?                      | Sevenoaks              | Kent                   | TN13 1AX  |

	# Create stencil Org in CRM (enriched in next step)
    And   the Organisation in CRM for UKPRN '10017428' has OrgId 'ORG0017428' is named '10017428 Co Ltd' and has a status of 'In Administration'

	# Put data in the CRM Organisation table J057
    And   the following Organisations exist in CRM
    | UKPRN    | UPIN   | Name            | Status                | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017428 | 117428 | 10017428 Co Ltd | In Administration     | AA017428      | ?             | 71 London Road         | ?                      | ?                      | ?                      | Sevenoaks              | Kent                   | TN13 1AX  |

    # Associate an Advisor with the provider
    And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017428'


    # Change the date
    Given the override date is '01/03/2017'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017428 | 10017428 Co Ltd      | ESFA-428             | EMPAGE-428     | 1                     | 01/04/2017        | 31/03/2018      | 46067.00      |                                | Contract for Services | 1718   | New          | ORG0017428 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017428 | EMPAGE-428     | AGE-428       | AGE               | AGE1718                 | FY                      | 01/04/2017          | 31/03/2018        | 46067.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Apr-17   | May-17   | Jun-17   | Jul-17   | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017428 | EMPAGE-428     | AGE-428       | 1               | 0                     | 19181.00  | 314.00   | 3358.00  | 645.00   | 1381.00  | 156.00   | 131.00   | 2923.00  | 1950.00  | 186.00   | 1777.00  | 2671.00  | 3689.00  | 16-18 Apprenticeship Grant for Employers                        | New          |             |
    | 10017428 | EMPAGE-428     | AGE-428       | 2               | 0                     | 26886.00  | 2018.00  | 3259.00  | 2255.00  | 2547.00  | 689.00   | 3545.00  | 3362.00  | 2927.00  | 531.00   | 318.00   | 1939.00  | 3496.00  | 19-24 Apprenticeship Grant for Employers                        | New          |             |


    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '03/03/2017'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'EMPAGE-428' is in a state of 'Published to Provider'


    # Change the date
    Given the override date is '05/03/2017'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-428' and actual ContractNumber 'EMPAGE-428'

    # Check that the contract is now approved
    Then  the latest version of contract 'EMPAGE-428' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017428 | EMPAGE-428         | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2017        | 31/03/2018      | ?             |
    | 10017428 | ESFA-428           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2017        | 31/03/2018      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '24' deliverable period rows in CRM linked to the latest version of contract 'EMPAGE-428'




	# Change the date
    And   the override date is '16/03/2017'

    # Bulk import to amend contract
	Given there are no files prefixed '10017428' in the Sharepoint 'AGE-1718-Input-Appendices' folder
    And   there are no files prefixed 'AGE FY 1718 05062018104318 v2_A428' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AGE FY 1718 05062018104318 v2_A428' in the Sharepoint 'Reports' folder

    And   spreadsheet 'AGE FY 1718 05062018104318 v2_A428.xlsx' exists in the Datafiles folder and UKPRN '10017428' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Publish the contract
    And   the latest version of contract 'EMPAGE-428' is in a state of 'Published to Provider'
   
    # Inject an SFS contract approval message.
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-428' and ContractNumber 'EMPAGE-428' and Version '2'

    # Check that the contract is now approved in CRM
    Then  the latest version of contract 'EMPAGE-428' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017428 | EMPAGE-428         | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2017        | 31/03/2018      | Variation     |
    | 10017428 | EMPAGE-428         | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/04/2017        | 31/03/2018      | ?             |
    | 10017428 | ESFA-428           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2017        | 31/03/2018      | ?             |




	# Change the Org status in PaaS (and CRM) from 'In Administration' (Active) to 'Dissolved' (Inactive) and attempt a bulk amendment. This should fail

    # Put data in the PaaS Organisation table (dbo.Organisations) J056
    Given the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017428 | 117428 | 10017428 Co Ltd | 0              | Dissolved             | Yes           | AA017428      | ?             | 71 London Road         | ?                      | ?                      | ?                      | Sevenoaks              | Kent                   | TN13 1AX  |

	# Update the CRM Organisation table J057
    And   the following Organisations exist in CRM
    | OrgId      | UKPRN    | UPIN   | Name            | Status                | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | ORG0017428 | 10017428 | 117428 | 10017428 Co Ltd | Dissolved             | AA017428      | ?             | 71 London Road         | ?                      | ?                      | ?                      | Sevenoaks              | Kent                   | TN13 1AX  |

	# Change the date
    And   the override date is '22/03/2017'

    # Bulk import to amend contract
	Given there are no files prefixed '10017428' in the Sharepoint 'AGE-1718-Input-Appendices' folder
    And   there are no files prefixed 'AGE FY 1718 08122018121234 v2_A428_1' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AGE FY 1718 08122018121234 v2_A428_1' in the Sharepoint 'Reports' folder

    And   spreadsheet 'AGE FY 1718 08122018121234 v2_A428_1.xlsx' exists in the Datafiles folder and UKPRN '10017428' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
	And   'Failed' is displayed in field 'J2' on the 'Contract' tab of the result report
	
	# UDC-013 and UDC-014 failure messages
	And   '[Contract Allocation] UKPRN is not a active organisation therefore a new Contract Allocation cannot be created for the UKPRN' is displayed in field 'J2' on the 'Contract' tab of the result report
    And   '[Deliverable] UKPRN is not a active organisation therefore a new Deliverable cannot be created for the UKPRN' is displayed in field 'J2' on the 'Contract' tab of the result report



    # Tidy up
    And   the override date is reset

