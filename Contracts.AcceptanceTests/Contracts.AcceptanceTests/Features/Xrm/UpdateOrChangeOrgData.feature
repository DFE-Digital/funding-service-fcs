Feature: Update/Change Org Data

@AcceptanceTest @Complete 
@UpdateChangeOrgData
Scenario: B013 Initiating Organisation Update should update a changed organisation name and status when the organisation exists in CRM
	Given there is no Organisation data for UKPRN '10009987'
	And   there is no Organisation data for UKPRN '10009988'

	And   the following Organisations exist in CRM
	| UKPRN    | Name                   | Status   |
	| 10009987 | Learn Direct           | Active   |
	| 10009988 | Westminster College    | Active   |

	And   there are no CRM Notifications for the following UKPRNs
	| UKPRN    |
    | 10009987 |
    | 10009988 |
	
	And   the following Organisations exist in the FCT Organisation Service
	| UKPRN    | UPIN   | Name                                     | SequenceNumber | Status   |
	| 10009987 | 105996 | Learn Direct                             | 0              | Active   |
	| 10009988 | 105995 | Westminster College                      | 0              | Active   |
	
	When  the InitOrganisationUpdate command is sent
	
	Then  the Organisations are updated in CRM as follows
	| UKPRN    | Name                                      | Status    |
	| 10009987 | Learn Direct LTD                          | Inactive  |
	| 10009988 | Westminster College and Learning Academy  | Dissolved |

	And   the following notifications of type 'Provider Details Updated' related to the 'Contract Managers Team' are present in CRM
	| UKPRN    | Name						          | Message															                  |
	| 10009987 | Provider Details Updated - 10009987  | Status has been updated to Inactive for provider 10009987 (Learn Direct)		  |
	| 10009988 | Provider Details Updated - 10009988  | Status has been updated to Dissolved for provider 10009988 (Westminster College)  |
	| 10009987 | Provider Details Updated - 10009987  | Name has been updated for provider 10009987 (Learn Direct)						  |
	| 10009988 | Provider Details Updated - 10009988  | Name has been updated for provider 10009988 (Westminster College)				  |

