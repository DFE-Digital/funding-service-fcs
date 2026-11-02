Feature: Merge Documentation And Upload on SharePoint
	Once a contract is created in CRM and Appendices is available on SharePoint
	When Terms and Conditions docs is uploaded on SharePoint
	And the merge is triggered from CRM
	Then both Appendices and T&C is merged and oredered correctly on Sharepoint

# The guts of B030 are now in A731

@AcceptanceTest @Superceded
@DocMerge @8859
@MergeSinglePageContractRejectWithNoTsandCs
Scenario: B030 DOCM3_Reject Merge if no document uploaded and update CRM
	Given there is no Contract, Task or Workflow data for UKPRN '22228860'
    And   there is no Organisation data for UKPRN '22228860'
   #And there is no 'Document Merge Failed' notification for 'MAIN-862'
	And   there are no notifications of type 'Document Merge Failed'
    And   caseload advisor 'FCS2 Test' is assigned to provider 'DOCMERGER Ltd' with UKPRN '22228860' and OrgId 'ORG2228860' and has 'FCS1 Test' as a manager
   
   And   the draft contract header details for the latest version of the contract are as follows
    | UKPRN    | LegalName     | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent | OrgId      |
    | 22228860 | DOCMERGER Ltd | SFA-862              | MAIN-862       | 1                     | 01/08/2015        | 31/07/2016      | 1795.00       | Contract for Services | 1516   | New       | ORG2228859 |
	
	And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName | UoPCode | AllocationDescription | CRMIntent |
    | 22228860 | MAIN-862       | CL-859        | CL                | AY                      | 01/08/2015          | 31/07/2016        | 1795.00         |         |         |                       | New       |
	
	And   the draft contract deliverables details for the latest version of the contract are as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-15 | Sep-15 | Oct-15 | Nov-15 | Dec-15 | Jan-16 | Feb-16 | Mar-16 | Apr-16 | May-16 | Jun-16 | Jul-16 | DeliverableDescription | CRMIntent |
    | MAIN-862       | CL-859        | 1               | 0                     | 53.00  | 44.00  | 34.00  | 26.00  | 744.00 | 12.00  | 14.00  | 47.00  | 739.00 | 24.00  | 36.00  | 22.00  | Community Learning     | New       |
	
	And  the contract exists in CRM
	And  the contract status is set to 'Draft'
	And  the contract sub-status is set to 'Awaiting Documentation'
	And  the contract is set with documentation required
	And  a file with filename '22228860_MAIN-862_v1.pdf' is created in the location 'MAIN-1516-Input-Appendices'
	And  a file named '22228860_MAIN-862_01.pdf' is NOT in the location 'Main-1516-Input-Terms And Conditions' 
	When the latest version of contract 'MAIN-862' is 'Initiate Document Merge'
	And  the contract sub-status is set to 'Document Merge In Progress'
	And  if a debugger is attached a ReleaseForReviewCommand with MasterContractNumber 'SFA-862' and ContractNumber 'MAIN-862' is sent
	Then a file named '22228860_MAIN-862_v1.pdf' is NOT in the location 'Main-1516-Output-Merged Document' 
	And  the contract sub-status is now set to 'Awaiting Documentation'

    # Check the current state of the Tasks for this contract
    And   the following Tasks are present against version '1' of contract 'MAIN-862' for provider '22228860'
    | Task                                       | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Initiate Document Merge                    | 22228860 - DOCMERGER Ltd Awaiting documentation             | MAIN-862       | Document Management Team  | ?                        | Open            | Not Started      |

	# Check that a notification has been created
	And   there is '1' notification of type 'Document Merge Failed' owned by team 'Document Management Team' which matches the following 
    | Status | NotificationName                | NotificationText                                                                                                                                                  |
    | New    | Document Merge Failed-MAIN-862  | Automatic merge cannot occur where documentation has not been uploaded for contract UKPRN: 22228860 & Contract: MAIN-862. Please upload documentation and re-try  |

	# Tidy Up
	And   the override date is reset
	  