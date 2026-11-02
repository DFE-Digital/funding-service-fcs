Feature: InhibitParallelAEBPAmendments 26146

@AcceptanceTest @Withdrawn20231002
 Scenario: A597 Create and publish 1819 AEBP. Create and approve 1920 AEBP. Bulk amend 1920 AEBP: fail MBR-005. Non-Financial amendment on 1920 AEBP: fail MBR-005. Withdraw draft 1819 AEBP. Non-Financial amendment on 1920 AEBP: ok. Bulk Revised New on 1819 AEBP: fail MBR-005
    Given there are no allocations marked as Under Termination for UKPRN '10017597' 
    And   there are no terminated or closed allocations for UKPRN '10017597' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017597' 
	And   there are no notifications in CRM of type 'Non-Financial Contract Amendment Failed' for UKPRN '10017597' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 

    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017597' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017597 Co Ltd' with UKPRN '10017597' and OrgId 'ORG0017597' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017597' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017597 | 117597 | 10017597 Co Ltd | 0              | Provider Under Change | Yes           | AA017597      | ?             | 4 Buckingham Court     | Beaufort Park          | Woodlands              | Bristol                | ?                      | ?                      | BS32 4NF  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017597 |




    # Create and publish an 1819 AEBP contract but don't approve it.
	
	# Change the date
    Given the override date is '01/07/2018'

    # Create a draft 1819 AEBP contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017597 | 10017597 Co Ltd      | ESFA-597             | AEBP-5971      | 1                     | 01/08/2018        | 31/07/2019      | 70395.00      |                                    | Contract for Services                      | 1819   | New          | ORG0017597 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017597 | AEBP-5971      | AEBC-5971     | AEB-CL            | AEB-CL1819              | AY                      | 01/08/2018          | 31/07/2019        | 23844.00        |                                         |            |                                                             | New          |             |
    | 10017597 | AEBP-5971      | AEBL-5971     | AEB-LS            | AEB-LS1819              | AY                      | 01/08/2018          | 31/07/2019        | 25681.00        |                                         |            |                                                             | New          |             |
    | 10017597 | AEBP-5971      | AEBT-5971     | AEB-TOL           | AEB-TOL1819             | AY                      | 01/08/2018          | 31/07/2019        | 20870.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017597 | AEBP-5971      | AEBC-5971     | 1               | 0                     | 23844.00  | 679.00   | 655.00   | 3446.00  | 2473.00  | 709.00   | 2300.00  | 3194.00  | 511.00   | 2893.00  | 432.00   | 3130.00  | 3422.00  | Adult Education Budget - Community Learning                     | New          |             |
    | 10017597 | AEBP-5971      | AEBL-5971     | 1               | 0                     | 25681.00  | 169.00   | 3025.00  | 2842.00  | 2407.00  | 3712.00  | 3499.00  | 1419.00  | 2976.00  | 1024.00  | 1444.00  | 1167.00  | 1997.00  | Adult Education Budget - Learner Support                        | New          |             |
    | 10017597 | AEBP-5971      | AEBT-5971     | 1               | 0                     | 20870.00  | 830.00   | 1883.00  | 3409.00  | 3513.00  | 484.00   | 1186.00  | 815.00   | 2910.00  | 326.00   | 1660.00  | 3093.00  | 761.00   | Adult Education - Traineeships and Other Learning Total Funding | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'AEBP-5971' is in a state of 'Published to Provider'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017597 | AEBP-5971          | 1                     | 0                        | Draft            | Published to Provider     | True          | False               | 01/08/2018        | 31/07/2019      | ?             |
    | 10017597 | ESFA-597           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '36' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '36' deliverable period rows in CRM linked to the latest version of contract 'AEBP-5971'




    # Create, publish and approve a 1920 AEBP contract
	
	# Change the date
    Given the override date is '01/07/2019'

    # Create and approve a 1920 AEBP contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017597 | 10017597 Co Ltd      | ESFA-597             | AEBP-5972      | 1                     | 01/08/2019        | 31/07/2020      | 46344.00      |                                    | Contract for Services                      | 1920   | New          | ORG0017597 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017597 | AEBP-5972      | AEBA-5972     | AEB-AS            | AEB-AS1920              | AY                      | 01/08/2019          | 31/07/2020        | 23024.00        |                                         |            |                                                             | New          |             |
    | 10017597 | AEBP-5972      | AEBC-5972     | AEB-CL            | AEB-CL1920              | AY                      | 01/08/2019          | 31/07/2020        | 23320.00        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-19   | Sep-19   | Oct-19   | Nov-19   | Dec-19   | Jan-20   | Feb-20   | Mar-20   | Apr-20   | May-20   | Jun-20   | Jul-20   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017597 | AEBP-5972      | AEBA-5972     | 1               | 0                     | 23024.00  | 332.00   | 2239.00  | 2185.00  | 3331.00  | 2610.00  | 2808.00  | 2215.00  | 293.00   | 2358.00  | 846.00   | 698.00   | 3109.00  | Adult Skills Total Funding                                      | New          |             |
    | 10017597 | AEBP-5972      | AEBC-5972     | 1               | 0                     | 23320.00  | 1130.00  | 2592.00  | 1905.00  | 1248.00  | 2237.00  | 2973.00  | 1747.00  | 1723.00  | 814.00   | 823.00   | 2760.00  | 3368.00  | Adult Education Budget - Community Learning                     | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract 'AEBP-5972' is in a state of 'Published to Provider'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-597' and actual ContractNumber 'AEBP-5972'

    # Check that the contract is now approved
    Then  the latest version of contract 'AEBP-5972' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017597 | AEBP-5972          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    #
	| 10017597 | AEBP-5971          | 1                     | 0                        | Draft            | Published to Provider     | True          | False               | 01/08/2018        | 31/07/2019      | ?             |
    | 10017597 | ESFA-597           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '48' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '48' deliverable period rows in CRM linked to the latest version of contract 'AEBP-5972'




	# Bulk Amend 1920 AEBP

    # Change the date
    Given the override date is '11/07/2019'
	
	# Attempt to bulk amend the 1920 AEBP contract while the 1819 AEBP contract is in draft. This should fail MBR-005
    And   there are no files prefixed '10017597' in the Sharepoint 'AEB-1920-Input-Appendices' folder
    And   there are no files prefixed 'AEB AY 1920 02072019112131 v3_A597' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB AY 1920 02072019112131 v3_A597' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'AEB AY 1920 02072019112131 v3_A597' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB AY 1920 02072019112131 v3_A597.xlsx' exists in the Datafiles folder and UKPRN '10017597' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
#   And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report
    And   'Failed' is displayed in field 'J2' on the 'Contract' tab of the result report

    # MBR-005
    And   '[Contract] This Master Contract cannot have more than one associated Contract in a draft status at the same time' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Check the CONTRACT version, status and dates in CRM. They should not have changed
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017597 | AEBP-5972          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    #
	| 10017597 | AEBP-5971          | 1                     | 0                        | Draft            | Published to Provider     | True          | False               | 01/08/2018        | 31/07/2019      | ?             |
    | 10017597 | ESFA-597           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |




    # Non-Financial Amendment on 1920 AEBP
	
	# Change the date
    Given the override date is '13/07/2019'

	# Clear down any non-financial notifications in CRM
	Given there are no notifications in CRM of type 'Non-Financial Contract Amendment Failed' for UKPRN '10017597'

	# Attempt a non-financial NOTIFICATION amendment against the 1920 AEBP contract while the 1819 AEBP contract is in draft. This should fail MBP-005
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'AEBP-5972' for a non-financial NOTIFICATION contract amendment
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'AEBP-5972' for a non-financial VARIATION contract amendment

    # Check that a notification for MBR-005 has been created and sent to the initiating User 
    Then  there is '1' notification of type 'Non-Financial Contract Amendment Failed' owned by user 'FCS2 Test' which match the following
    | Status | NotificationName                                    | NotificationText                                                                                                                                                                                     |
    | New    | Non-Financial Contract Amendment Failed - AEBP-5972 | Contract AEBP-5972 v1 for provider 10017597 (10017597 Co Ltd) cannot be amended - A draft amendment already exists (or has been initiated) for another contract associated with this Master Contract |

    # Check the CONTRACT version, status and dates in CRM. They should not have changed
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017597 | AEBP-5972          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    #
	| 10017597 | AEBP-5971          | 1                     | 0                        | Draft            | Published to Provider     | True          | False               | 01/08/2018        | 31/07/2019      | ?             |
    | 10017597 | ESFA-597           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |





    # Withdraw the draft 1819 contract

    # Change the date
	Given the override date is '15/07/2019'

	# Withdraw v1 of the 1819 contract 
    When  the next action performed on the latest version of contract 'AEBP-5971' is 'Withdraw On Behalf Of Provider' with reason 'My wife told me to do it' by 'FCS1 Test'

	# Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017597 | AEBP-5972          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2019        | 31/07/2020      | ?             |
    #
    | 10017597 | AEBP-5971          | 1                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/08/2018        | 31/07/2019      | ?             |
    | 10017597 | ESFA-597           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |




    # Issue a non-financial amendment on 1920 AEBP

	# Change the date
    Given the override date is '17/07/2019'

	# Clear down any non-financial notifications in CRM
	Given there are no notifications in CRM of type 'Non-Financial Contract Amendment Failed' for UKPRN '10017597'

	# Issue a non-financial NOTIFICATION amendment against the 1920 AEBP contract while the 1920 AEBP contract is in draft. This should work
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'AEBP-5972' for a non-financial NOTIFICATION contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'AEBP-5972' for a non-financial VARIATION contract amendment

	# Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017597 | AEBP-5972          | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2019        | 31/07/2020      | Variation     |
    | 10017597 | AEBP-5972          | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2019        | 31/07/2020      | ?             |
    #
    | 10017597 | AEBP-5971          | 1                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/08/2018        | 31/07/2019      | ?             |
    | 10017597 | ESFA-597           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |




	# Bulk Revised New 1819 (Fail)

    # Change the date
	Given the override date is '16/07/2019'

	# Bulk 'Revised New' an 1819 AEBP contract. The 1920 AEBP contract is currently draft. This should fail MBR-005
    And   there are no files prefixed '10017597' in the Sharepoint 'AEB-1920-Input-Appendices' folder
    And   there are no files prefixed 'AEB AY 1819 02072019112131 v3_A597_1' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB AY 1819 02072019112131 v3_A597_1' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'AEB AY 1819 02072019112131 v3_A597_1' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB AY 1819 02072019112131 v3_A597_1.xlsx' exists in the Datafiles folder and UKPRN '10017597' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
#   And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report
    And   'Failed' is displayed in field 'J2' on the 'Contract' tab of the result report

    # MBR-005
    And   '[Contract] This Master Contract cannot have more than one associated Contract in a draft status at the same time' is displayed in field 'J2' on the 'Contract' tab of the result report

	# Check the CONTRACT version, status and dates in CRM. These should not have changed
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017597 | AEBP-5972          | 2                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2019        | 31/07/2020      | Variation     |
    | 10017597 | AEBP-5972          | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2019        | 31/07/2020      | ?             |
    #
    | 10017597 | AEBP-5971          | 1                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/08/2018        | 31/07/2019      | ?             |
    | 10017597 | ESFA-597           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |



    # Tidy up
    Then  the override date is reset 

