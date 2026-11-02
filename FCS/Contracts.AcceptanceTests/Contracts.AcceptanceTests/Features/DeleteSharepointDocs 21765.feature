Feature: DeleteSharepointDocs 21765

@AcceptanceTest @Withdrawn20230123
Scenario: A777 Inject appropriate 16-18Apps docs into Sharepoint folders for v1 and v2 of a 1718 Mainstream contract. Create v3 and bulk update draft. Step through tasks then approve v3. Check Sharepoint folders and Blob storage
    Given there is no Contract, Task or Workflow data for UKPRN '10017777'

    # Cleardown Sharepoint folders
    And   there are no files prefixed '10017777_MAIN' in the Sharepoint 'MAIN-1718-Input-Appendices' folder
    And   there are no files prefixed '10017777_MAIN' in the Sharepoint 'MAIN-1718-Input-Terms and Conditions' folder
    And   there are no files prefixed '10017777_MAIN' in the Sharepoint 'MAIN-1718-Output-Merged Document' folder
    And   there are no files prefixed '10017777_MAIN' in the Sharepoint 'MAIN-1718-Output-Documents for Publication' folder

    # Cleardown transient Sharepoint folders
    And   there are no files prefixed 'MAIN AY 1718 26042018093140 v2_A777' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'MAIN AY 1718 26042018093140 v2_A777' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'MAIN AY 1718 26042018093140 v2_A777' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'MAIN AY 1718 26042018093140 v2_A777' in the Sharepoint 'Reports' folder

    # Clear down the blob document archive and the associated ArchiveDocument control table (DocumentsDomain.ArchivedDocument)
    And   there is no data in the document archive or the associated control table

    # Inject dummy files into Sharepoint for v1
    And   a file with filename '10017777_MAIN-777_v1.pdf' is created in 'MAIN-1718-Input-Appendices'
    And   a file with filename '10017777_MAIN-777_v1.pdf' is created in 'MAIN-1718-Output-Documents for Publication'

    # Inject dummy files into Sharepoint for v2
    And   a file with filename '10017777_MAIN-777_v2.pdf' is created in 'MAIN-1718-Input-Appendices'
    And   a file with filename '10017777_MAIN-777_v2.pdf' is created in 'MAIN-1718-Output-Documents for Publication'

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017777' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017777 Co Ltd' with UKPRN '10017777' and OrgId 'ORG0017777' and has 'FCS1 Test' as a manager 
    And   UPIN '117777' is associated with UKPRN '10017777' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017777 | 117777 | 10017777 Co Ltd | 0              | Active | Yes           | AA017777      | ?             | 

    # Change the date
    And   the override date is '15/07/2017' 
 
    # Create contract v3
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017777 | 10017777 Co Ltd      | ESFA-777             | MAIN-777       | 3                     | 01/08/2017        | 31/07/2018      | 23086.00      |                                | Contract for Services | 1718   | New          | ORG0017777 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode    | AllocationDescription | CRMIntent    |
    | 10017777 | MAIN-777       | 16AP-777      | 16-18 APPS        | 16-18APPS1718           | AY                      | 01/08/2017          | 31/07/2018        | 23086.00        |         |            |                       | New          |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription               | CRMIntent    |
    | 10017777 | MAIN-777       | 16AP-777      | 2               | 0                     | 23086.00  | 2926.00  | 1658.00  | 2922.00  | 1355.00  | 1750.00  | 2919.00  | 3353.00  | 2090.00  | 1231.00  | 279.00   | 562.00   | 2041.00  | 16-18 Apprenticeships Total Funding  | New          |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Bulk import to do an update draft on v3 of the contract to create v3 docs in Sharepoint naturally
    And   spreadsheet 'MAIN AY 1718 26042018093140 v2_A777.xlsx' exists in the Datafiles folder and UKPRN '10017777' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Inject a dummy file into Sharepoint ready for the document merge
    Given   a file with filename '10017777_MAIN-777_61.pdf' is created in 'MAIN-1718-Input-Terms and Conditions'

    # Complete an existing open Task (Initiate Document Merge -> Review Contract Details)
    When  the following open Task currently linked to version '3' of contract 'MAIN-777' for provider '10017777' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Initiate Document Merge          | Document Management Team |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '3' of contract 'MAIN-777' for provider '10017777'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Review Contract Details          | 10017777 - 10017777 Co Ltd Please review the contract       | MAIN-777       | FCS2 Test                | Contract Advisers Team   | Open            | Not Started      |

    # Complete an existing open Task (Review Contract Details -> Confirm Internal Approval)
    When  the following open Task currently linked to version '3' of contract 'MAIN-777' for provider '10017777' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Review Contract Details          | FCS2 Test               |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '3' of contract 'MAIN-777' for provider '10017777'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Internal Approval        | 10017777 - 10017777 Co Ltd                                  | MAIN-777       | FCS1 Test                | Contract Managers Team   | Open            | Not Started      |

    # Complete an existing open Task (Confirm Internal Approval -> Confirm Publication to Provider)
    When  the following open Task currently linked to version '3' of contract 'MAIN-777' for provider '10017777' is triggered by User 'FCS1 Test'
    | Task                             | Owner                    |
    | Confirm Internal Approval        | FCS1 Test               |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '3' of contract 'MAIN-777' for provider '10017777'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Publication to Provider  | 10017777 - 10017777 Co Ltd                                  | MAIN-777       | Lead Manager Team         | ?                        | Open            | Not Started      |

    # Complete an existing open Task (Confirm Publication to Provider -> End)
    When  the following open Task currently linked to version '3' of contract 'MAIN-777' for provider '10017777' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Confirm Publication to Provider  | Lead Manager Team        |

    # Check that the Tasks on the contract are all marked as completed
    Then  the following Tasks are present against version '3' of contract 'MAIN-777' for provider '10017777'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Publication to Provider  | 10017777 - 10017777 Co Ltd                                  | MAIN-777       | Lead Manager Team         | ?                        | Completed       | Completed        |
    | Confirm Internal Approval        | 10017777 - 10017777 Co Ltd                                  | MAIN-777       | FCS1 Test                | Contract Managers Team   | Completed       | Completed        |
    | Review Contract Details          | 10017777 - 10017777 Co Ltd Please review the contract       | MAIN-777       | FCS2 Test                | Contract Advisers Team   | Completed       | Completed        |
    | Initiate Document Merge          | 10017777 - 10017777 Co Ltd Awaiting documentation           | MAIN-777       | Document Management Team  | ?                        | Completed       | Completed        |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017777 | MAIN-777           | 3                     | 1                        | Draft            | Published to Provider     | True          | False               | 01/08/2017        | 31/07/2018      | ?             |
    | 10017777 | MAIN-777           | 3                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2017        | 31/07/2018      | ?             |
    | 10017777 | ESFA-777           | 3                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check the 'Documents for Publication' folder prior to approval
    And   there is '1' file prefixed '10017777_MAIN-777_v1' in the Sharepoint 'MAIN-1718-Output-Documents for Publication' folder
    And   there is '1' file prefixed '10017777_MAIN-777_v2' in the Sharepoint 'MAIN-1718-Output-Documents for Publication' folder
    And   there is '1' file prefixed '10017777_MAIN-777_v3' in the Sharepoint 'MAIN-1718-Output-Documents for Publication' folder

    # Check the archive prior to contract approval
    Then  there are '0' files prefixed '10017777' in the document archive and the associated control table

    # Change the date
    And   the override date is '19/07/2017'

    # Inject an SFS approval message. This should also trigger removal of Sharepoint files
    When  a contract approval message is received from SFS for version '3' actual MasterContractNumber 'ESFA-777' and actual ContractNumber 'MAIN-777'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017777 | MAIN-777           | 3                     | 1                        | Approved         | Approved                  | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017777 | MAIN-777           | 3                     | 0                        | Superseded Draft | ?                         | ?             | False               | 01/08/2017        | 31/07/2018      | ?             |
    | 10017777 | ESFA-777           | 3                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check what is where in Sharepoint after approval of v3
    And   there are '0' files prefixed '10017777_MAIN-777_v1' in the Sharepoint 'MAIN-1718-Input-Appendices' folder
    And   there are '0' files prefixed '10017777_MAIN-777_v2' in the Sharepoint 'MAIN-1718-Input-Appendices' folder
    And   there are '0' files prefixed '10017777_MAIN-777_v3' in the Sharepoint 'MAIN-1718-Input-Appendices' folder

    And   there are '0' files prefixed '10017777_MAIN-777' in the Sharepoint 'MAIN-1718-Input-Terms and Conditions' folder
    And   there are '0' files prefixed '10017777_MAIN-777' in the Sharepoint 'MAIN-1718-Output-Merged Document' folder

    And   there are '0' files prefixed '10017777_MAIN-777_v1' in the Sharepoint 'MAIN-1718-Output-Documents for Publication' folder
    And   there are '0' files prefixed '10017777_MAIN-777_v2' in the Sharepoint 'MAIN-1718-Output-Documents for Publication' folder
    And   there are '0' files prefixed '10017777_MAIN-777_v3' in the Sharepoint 'MAIN-1718-Output-Documents for Publication' folder

    # Check the archive after approval of v3 
    And   there is '1' file prefixed '10017777_MAIN-777_v1' in the document archive and the associated control table
    And   there is '1' file prefixed '10017777_MAIN-777_v2' in the document archive and the associated control table
    And   there is '1' file prefixed '10017777_MAIN-777_v3' in the document archive and the associated control table


    # Tidy up
    And  the override date is reset 
	
@AcceptanceTest @Withdrawn20260521
Scenario: A778 Create and approve 1718 16-18Apps contract. Bulk upload a NOTIFICATION amendment. Step through tasks to auto-approval. Check Sharepoint folders and Blob stotage
    Given there is no Contract, Task or Workflow data for UKPRN '10017778'

    # Cleardown Sharepoint folders
    And   there are no files prefixed '10017778_MAIN' in the Sharepoint 'MAIN-1718-Input-Appendices' folder
    And   there are no files prefixed '10017778_MAIN' in the Sharepoint 'MAIN-1718-Input-Terms and Conditions' folder
    And   there are no files prefixed '10017778_MAIN' in the Sharepoint 'MAIN-1718-Output-Merged Document' folder
    And   there are no files prefixed '10017778_MAIN' in the Sharepoint 'MAIN-1718-Output-Documents for Publication' folder

    # Cleardown transient Sharepoint folders
    And   there are no files prefixed 'MAIN AY 1718 26042018165029 v2_A778' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'MAIN AY 1718 26042018165029 v2_A778' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'MAIN AY 1718 26042018165029 v2_A778' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'MAIN AY 1718 26042018165029 v2_A778' in the Sharepoint 'Reports' folder

    # Clear down the blob document archive and the associated ArchiveDocument control table (DocumentsDomain.ArchivedDocument)
    And   there is no data in the document archive or the associated control table

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017778' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017778 Co Ltd' with UKPRN '10017778' and OrgId 'ORG0017778' and has 'FCS1 Test' as a manager 
    And   UPIN '117778' is associated with UKPRN '10017778' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017778 | 117778 | 10017778 Co Ltd | 0              | Active | Yes           | AA017778      | ?             | 

    # Change the date
    And   the override date is '15/07/2017' 
 
    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017778 | 10017778 Co Ltd      | ESFA-778             | MAIN-778       | 1                     | 01/08/2017        | 31/07/2018      | 23086.00      |                                | Contract for Services | 1718   | New          | ORG0017778 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode    | AllocationDescription | CRMIntent    |
    | 10017778 | MAIN-778       | 16AP-778      | 16-18 APPS        | 16-18APPS1718           | AY                      | 01/08/2017          | 31/07/2018        | 23086.00        |         |            |                       | New          |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription               | CRMIntent    |
    | 10017778 | MAIN-778       | 16AP-778      | 2               | 0                     | 23086.00  | 2926.00  | 1658.00  | 2922.00  | 1355.00  | 1750.00  | 2919.00  | 3353.00  | 2090.00  | 1231.00  | 279.00   | 562.00   | 2041.00  | 16-18 Apprenticeships Total Funding  | New          |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Check that the deliverables have all been created in CRM   
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract 'MAIN-778'

    # Publish v1
    And   the latest version of contract 'MAIN-778' is in a state of 'Published to Provider'

    # Inject dummy files into Sharepoint for v1
    And   a file with filename '10017778_MAIN-778_v1.pdf' is created in 'MAIN-1718-Input-Appendices'
    And   a file with filename '10017778_MAIN-778_v1.pdf' is created in 'MAIN-1718-Output-Documents for Publication'




    # Change the date
    And   the override date is '19/07/2017'

    # Inject an SFS contract approval message
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-778' and actual ContractNumber 'MAIN-778'

    # Check what is where in Sharepoint after approving v1
    Then  there are '0' files prefixed '10017778_MAIN-778_v1' in the Sharepoint 'MAIN-1718-Input-Appendices' folder
    And   there are '0' files prefixed '10017778_MAIN-778' in the Sharepoint 'MAIN-1718-Input-Terms and Conditions' folder
    And   there are '0' files prefixed '10017778_MAIN-778' in the Sharepoint 'MAIN-1718-Output-Merged Document' folder

    # Check the archive after approving v1 
    Then  there is '1' file prefixed '10017778_MAIN-778_v1' in the document archive and the associated control table




    # Change the date
    Given the override date is '22/07/2017'

    # Bulk upload a NOTIFICATION amendment to create v2
    And   spreadsheet 'MAIN AY 1718 26042018165029 v2_A778.xlsx' exists in the Datafiles folder and UKPRN '10017778' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Create two dummy Terms and Conditions files for v2
    Given there are no files prefixed '10017778_MAIN-778' in the Sharepoint 'MAIN-1718-Input-Terms And Conditions' folder
    And   a file with filename '10017778_MAIN-778_11.pdf' is created in 'MAIN-1718-Input-Terms And Conditions'
    And   a file with filename '10017778_MAIN-778_61.pdf' is created in 'MAIN-1718-Input-Terms And Conditions'

    # Complete an existing open Task (Initiate Document Merge -> Review Contract Details)
    When  the following open Task currently linked to version '2' of contract 'MAIN-778' for provider '10017778' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Initiate Document Merge          | Document Management Team |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '2' of contract 'MAIN-778' for provider '10017778'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Review Contract Details          | 10017778 - 10017778 Co Ltd Please review the contract       | MAIN-778       | FCS2 Test                | Contract Advisers Team   | Open            | Not Started      |

    # Complete an existing open Task (Review Contract Details -> Confirm Internal Approval)
    When  the following open Task currently linked to version '2' of contract 'MAIN-778' for provider '10017778' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Review Contract Details          | FCS2 Test               |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '2' of contract 'MAIN-778' for provider '10017778'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Internal Approval        | 10017778 - 10017778 Co Ltd                                  | MAIN-778       | FCS1 Test                | Contract Managers Team   | Open            | Not Started      |

    # Complete an existing open Task (Confirm Internal Approval -> Confirm Publication to Provider)
    When  the following open Task currently linked to version '2' of contract 'MAIN-778' for provider '10017778' is triggered by User 'FCS1 Test'
    | Task                             | Owner                    |
    | Confirm Internal Approval        | FCS1 Test               |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '2' of contract 'MAIN-778' for provider '10017778'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Publication to Provider  | 10017778 - 10017778 Co Ltd                                  | MAIN-778       | Lead Manager Team         | ?                        | Open            | Not Started      |

    # Ensure Month-End is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

	# Check the folders prior to publication (and auto-approval)
    And   there is '1' file prefixed '10017778_MAIN-778_v2' in the Sharepoint 'MAIN-1718-Input-Appendices' folder
	And   there are '0' files prefixed '10017778_MAIN-778_v2' in the Sharepoint 'MAIN-1718-Input-Terms And Conditions' folder
 
    # Complete an existing open Task (Confirm Publication to Provider -> End)
    When  the following open Task currently linked to version '2' of contract 'MAIN-778' for provider '10017778' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Confirm Publication to Provider  | Lead Manager Team        |

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017778 | MAIN-778           | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2017        | 31/07/2018      | Notification  |
    | 10017778 | MAIN-778           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2017        | 31/07/2018      | ?             |
    | 10017778 | ESFA-778           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |



    # Change the date
    And   the override date is '29/07/2017'

    # Check what is where in Sharepoint after the auto-approval of v2
    And   there are '0' files prefixed '10017778_MAIN-778_v1' in the Sharepoint 'MAIN-1718-Input-Appendices' folder
    And   there are '0' files prefixed '10017778_MAIN-778_v2' in the Sharepoint 'MAIN-1718-Input-Appendices' folder

    And   there are '0' files prefixed '10017778_MAIN-778' in the Sharepoint 'MAIN-1718-Input-Terms and Conditions' folder
    And   there are '0' files prefixed '10017778_MAIN-778' in the Sharepoint 'MAIN-1718-Output-Merged Document' folder

    And   there are '0' files prefixed '10017778_MAIN-778_v1' in the Sharepoint 'MAIN-1718-Output-Documents for Publication' folder
    And   there is '1' file prefixed '10017778_MAIN-778_v2' in the Sharepoint 'MAIN-1718-Output-Documents for Publication' folder

    # Check the archive after approving v2
    And   there is '1' file prefixed '10017778_MAIN-778_v1' in the document archive and the associated control table
    And   there are '0' files prefixed '10017778_MAIN-778_v2' in the document archive and the associated control table



    # Tidy up
    And  the override date is reset 
   