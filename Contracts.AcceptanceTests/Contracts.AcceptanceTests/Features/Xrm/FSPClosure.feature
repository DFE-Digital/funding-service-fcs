Feature: FSPClosure

@AcceptanceTest @Withdrawn20221103
Scenario: A228 Fail attempting to publish a draft 1516 AGE contract after the FSP has closed (ie Current date is greater than the ContractingActivityCloseDate)
    Given there is no Contract, Task or Workflow data for UKPRN '10017228'
	And   there are no notifications of type 'Publish To Provider Failed'
    And   there are no entries in the DCFS stub table
    And   the override date is reset

    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | AGE-228       |
    
    # Set organisation and advisors
    And   there is no Organisation data for UKPRN '10017228'
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017228 Co Ltd' with UKPRN '10017228' and OrgId 'ORG0017228' and has 'FCS1 Test' as a manager
    And   UPIN '117228' is associated with UKPRN '10017228' in the CRM Organisation table

    And   the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status |
    | 10017228 | 117228 | 10017228 Co Ltd | 0              | Active |

	# Create a contract
    And   the draft contract header details for the latest version of the contract are as follows
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017228 | 10017228 Co Ltd      | SFA-228              | EMPAGE-228     | 1                     |  01/04/2015       |  31/03/2016     | 45213.00      | Contract for Services | 1516   | New          | ORG0017228 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName             | UoPCode | AllocationDescription  | CRMIntent    |
    | 10017228 | EMPAGE-228     | AGE-228       | AGE               | FY                      |  01/04/2015         |  31/03/2016       | 45213.00        |                     |         |                        | New          |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Apr-15   | May-15   | Jun-15   | Jul-15   | Aug-15   | Sep-15   | Oct-15   | Nov-15   | Dec-15   | Jan-16   | Feb-16   | Mar-16   | DeliverableDescription                            | CRMIntent    |
    | EMPAGE-228     | AGE-228       | 1               | 0                     | 1250.00  | 259.00   | 1686.00  | 319.00   | 426.00   | 1837.00  | 3155.00  | 2301.00  | 318.00   | 1652.00  | 2242.00  | 2441.00  | 16-18 Apprenticeship Grant for Employers          | New          |
    | EMPAGE-228     | AGE-228       | 2               | 0                     | 685.00   | 3178.00  | 2774.00  | 2515.00  | 459.00   | 879.00   | 3611.00  | 3189.00  | 1883.00  | 3268.00  | 1461.00  | 3589.00  | 19-24 Apprenticeship Grant for Employers          | New          |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Internally approve the contract
    And   the contract sub-status is updated to 'Internally Approved' for contract 'EMPAGE-228'
 
    # Change the date (FSP close date for AGE1516 is 18/06/0217)
    And   the override date is '19/06/2017'

    # Clear down then put a document in the Merged Docs folder
	And   there are no files prefixed '10017228_EMPAGE-228_v1' in the Sharepoint 'AGE-1516-Output-Merged Document' folder
    And   a copy of the file '10017228_EMPAGE-228_v1.pdf' in 'DataFiles\DocMergeFiles' exists in the Sharepoint 'AGE-1516-Output-Merged Document' folder
    
    # Attempt to publish the contract
	When  the latest version of contract 'EMPAGE-228' is 'Initiate Publish To Provider'

    # Check the service response in the Workflow History
	Then  the latest workflow history service response on contract 'EMPAGE-228' is 'Document Publish Failed' 

	# Check that a CRM notification has been created
	And   there is '1' notification of type 'Publish To Provider Failed' owned by team 'Lead Manager Team' which matches the following
    | Status | NotificationName                      | NotificationText                                                                                                                                                                                              |
    | New    | Publish To Provider Failed-EMPAGE-228 | There was a failure to publish documentation for UKPRN: 10017228 & Contract: EMPAGE-228. This failure was caused by contracting activity having closed for Apprenticeship Grant for Employers 1516 contracts. |

	# Tidy up
	And   the override date is reset

@AcceptanceTest @Withdrawn20221103
Scenario: A241 Attempt to create new 1516 Mainstream contract with a 16-18Apps allocation after the FSP closure date. Fail (FSR-011)
    Given there is no contract data for any UKPRNs beginning with '10017241'
    And   there are no files prefixed '10017241_MAIN' in the Sharepoint 'MAIN-1516-Input-Appendices' folder
    And   there are no files prefixed 'MAIN AY 1516 03042017081149 v2_A241' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'MAIN AY 1516 03042017081149 v2_A241' in the Sharepoint 'Reports' folder
    And   spreadsheet 'MAIN AY 1516 03042017081149 v2_A241.xlsx' exists in the Datafiles folder and UKPRN '10017241' is present in cell 'A2' of the Contract tab

   # FSP closure date is 07/07/2017
    And   the override date is '10/07/2017'    

   # Consume the bulk import file
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  I should see a file for syntax validation report
    And   syntax validation report contains 'Fail'
    And   syntax validation report contains 'Contracting activity has closed for this Funding Type Period'

    # Tidy Up
    And   the override date is reset

@AcceptanceTest @Complete
Scenario: A385 Attempt SFS approval of a 1516 Mainstream contract after the FSP closure date
    Given there is no Contract, Task or Workflow data for UKPRN '10017385'
    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | CL-385        |
 
    And   there is no Organisation data for UKPRN '10017385'
    And   the override date is reset 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017385 Co Ltd' with UKPRN '10017385' and OrgId 'ORG0017385' and has 'FCS1 Test' as a manager
    
    And   the draft contract header details for the latest version of the contract are as follows
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017385 | 10017385 Co Ltd      | SFA-385              | MAIN-385       | 1                     |  01/08/2015       |  31/07/2016     | 4488.00       | Contract for Services | 1516   | New          | ORG0017385 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode | AllocationDescription | CRMIntent |
    | 10017385 | MAIN-385       | CL-385        | CL                | CL1516                  | AY                      | 01/08/2015          | 31/07/2016        | 4488.00         |         |         |                       | New       |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total    | Aug-15   | Sep-15   | Oct-15   | Nov-15   | Dec-15   | Jan-16   | Feb-16   | Mar-16   | Apr-16   | May-16   | Jun-16   | Jul-16   | DeliverableDescription     | CRMIntent    |
    | MAIN-385       | CL-385        | 1               | 0                     | 4488.00  | 540.00   | 495.00   | 234.00   | 602.00   | 545.00   | 36.00    | 594.00   | 228.00   | 329.00   | 480.00   | 34.00    | 371.00   | Community Learning         | New          |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    And   the latest version of contract 'MAIN-385' is in a state of 'Published to Provider'
    
	# FSP closure date is 04/07/2017
	And   the override date is '05/07/2017'

   #
   # Inject an SFS approval message
   #
    When 'External' approval is initiated for contract with master contract number 'SFA-385' and contract number 'MAIN-385' and version number '1'

   #
   # Check that CRM approval has not occurred and an Atom feed approval row has not been written - after waiting 20 seconds
   #
	Then the latest version of contract 'MAIN-385' is in status 'Published to Provider'
	And  the ContractManagement.AtomFeedItem table does not contain an ItemType '0' event for version '1' of actual contract number 'MAIN-385'
		
    # Review worklow history
    And  the following workflow history entries are not present on the latest version of contract 'MAIN-385'
    | Action                 |
    | Manual Approval Failed |

    # Tidy Up
	And   the override date is reset

