Feature: CreateLevyContractFromRoATPdata 18222

@AcceptanceTest @Withdrawn20210115
Scenario: A880 Base test to consume 10 INITIATED Levy events for 6 active and 4 unknown providers. Create contracts and publish docs for 6 UKPRNs. Check Atom feed.
    Given there is no contract data in CRM for any UKPRNs prefixed '4001'
	And   there is no contract data in CRM for any UKPRNs prefixed '4002'

	And   there is no Organisation data in the Organisation Service for '4' consecutive UKPRNs commencing at '40020001'
    And   there is active Organisation data for '6' consecutive UKPRNs commencing at '40010001'

    And   Remove and Recreate Sharepoint Document Library 'LEVY-1799-Input-Appendices'
    And   Remove and Recreate Sharepoint Document Library 'LEVY-1799-Output-Documents for Publication'

    And   there are no ItemType '1' events in the ContractManagement.AtomFeedItem table with a BusinessKey prefixed 'APPLEVY'

    And   the PaaS MonthEndIsRunning indicator is set to 'False'
    And   there are no DAS engagement events stored in FCS
    And   the override date is reset

    #
    # Clear down stub, inject event data from a file and process into CRM 
    #
	And   there is no Levy event data in the Engagement Events table for providers prefixed '4001'
	And   there is no Levy event data in the Engagement Events table for providers prefixed '4002'
    And   there is no Levy event data in the DAS agreement stub
    And   Levy event data from 'DataFiles\A880.txt' is added to the DAS agreement stub
    When  the Levy event data is pulled from the DAS agreement stub

    #
    # Check the correct number of events have been parked
    #
    Then  there is unprocessed PIMS-related event data in the Engagement Events table for '4' UKPRNs prefixed '4002' and wait a maximum of '20' minutes

    #
    # Check the correct number of draft contracts have been created in CRM
    #
    And   there are '6' draft Levy contracts in CRM for UKPRNs prefixed '4001' and wait a maximum of '10' minutes
	And   there are '0' draft Levy contracts in CRM for UKPRNs prefixed '4002' and wait a maximum of '10' minutes

    #
    # Check that contract documentation in Sharepoint is for the correct number of providers
    #
    And   there are '6' files in Sharepoint folder 'LEVY-1799-Output-Documents for Publication' prefixed '4001'

    #
    # Check Atom feed data for ItemType one (published) events
    #
    And   the ContractManagement.AtomFeedItem table contains '6' ItemType '1' events with a BusinessKey prefixed 'APPLEVY'

@AcceptanceTest @Withdrawn20210115
Scenario: A884 Consume 20 INITIATED Levy events. Create contracts and publish docs for 10. Park 10. Check Atom feed. Then consume the parked data.
    Given there is no contract data in CRM for any UKPRNs prefixed '4005'
    And   there is no contract data in CRM for any UKPRNs prefixed '4006'

    And   there is no Organisation data in the Organisation Service for '10' consecutive UKPRNs commencing at '40060001'
    And   there is active Organisation data for '10' consecutive UKPRNs commencing at '40050001'

    And   Remove and Recreate Sharepoint Document Library 'LEVY-1799-Input-Appendices'
    And   Remove and Recreate Sharepoint Document Library 'LEVY-1799-Output-Documents for Publication'

    And   there are no ItemType '1' events in the ContractManagement.AtomFeedItem table with a BusinessKey prefixed 'APPLEVY'

    And   the PaaS MonthEndIsRunning indicator is set to 'False'
    And   there are no DAS engagement events stored in FCS
    And   the override date is reset


    # Stage 1: Consume event data for 20 UKPRNs. Create 10 contracts and park the other 10 events

    #
    # Clear down stub, inject event data from a file and process into 
    #
    And   there is no Levy event data in the Engagement Events table for providers prefixed '4005'
    And   there is no Levy event data in the Engagement Events table for providers prefixed '4006'
    And   there is no Levy event data in the DAS agreement stub
    And   Levy event data from 'DataFiles\A884.txt' is added to the DAS agreement stub
    When  the Levy event data is pulled from the DAS agreement stub

    #
    # Check the correct number of events have been parked
    #
    Then  there is unprocessed PIMS-related event data in the Engagement Events table for '0' UKPRNs prefixed '4005' and wait a maximum of '3' minutes
    And   there is unprocessed PIMS-related event data in the Engagement Events table for '10' UKPRNs prefixed '4006' and wait a maximum of '3' minutes

    #
    # Check the correct number of draft contracts have been created in CRM
    #
    And   there are '10' draft Levy contracts in CRM for UKPRNs prefixed '4005' and wait a maximum of '3' minutes
    And   there are '0' draft Levy contracts in CRM for UKPRNs prefixed '4006' and wait a maximum of '3' minutes
	 
    #
    # Check that contract documentation in Sharepoint is for the correct number of providers
    #
    And   there are '10' files in Sharepoint folder 'LEVY-1799-Output-Documents for Publication' prefixed '4005'
    And   there are '0' files in Sharepoint folder 'LEVY-1799-Output-Documents for Publication' prefixed '4006'

    #
    # Check Atom feed data for ItemType one (published) events
    #
    And   the ContractManagement.AtomFeedItem table contains '10' ItemType '1' events with a BusinessKey prefixed 'APPLEVY'

    
    # Stage 2: Consume data for the 10 UKPRNs parked earlier

    Given there is active Organisation data for '10' consecutive UKPRNs commencing at '40060001'
    And   there is no Levy event data in the DAS agreement stub
    When  the Levy event data is pulled from the DAS agreement stub

    #
    # Check that the data is no longer marked as parked
    #
    Then  there is unprocessed PIMS-related event data in the Engagement Events table for '0' UKPRNs prefixed '4005' and wait a maximum of '3' minutes
    And   there is unprocessed PIMS-related event data in the Engagement Events table for '0' UKPRNs prefixed '4006' and wait a maximum of '3' minutes

    #
    # Check the correct number of draft contracts have been created in CRM
    #
    And   there are '10' draft Levy contracts in CRM for UKPRNs prefixed '4005' and wait a maximum of '3' minutes
    And   there are '10' draft Levy contracts in CRM for UKPRNs prefixed '4006' and wait a maximum of '3' minutes

    #
    # Check that contract documentation in Sharepoint is for the correct number of providers
    #
    And   there are '10' files in Sharepoint folder 'LEVY-1799-Output-Documents for Publication' prefixed '4005'
    And   there are '10' files in Sharepoint folder 'LEVY-1799-Output-Documents for Publication' prefixed '4006'

    #
    # Check Atom feed data for ItemType one (published) events
    #
    And   the ContractManagement.AtomFeedItem table contains '20' ItemType '1' events with a BusinessKey prefixed 'APPLEVY'

