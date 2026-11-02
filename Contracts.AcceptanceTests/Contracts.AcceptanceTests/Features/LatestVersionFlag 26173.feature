Feature: LatestVersionFlag 26173

@AcceptanceTest @Withdrawn20231002
Scenario: A650 Create and approve an 1819 EDSK contract for ALLF. Non-Financial amendment to create v2. Bulk update draft amendment to create v2.1. Publish then withdraw v2.1. Amend to create v3 then delete v3. Check CRM flags throughout
    Given there are no allocations marked as Under Termination for UKPRN '10017650' 
    And   there are no terminated or closed allocations for UKPRN '10017650' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017650' 

    # Clear down subnominal data from CRM and PaaS 
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | ALLF-650      |


    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017650' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017650 Co Ltd' with UKPRN '10017650' and OrgId 'ORG0017650' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017650 | 117650 | 10017650 Co Ltd | 0              | Provider Under Change | Yes           | AA017650      | ?             | 33 Waldorf Heights     | Blackwater             | Camberley              | Surrey                 | ?                      | ?                      | GU17 9JH  |

    # Put DeliveryOrg data in the CRM Organisation table 
    And   the following Organisations exist in CRM
    | UKPRN    | UPIN   | Name            | Status                | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017650 | 117650 | 10017650 Co Ltd | Provider Under Change | AA017650      | 17650         | 33 Waldorf Heights     | Blackwater             | Camberley              | Surrey                 | ?                      | ?                      | GU17 9JH  |




    # Change the date
    Given the override date is '01/07/2019'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                | Period | CRMIntent    | OrgId      |
    | 10017650 | 10017650 Co Ltd      | ESFA-650             | EDSK-650       | 1                     | 01/08/2019        | 31/07/2020      | 17829.00      |                                    | Contract for Services (ITP) | 1920   | New          | ORG0017650 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017650 | EDSK-650       | ALLF-650      | ALLF              | ALLF1920                | AY                      | 01/08/2019          | 31/07/2020        | 17829.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017650 | EDSK-650       | ALLF-650      | 5               | 0                     | 17829.00  | 1435.00  | 778.00   | 1766.00  | 2502.00  | 1277.00  | 1252.00  | 343.00   | 3071.00  | 1307.00  | 2898.00  | 91.00    | 1109.00  | Advanced Learner Loans Facility                                 | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Change the date
    Given the override date is '03/07/2019'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'EDSK-650' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '11/07/2019'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-650' and actual ContractNumber 'EDSK-650'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-650' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017650 | EDSK-650           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017650 | ESFA-650           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |




    # Execute a NON-FINANCIAL amendment

    # Change the date
    Given the override date is '12/07/2019'

    # Issue a non-financial VARIATION amendment on v1 to create v2
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'EDSK-650' for a non-financial NOTIFICATION contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'EDSK-650' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017650 | EDSK-650           | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2019        | 31/07/2020      | Variation     |
    | 10017650 | EDSK-650           | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017650 | ESFA-650           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |




    # Bulk import to execute an Update Draft Amendment on V2.0 to create v2.1

    # Change the date
    Given the override date is '15/07/2019'

    # Amend the contract
    And   there are no files prefixed '10017650' in the Sharepoint 'EDSK-1920-Input-Appendices' folder
    And   there are no files prefixed '10017650' in the Sharepoint 'EDSK-1920-Output-Merged Document' folder
    And   there are no files prefixed 'EDSK AY 1920 28032019115453 v3_A650' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 1920 28032019115453 v3_A650' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 1920 28032019115453 v3_A650.xlsx' exists in the Datafiles folder and UKPRN '10017650' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017650 | EDSK-650           | 2                     | 1                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2019        | 31/07/2020      | Variation     |
    | 10017650 | EDSK-650           | 2                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2019        | 31/07/2020      | Variation     |
    | 10017650 | EDSK-650           | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017650 | ESFA-650           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |




    # Publish v2.1 then withdraw it

	# Change the date
    Given the override date is '22/07/2019'
    
    # Update the contract to 'Published to Provider'
    And   the latest version of contract 'EDSK-650' is in a state of 'Published to Provider'

	# Change the date
    And   the override date is '23/07/2019'

    # Withdraw v2.1
    When  the next action performed on the latest version of contract 'EDSK-650' is 'Withdraw On Behalf Of Provider' with reason 'Story 26173' by 'FCS1 Test'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017650 | EDSK-650           | 2                     | 1                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/08/2019        | 31/07/2020      | Variation     |
    | 10017650 | EDSK-650           | 2                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2019        | 31/07/2020      | Variation     |
    | 10017650 | EDSK-650           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017650 | ESFA-650           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |




    # Execute a NON-FINANCIAL amendment 

    # Change the date
    Given the override date is '28/07/2019'

    # Issue a non-financial VARIATION amendment
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'EDSK-650' for a non-financial NOTIFICATION contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'EDSK-650' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017650 | EDSK-650           | 3                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2019        | 31/07/2020      | Variation     |
    | 10017650 | EDSK-650           | 2                     | 1                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/08/2019        | 31/07/2020      | Variation     |
    | 10017650 | EDSK-650           | 2                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2019        | 31/07/2020      | Variation     |
    | 10017650 | EDSK-650           | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017650 | ESFA-650           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |




    # Delete Draft v3.0

    # Issue a delete request in CRM
    When  a request is initiated in CRM to delete the following contracts
    | UKPRN    | ContractNumber | ContractVersionNumber |
    | 10017650 | EDSK-650       | 3                     | 


    # Trigger WF28 in CRM to issue a delete request against v3 of the contract
   #When  a request is initiated in CRM to delete the following contracts
    When  User 'FCS2 Test' chooses to issue CRM workflow 'WF28' for the following contracts
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersion |
    | 10017650 | EDSK-650       | 3                     | 0                  |


	# The following shows what currently happens in CRM ...

#    # Check the CONTRACT version, status and dates in CRM
#    Then  the following contract values are present in CRM
#    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
#    | 10017650 | EDSK-650           | 2                     | 1                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/08/2019        | 31/07/2020      | Variation     |
#    | 10017650 | EDSK-650           | 2                     | 0                        | Superseded Draft | ?                         | True          | False               | 01/08/2019        | 31/07/2020      | Variation     |
#    | 10017650 | EDSK-650           | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2019        | 31/07/2020      | ?             |
#    | 10017650 | ESFA-650           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |

	# ... but it should be like this

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017650 | EDSK-650           | 2                     | 1                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/08/2019        | 31/07/2020      | Variation     |
    | 10017650 | EDSK-650           | 2                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2019        | 31/07/2020      | Variation     |
    | 10017650 | EDSK-650           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    | 10017650 | ESFA-650           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2019        | 31/07/2020      | ?             |


    # Tidy up
	And   the override date is reset
	  
	        