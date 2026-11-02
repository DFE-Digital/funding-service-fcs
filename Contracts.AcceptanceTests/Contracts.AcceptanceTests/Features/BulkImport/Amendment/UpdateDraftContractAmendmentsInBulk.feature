@#Feature576_Update_Draft_Contract_Amendments_in_Bulk
@UpdateDraftContractAmendmentsInBulk
Feature: UpdateDraftContractAmendmentsInBulk
	As an Allocations user
	I want to be able to update draft contract amendments in bulk 
	And apply validation rules
	And view the changes in CRM

@AcceptanceTest @Withdrawn20221104
Scenario: E067 Validate CBR003, CABR003 and DBR001 against a 1920 AEB contract
    Given there are no allocations marked as Under Termination for UKPRN '10017067' 
    And   there are no terminated or closed allocations for UKPRN '10017067' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017067' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017067' 

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AEAL-067      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP            |
    | AEB-ASLS1920   |



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017067' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017067 Co Ltd' with UKPRN '10017067' and OrgId 'ORG0017067' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017067' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017067 | 117067 | 10017067 Co Ltd | 0              | Active                | Yes           | AA017067      | ?             | 27 Belgrade Road       | Hampton                | Middlesex              | ?                      | ?                      | ?                      | TW12 2AZ  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017067 |




    # Change the date
    Given the override date is '01/07/2019'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017067 | 10017067 Co Ltd      | ESFA-067             | AEBP-067       | 1                     | 01/08/2019        | 31/07/2020      | 20337.00      |                                    | Contract for Services                      | 1920   | New          | ORG0017067 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017067 | AEBP-067       | AEAL-067      | AEB-ASLS          | AEB-ASLS1920            | AY                      | 01/08/2019          | 31/07/2020        | 20337.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017067 | AEBP-067       | AEAL-067      | 1               | 0                     | 20337.00  | 1644.00  | 987.00   | 1975.00  | 2711.00  | 1486.00  | 1461.00  | 552.00   | 3280.00  | 1516.00  | 3107.00  | 300.00   | 1318.00  | Adult Education Budget - Adult Skills Learner Support           | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '03/07/2019'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'AEBP-067' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '11/07/2019'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-067' and actual ContractNumber 'AEBP-067'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-067' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017067 | AEBP-067           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017067 | ESFA-067           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '12' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract 'AEBP-067'




    # Change the date
    Given the override date is '23/08/2019'

    # Bulk file
    And   there are no files prefixed '10017067' in the Sharepoint 'AEB-1920-Input-Appendices' folder
    And   there are no files prefixed 'AEB AY 1920 15102019084016 v3_E067' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB AY 1920 15102019084016 v3_E067' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'AEB AY 1920 15102019084016 v3_E067' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB AY 1920 15102019084016 v3_E067.xlsx' exists in the Datafiles folder and UKPRN '10017067' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
#   And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report
    And   'Failed' is displayed in field 'J2' on the 'Contract' tab of the result report

    # CBR003
    And   '[Contract] CRM intent is not a valid value' is displayed in field 'J2' on the 'Contract' tab of the result report

    # CABR003
    And   '[Contract Allocation] CRM intent is not a valid value' is displayed in field 'X2' on the 'Contract Allocation' tab of the result report

    # DBR001
    And   '[Deliverable] CRM intent is not a valid value' is displayed in field 'O2' on the 'Deliverable' tab of the result report


    # Tidy up
    And   the override date is reset

@AcceptanceTest @Withdrawn20221104
#Test 4
Scenario: E069 Syntax Report validation for rules UDC017b/UDC018b
	# UDC-017b and UDC-018b are executed at file syntax level, hence no setup of CRM data required
	Given an excel spreadsheet '24+LOANS AY 1516 11062015150000 UpdateDraftAmendment_UDC17b-UDC18b.xlsx' exist at 'DataFiles\Release2'
	And UKPRN field 'A2' contains '10060000' on the 'Contract' tab of the excel spreadsheet
	And UKPRN field 'A3' contains '10060001' on the 'Contract' tab of the excel spreadsheet
	And UKPRN field 'A4' contains '10060003' on the 'Contract' tab of the excel spreadsheet
	And field 'B2' contains '' on the 'Contract' tab of the excel spreadsheet
	And field 'F2' contains 'Update Draft Amendment' on the 'Contract' tab of the excel spreadsheet
	And field 'G2' contains 'Notification' on the 'Contract' tab of the excel spreadsheet
	And field 'B2' contains '' on the 'Contract Allocation' tab of the excel spreadsheet
	And field 'I2' contains 'Update Draft Amendment' on the 'Deliverable' tab of the excel spreadsheet
	And field 'C3' contains '' on the 'Contract Allocation' tab of the excel spreadsheet
	And field 'F3' contains 'Update Draft Amendment' on the 'Contract' tab of the excel spreadsheet
	And field 'G3' contains 'Notification' on the 'Contract' tab of the excel spreadsheet
	And field 'F3' contains 'Update Draft Amendment' on the 'Contract Allocation' tab of the excel spreadsheet
	And field 'I14' contains 'Update Draft Amendment' on the 'Deliverable' tab of the excel spreadsheet
	And field 'B4' contains '' on the 'Contract' tab of the excel spreadsheet
	And field 'F4' contains 'Update Draft Amendment' on the 'Contract' tab of the excel spreadsheet
	And field 'G4' contains 'Variation' on the 'Contract' tab of the excel spreadsheet
	And field 'B4' contains 'UDC-2006' on the 'Contract Allocation' tab of the excel spreadsheet
	And field 'I4' contains 'Update Draft Amendment' on the 'Deliverable' tab of the excel spreadsheet
	When the file for syntax validation is copied from the source location to the 'Input'
	Then I should see a file for syntax validation report
	And syntax validation report contains 'Sheet: Contract Allocation, Row: 4 - Cannot update a draft Contract without an entry on the Contract tab for the Contract Allocation with a CRM Intent of 'Update Draft Amendment''
	And syntax validation report contains 'Sheet: Deliverable, Row: 14 - Cannot update a draft Contract without an entry on the Contract Allocation tab for the Deliverable with a CRM Intent of 'Update Draft Amendment''
	And the file is not processed

@AcceptanceTest @Withdrawn20230123
Scenario: A071 Validate rule UDC021 against a 1920 AEBP contract
    # As written, E071 runs green - but shouldn't. UDC021 should apply to update draft amendments but is currently being tripped when doing an amendment
    Given there are no allocations marked as Under Termination for UKPRN '10017071' 
    And   there are no terminated or closed allocations for UKPRN '10017071' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017071' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017071' 

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | AEBA-071      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP            |
    | AEB-AS1920     |



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017071' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017071 Co Ltd' with UKPRN '10017071' and OrgId 'ORG0017071' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017071 | 117071 | 10017071 Co Ltd | 0              | Active                | Yes           | AA017071      | ?             | 55 St Giles Street     | Northampton            | ?                      | ?                      | ?                      | ?                      | NN1 1JF   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017071 |




    # Change the date
    Given the override date is '01/07/2019'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017071 | 10017071 Co Ltd      | ESFA-071             | AEBP-071       | 1                     | 01/08/2019        | 31/07/2020      | 27888.00      |                                    | Contract for Services                      | 1920   | New          | ORG0017071 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017071 | AEBP-071       | AEBA-071      | AEB-AS            | AEB-AS1920              | AY                      | 01/08/2019          | 31/07/2020        | 27888.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017071 | AEBP-071       | AEBA-071      | 1               | 0                     | 27888.00  | 114.00   | 3158.00  | 446.00   | 1182.00  | 3657.00  | 3633.00  | 2723.00  | 1750.00  | 3687.00  | 1577.00  | 2471.00  | 3490.00  | Adult Skills Total Funding                                      | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '03/07/2019'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'AEBP-071' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-071' and actual ContractNumber 'AEBP-071'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-071' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017071 | AEBP-071           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017071 | ESFA-071           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '36' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '36' deliverable period rows in CRM linked to the latest version of contract 'AEBP-071'




#    # Execute a NON-FINANCIAL amendment 
#
#    # Change the date
#    Given the override date is '21/08/2019'
#
#    # Issue a non-financial VARIATION amendment on v1 to create v2
#   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'AEBP-071' for a non-financial NOTIFICATION contract amendment
#    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'AEBP-071' for a non-financial VARIATION contract amendment
#
#    # Check the CONTRACT version, status and dates in CRM.
#    Then  the following contract values are present in CRM
#    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
#    | 10017071 | AEBP-071           | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2019        | 31/07/2020      | Variation     |
#    | 10017071 | AEBP-071           | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2019        | 31/07/2020      | ?             |
#    | 10017071 | ESFA-071           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |



    # Change the date
    Given the override date is '27/08/2019'

    # Bulk file. Update Draft Amendment with Amendment Type left blank
    And   there are no files prefixed '10017071' in the Sharepoint 'AEB-1920-Input-Appendices' folder
    And   there are no files prefixed 'AEB AY 1920 14102019145117 v3_E071' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB AY 1920 14102019145117 v3_E071' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'AEB AY 1920 14102019145117 v3_E071' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB AY 1920 14102019145117 v3_E071.xlsx' exists in the Datafiles folder and UKPRN '10017071' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
#   And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report
    And   'Failed' is displayed in field 'J2' on the 'Contract' tab of the result report

    # UDC021
    And   'An Update Draft Amendment cannot be run against a contract without an amendment type.' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Tidy up
    And   the override date is reset

