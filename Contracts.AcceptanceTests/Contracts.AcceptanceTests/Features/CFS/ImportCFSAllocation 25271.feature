Feature: ImportCFSAllocation 25271

@AcceptanceTest @Withdrawn20201209
Scenario: A112 Retrieve 1819 LOANS data from CFS for one UKPRN for a 7mth allocation and save in CRM. Org data exists in CRM and PaaS. No assigned Caseload. Mark as Ready for Release. Check CRM
    Given there is no Contract, Task or Workflow data for UKPRN '10017112' 
	And   the Allocation Delivery Monitoring Service atom feed is empty
    And   the Contract Management atom feed is empty
	And   there are no files prefixed '10017112' in the Sharepoint 'LOANS-1819-Input-Appendices' folder

#   # Set organisation and advisors
#   And   there is no Organisation data for UKPRN '10017112'
#   And   caseload advisor 'FCS2 Test' is assigned to provider '10017112 Co Ltd' with UKPRN '10017112' and OrgId 'ORG0017112' and has 'FCS1 Test' as a manager


    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode |
    | 10017112 | 701112 | 10017112 Co Ltd | 0              | In Administration     | Yes           | AA017112      | ?             | 2 Ambassador House     | Wolseley Road          | ?                      | ?                      | Harrow                 | Middlesex              | HA3 5RT  |


    # Put the same Provider data in the CRM Organisation table J057
    And   the following Organisations exist in CRM
    | OrgId      | UKPRN    | UPIN   | Name            | Status                | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode |
    | ORG0017112 | 10017112 | 701112 | 10017112 Co Ltd | In Administration     | AA017112      | ?             | 2 Ambassador House     | Wolseley Road          | ?                      | ?                      | Harrow                 | Middlesex              | HA3 5RT  |



    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Clear down the feed control/audit table in PaaS
    And   there is no data in the AllocationNotifications table for the following UKPRNs
    | UKPRN    | 
    | 10017112 |


    # Clear down CRM Allocations data
    And   there is no data in the Allocations, AllocationPeriods or AllocationHistory tables in CRM for the following UKPRNs
    | UKPRN    | 
    | 10017112 |

    # Populate the CFS stub
    Given the following Provider, Allocation and Profile details are either assumed or available in the CFS stub
    | ContractingUKPRN | AllocationRef     | DeliveryUKPRN | ContractRequired | LegalName        | FundingStreamPeriodCode | DeliverableCode | FundingType | FundingPeriod | MajorVersion | MinorVersion | StartDate  | EndDate    | Status        | TotalValue | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | 
    | 10017112         | 11201-ALLF005     | ?             | Y                | 10017112 Co Ltd  | ALLF1819                | 5               | LOANS       | AY1819        | 1            | 5            | 01/08/2018 | 31/07/2019 | Published     | 22506.00   | 1174.00  | 2000.00  | 930.00   | 1936.00  | 1122.00  | 1359.00  | 2853.00  | 2168.00  | 2020.00  | 1667.00  | 2725.00  | 2552.00  | 



	# Process the stub data into CRM
    
	# Read control\header data from stub
   #When  the FCT system consumes the CFS data
    When  the feed-reading process is started

    # Has the stub control data arrived in ContractRequest.AllocationNotification
    And   the header data for the following UKPRNs is present in the AllocationNotification table
    | UKPRN    |
    | 10017112 |

    # Stub data is processed into CRM  
    And   the CFS stub data is processed into CRM



    # Check Allocations in CRM
    Then  the following Allocations details are present in CRM
    | ContractingUKPRN | AllocationRef     | ContractingProvider | DeliverableCode | DeliverableName                                                 | TotalValue | StartDate  | EndDate    | Status              | SubStatus           | FundingStreamPeriodCode | FundingType | FundingPeriod | Owner                | MajorVersion | MinorVersion | DeliveryUKPRN | DeliveryProvider |
    | 10017112         | 11201-ALLF005     | 10017112 Co Ltd     | 5               | Advanced Learner Loans Facility                                 | 22506.00   | 01/08/2018 | 31/07/2019 | Pre-Release         | In Review           | ALLF1819                | LOANS       | AY1819        | CRM Integration      | 1            | 5            | ?             | ?                | 

    # Check the row count in the CRM Allocations table
    And   there is '1' row in the Allocations table in CRM for UKPRN '10017112'

    # Check AllocationPeriods in CRM
    Then  the following AllocationPeriods details are present in CRM
    | ContractingUKPRN | AllocationRef     | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Owner                |
    | 10017112         | 11201-ALLF005     | 22506.00  | 1174.00  | 2000.00  | 930.00   | 1936.00  | 1122.00  | 1359.00  | 2853.00  | 2168.00  | 2020.00  | 1667.00  | 2725.00  | 2552.00  | CRM Integration      | 

    # Check the row count in the CRM AllocationPeriods table
    And   there are '12' rows in the AllocationPeriods table in CRM for UKPRN '10017112'

    # Check AllocationHistory in CRM
    Then  the following AllocationHistory details are present in CRM
    | ContractingUKPRN | AllocationRef     | Action                       | NewStatus           | NewSubStatus        | PreviousStatus      | PreviousSubStatus   | CompletedBy          |
    | 10017112         | 11201-ALLF005     | Record Imported              | Pre-Release         | In Review           | ?                   | ?                   | CRM Integration      | 

    # Check the row count in the CRM AllocationHistory table
    And   there is '1' row in the AllocationHistory table in CRM for UKPRN '10017112'




    # Select Allocations in CRM which are now ready for release (25310)
    When  the following Allocations are selected for release and the appropriate CRM workflow is triggered
    | ContractingUKPRN | AllocationRef     |
    | 10017112         | 11201-ALLF005     |

    # Check Allocations in CRM
    Then  the following Allocations details are present in CRM
    | ContractingUKPRN | AllocationRef     | ContractingProvider | DeliverableCode | DeliverableName                                                 | TotalValue | StartDate  | EndDate    | Status              | SubStatus           | FundingStreamPeriodCode | FundingType | FundingPeriod | Owner                | MajorVersion | MinorVersion | DeliveryUKPRN | DeliveryProvider |
    | 10017112         | 11201-ALLF005     | 10017112 Co Ltd     | 5               | Advanced Learner Loans Facility                                 | 22506.00   | 01/08/2018 | 31/07/2019 | Pre-Release         | Ready for Release   | ALLF1819                | LOANS       | AY1819        | CRM Integration      | 1            | 5            | ?             | ?                | 

    # Check the row count in the CRM Allocations table
    And   there is '1' row in the Allocations table in CRM for UKPRN '10017112'

    # Check AllocationHistory in CRM
    Then  the following AllocationHistory details are present in CRM
    | ContractingUKPRN | AllocationRef     | Action                       | NewStatus           | NewSubStatus        | PreviousStatus      | PreviousSubStatus   | CompletedBy          |
    | 10017112         | 11201-ALLF005     | Confirm Ready for Release    | Pre-Release         | Ready for Release   | Pre-Release         | In Review           | CRM Integration      | 
    | 10017112         | 11201-ALLF005     | Record Imported              | Pre-Release         | In Review           | ?                   | ?                   | CRM Integration      | 

    # Check the row count in the CRM AllocationHistory table
    And   there are '2' rows in the AllocationHistory table in CRM for UKPRN '10017112'



    # Tidy up
    And   the override date is reset

@AcceptanceTest @Withdrawn20201209
Scenario: A113 Retrieve 1819 LOANS data from CFS for one UKPRN and save in CRM. Org data exists in CRM and PaaS. No assigned Caseload. Stub total error. Mark as Ready for Release. Check CRM
    Given there is no Contract, Task or Workflow data for UKPRN '10017113' 
	And   the Allocation Delivery Monitoring Service atom feed is empty
    And   the Contract Management atom feed is empty
	And   there are no files prefixed '10017113' in the Sharepoint 'LOANS-1819-Input-Appendices' folder

#   # Set organisation and advisors
#   And   there is no Organisation data for UKPRN '10017113'
#   And   caseload advisor 'FCS2 Test' is assigned to provider '10017113 Co Ltd' with UKPRN '10017113' and OrgId 'ORG0017113' and has 'FCS1 Test' as a manager


    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode |
    | 10017113 | 701113 | 10017113 Co Ltd | 0              | Provider Under Change | Yes           | AA017113      | ?             | 4 Red Lion Court       | Alexandra Road         | ?                      | ?                      | Hounslow               | Middlesex              | TW3 1JS  |

    # Put the same Provider data in the CRM Organisation table J057
    And   the following Organisations exist in CRM
    | OrgId      | UKPRN    | UPIN   | Name            | Status                | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode |
    | ORG0017113 | 10017113 | 701113 | 10017113 Co Ltd | Provider Under Change | AA017113      | ?             | 4 Red Lion Court       | Alexandra Road         | ?                      | ?                      | Hounslow               | Middlesex              | TW3 1JS  |



    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Clear down the feed control/audit table in PaaS
    And   there is no data in the AllocationNotifications table for the following UKPRNs
	| UKPRN    | 
    | 10017113 |

    # Clear down CRM Allocations data
    And   there is no data in the Allocations, AllocationPeriods or AllocationHistory tables in CRM for the following UKPRNs
    | UKPRN    | 
    | 10017113 |

    # Populate the CFS stub
    Given the following Provider, Allocation and Profile details are either assumed or available in the CFS stub
    | ContractingUKPRN | AllocationRef     | DeliveryUKPRN | ContractRequired | LegalName        | FundingStreamPeriodCode | DeliverableCode | FundingType | FundingPeriod | MajorVersion | MinorVersion | StartDate  | EndDate    | Status        | TotalValue | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | 
    | 10017113         | 11301-ALLF005     | ?             | Y                | 10017113 Co Ltd  | ALLF1819                | 5               | LOANS       | AY1819        | 1            | 2            | 01/08/2018 | 31/07/2019 | Published     | 99999.00   | 2503.00  | 2295.00  | 1744.00  | 2733.00  | 2269.00  | 1825.00  | 2492.00  | 2990.00  | 2162.00  | 2145.00  | 1531.00  | 873.00   | 



	# Process the stub data into CRM
    
	# Read control\header data from stub
   #When  the FCT system consumes the CFS data
    When  the feed-reading process is started

    # Has the stub control data arrived in ContractRequest.AllocationNotification
    And   the header data for the following UKPRNs is present in the AllocationNotification table
    | UKPRN    |
    | 10017113 |

    # Stub data is processed into CRM  
    And   the CFS stub data is processed into CRM



    # Check Allocations in CRM
    Then  the following Allocations details are present in CRM
    | ContractingUKPRN | AllocationRef     | ContractingProvider | DeliverableCode | DeliverableName                                                 | TotalValue | StartDate  | EndDate    | Status              | SubStatus           | FundingStreamPeriodCode | FundingType | FundingPeriod | Owner                | MajorVersion | MinorVersion | DeliveryUKPRN | DeliveryProvider |
    | 10017113         | 11301-ALLF005     | 10017113 Co Ltd     | 5               | Advanced Learner Loans Facility                                 | 25562.00   | 01/08/2018 | 31/07/2019 | Pre-Release         | In Review           | ALLF1819                | LOANS       | AY1819        | CRM Integration      | 1            | 2            | ?             | ?                | 

    # Check the row count in the CRM Allocations table
    And   there is '1' row in the Allocations table in CRM for UKPRN '10017113'

    # Check AllocationPeriods in CRM
    Then  the following AllocationPeriods details are present in CRM
    | ContractingUKPRN | AllocationRef     | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Owner                |
    | 10017113         | 11301-ALLF005     | 25562.00  | 2503.00  | 2295.00  | 1744.00  | 2733.00  | 2269.00  | 1825.00  | 2492.00  | 2990.00  | 2162.00  | 2145.00  | 1531.00  | 873.00   | CRM Integration      | 

    # Check the row count in the CRM AllocationPeriods table
    And   there are '12' rows in the AllocationPeriods table in CRM for UKPRN '10017113'

    # Check AllocationHistory in CRM
    Then  the following AllocationHistory details are present in CRM
    | ContractingUKPRN | AllocationRef     | Action                       | NewStatus           | NewSubStatus        | PreviousStatus      | PreviousSubStatus   | CompletedBy          |
    | 10017113         | 11301-ALLF005     | Record Imported              | Pre-Release         | In Review           | ?                   | ?                   | CRM Integration      | 

    # Check the row count in the CRM AllocationHistory table
    And   there is '1' row in the AllocationHistory table in CRM for UKPRN '10017113'




    # Select Allocations in CRM which are now ready for release and run WF35 against each (25310)
    When  the following Allocations are selected for release and the appropriate CRM workflow is triggered
    | ContractingUKPRN | AllocationRef     |
    | 10017113         | 11301-ALLF005     |

    # Check Allocations in CRM
    Then  the following Allocations details are present in CRM
    | ContractingUKPRN | AllocationRef     | ContractingProvider | DeliverableCode | DeliverableName                                                 | TotalValue | StartDate  | EndDate    | Status              | SubStatus           | FundingStreamPeriodCode | FundingType | FundingPeriod | Owner                | MajorVersion | MinorVersion | DeliveryUKPRN | DeliveryProvider |
    | 10017113         | 11301-ALLF005     | 10017113 Co Ltd     | 5               | Advanced Learner Loans Facility                                 | 25562.00   | 01/08/2018 | 31/07/2019 | Pre-Release         | Ready for Release   | ALLF1819                | LOANS       | AY1819        | CRM Integration      | 1            | 2            | ?             | ?                | 

    # Check the row count in the CRM Allocations table
    And   there is '1' row in the Allocations table in CRM for UKPRN '10017113'

    # Check AllocationHistory in CRM
    Then  the following AllocationHistory details are present in CRM
    | ContractingUKPRN | AllocationRef     | Action                       | NewStatus           | NewSubStatus        | PreviousStatus      | PreviousSubStatus   | CompletedBy          |
    | 10017113         | 11301-ALLF005     | Confirm Ready for Release    | Pre-Release         | Ready for Release   | Pre-Release         | In Review           | CRM Integration      | 
    | 10017113         | 11301-ALLF005     | Record Imported              | Pre-Release         | In Review           | ?                   | ?                   | CRM Integration      | 

    # Check the row count in the CRM AllocationHistory table
    And   there are '2' rows in the AllocationHistory table in CRM for UKPRN '10017113'



    # Tidy up
    And   the override date is reset

@AcceptanceTest @Withdrawn20201209
Scenario: A114 Retrieve 1819 LOANS data from CFS for four UKPRNs and save in CRM. Org data exists in CRM and PaaS. No assigned Caseload. Mark two as Ready for Release. Check CRM. Mark other two as Ready for Release. Check CRM
    Given there is no Contract, Task or Workflow data for UKPRN '10017114' 
	And   there is no Contract, Task or Workflow data for UKPRN '10027114' 
	And   there is no Contract, Task or Workflow data for UKPRN '10037114' 
	And   there is no Contract, Task or Workflow data for UKPRN '10047114' 
	And   the Allocation Delivery Monitoring Service atom feed is empty
    And   the Contract Management atom feed is empty

	# Clear down Sharepoint
	And   there are no files prefixed '10017114' in the Sharepoint 'LOANS-1819-Input-Appendices' folder
	And   there are no files prefixed '10027114' in the Sharepoint 'LOANS-1819-Input-Appendices' folder
	And   there are no files prefixed '10037114' in the Sharepoint 'LOANS-1819-Input-Appendices' folder
	And   there are no files prefixed '10047114' in the Sharepoint 'LOANS-1819-Input-Appendices' folder

#   # Set organisation and advisors
#   And   there is no Organisation data for UKPRN '10017114'
#   And   there is no Organisation data for UKPRN '10027114'
#   And   there is no Organisation data for UKPRN '10037114'
#   And   there is no Organisation data for UKPRN '10047114'
#
#   And   caseload advisor 'FCS2 Test' is assigned to provider '10017114 Co Ltd' with UKPRN '10017114' and OrgId 'ORG0017114' and has 'FCS1 Test' as a manager
#   And   caseload advisor 'FCS2 Test' is assigned to provider '10027114 Co Ltd' with UKPRN '10027114' and OrgId 'ORG0027114' and has 'FCS1 Test' as a manager
#   And   caseload advisor 'FCS2 Test' is assigned to provider '10037114 Co Ltd' with UKPRN '10037114' and OrgId 'ORG0037114' and has 'FCS1 Test' as a manager
#   And   caseload advisor 'FCS2 Test' is assigned to provider '10047114 Co Ltd' with UKPRN '10047114' and OrgId 'ORG0047114' and has 'FCS1 Test' as a manager


    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode |
    | 10017114 | 701114 | 10017114 Co Ltd | 0              | Active                | Yes           | AA017114      | ?             | 17 Barton Arcade       | Deansgate              | Manchester             | ?                      | ?                      | ?                      | M3 2BW   |
    | 10027114 | 702114 | 10027114 Co Ltd | 0              | In Administration     | Yes           | AA027114      | ?             | 2 Castle Yard          | Richmond               | Surrey                 | ?                      | ?                      | ?                      | TW10 6TF |
    | 10037114 | 703114 | 10037114 Co Ltd | 0              | Active                | Yes           | AA037114      | ?             | 58 Murray Place        | Stirling               | ?                      | ?                      | ?                      | ?                      | FK8 2BP  |
    | 10047114 | 704114 | 10047114 Co Ltd | 0              | Provider Under Change | Yes           | AA047114      | ?             | 89 The Marlowes        | ?                      | ?                      | ?                      | Hemel Hempstead        | Hertfordshire          | HP1 1XY  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017114 |
	| 10027114 |
	| 10037114 |
	| 10047114 |



    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Clear down the feed control/audit table in PaaS
    And   there is no data in the AllocationNotifications table for the following UKPRNs
    | UKPRN    | 
    | 10017114 |
    | 10027114 |
    | 10037114 |
    | 10047114 |

    # Clear down CRM Allocations data
    And   there is no data in the Allocations, AllocationPeriods or AllocationHistory tables in CRM for the following UKPRNs
    | UKPRN    | 
    | 10017114 |
    | 10027114 |
    | 10037114 |
    | 10047114 |

    # Populate the CFS stub
    Given the following Provider, Allocation and Profile details are either assumed or available in the CFS stub
    | ContractingUKPRN | AllocationRef     | DeliveryUKPRN | ContractRequired | LegalName        | FundingStreamPeriodCode | DeliverableCode | FundingType | FundingPeriod | MajorVersion | MinorVersion | StartDate  | EndDate    | Status        | TotalValue | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | 
    | 10017114         | 11401-ALLF005     | ?             | Y                | 10017114 Co Ltd  | ALLF1819                | 5               | LOANS       | AY1819        | 1            | 1            | 01/08/2018 | 31/07/2019 | Published     | 20012.00   | 2751.00  | 938.00   | 2547.00  | 884.00   | 2707.00  | 2904.00  | 1649.00  | 1078.00  | 954.00   | 660.00   | 1542.00  | 1398.00  | 
    | 10027114         | 11402-ALLF005     | ?             | Y                | 10027114 Co Ltd  | ALLF1819                | 5               | LOANS       | AY1819        | 1            | 6            | 01/08/2018 | 31/07/2019 | Published     | 23478.00   | 2494.00  | 1045.00  | 2226.00  | 2510.00  | 2323.00  | 2884.00  | 537.00   | 1248.00  | 2280.00  | 2350.00  | 2804.00  | 777.00   | 
    | 10037114         | 11403-ALLF005     | ?             | Y                | 10037114 Co Ltd  | ALLF1819                | 5               | LOANS       | AY1819        | 1            | 2            | 01/08/2018 | 31/07/2019 | Published     | 22450.00   | 527.00   | 1943.00  | 2697.00  | 1098.00  | 2066.00  | 2991.00  | 2717.00  | 2210.00  | 1232.00  | 1665.00  | 1692.00  | 1612.00  | 
    | 10047114         | 11404-ALLF005     | ?             | Y                | 10047114 Co Ltd  | ALLF1819                | 5               | LOANS       | AY1819        | 1            | 5            | 01/08/2018 | 31/07/2019 | Published     | 17748.00   | 1852.00  | 1131.00  | 794.00   | 1141.00  | 2600.00  | 724.00   | 687.00   | 1462.00  | 1639.00  | 1772.00  | 1372.00  | 2574.00  | 



    # Process the stub data into CRM
	
	# Read control\header data from stub
   #When  the FCT system consumes the CFS data
    When  the feed-reading process is started

    # Has the stub control data arrived in ContractRequest.AllocationNotification
    And   the header data for the following UKPRNs is present in the AllocationNotification table
    | UKPRN    |
    | 10017114 |
	| 10027114 |
	| 10037114 |
	| 10047114 |

    # Stub data is processed into CRM  
    And   the CFS stub data is processed into CRM



    # Check Allocations in CRM
    Then  the following Allocations details are present in CRM
    | ContractingUKPRN | AllocationRef     | ContractingProvider | DeliverableCode | DeliverableName                                                 | TotalValue | StartDate  | EndDate    | Status              | SubStatus           | FundingStreamPeriodCode | FundingType | FundingPeriod | Owner                | MajorVersion | MinorVersion | DeliveryUKPRN | DeliveryProvider |
    | 10017114         | 11401-ALLF005     | 10017114 Co Ltd     | 5               | Advanced Learner Loans Facility                                 | 20012.00   | 01/08/2018 | 31/07/2019 | Pre-Release         | In Review           | ALLF1819                | LOANS       | AY1819        | CRM Integration      | 1            | 1            | ?             | ?                | 
    | 10027114         | 11402-ALLF005     | 10027114 Co Ltd     | 5               | Advanced Learner Loans Facility                                 | 23478.00   | 01/08/2018 | 31/07/2019 | Pre-Release         | In Review           | ALLF1819                | LOANS       | AY1819        | CRM Integration      | 1            | 6            | ?             | ?                | 
    | 10037114         | 11403-ALLF005     | 10037114 Co Ltd     | 5               | Advanced Learner Loans Facility                                 | 22450.00   | 01/08/2018 | 31/07/2019 | Pre-Release         | In Review           | ALLF1819                | LOANS       | AY1819        | CRM Integration      | 1            | 2            | ?             | ?                | 
    | 10047114         | 11404-ALLF005     | 10047114 Co Ltd     | 5               | Advanced Learner Loans Facility                                 | 17748.00   | 01/08/2018 | 31/07/2019 | Pre-Release         | In Review           | ALLF1819                | LOANS       | AY1819        | CRM Integration      | 1            | 5            | ?             | ?                | 

    # Check the row count in the CRM Allocations table
    And   there is '1' row in the Allocations table in CRM for UKPRN '10017114'
    And   there is '1' row in the Allocations table in CRM for UKPRN '10027114'
    And   there is '1' row in the Allocations table in CRM for UKPRN '10037114'
    And   there is '1' row in the Allocations table in CRM for UKPRN '10047114'

    # Check AllocationPeriods in CRM
    Then  the following AllocationPeriods details are present in CRM
    | ContractingUKPRN | AllocationRef     | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Owner                |
    | 10017114         | 11401-ALLF005     | 20012.00  | 2751.00  | 938.00   | 2547.00  | 884.00   | 2707.00  | 2904.00  | 1649.00  | 1078.00  | 954.00   | 660.00   | 1542.00  | 1398.00  | CRM Integration      | 
    | 10027114         | 11402-ALLF005     | 23478.00  | 2494.00  | 1045.00  | 2226.00  | 2510.00  | 2323.00  | 2884.00  | 537.00   | 1248.00  | 2280.00  | 2350.00  | 2804.00  | 777.00   | CRM Integration      | 
    | 10037114         | 11403-ALLF005     | 22450.00  | 527.00   | 1943.00  | 2697.00  | 1098.00  | 2066.00  | 2991.00  | 2717.00  | 2210.00  | 1232.00  | 1665.00  | 1692.00  | 1612.00  | CRM Integration      | 
    | 10047114         | 11404-ALLF005     | 17748.00  | 1852.00  | 1131.00  | 794.00   | 1141.00  | 2600.00  | 724.00   | 687.00   | 1462.00  | 1639.00  | 1772.00  | 1372.00  | 2574.00  | CRM Integration      | 

    # Check the row count in the CRM AllocationPeriods table
    And   there are '12' rows in the AllocationPeriods table in CRM for UKPRN '10017114'
    And   there are '12' rows in the AllocationPeriods table in CRM for UKPRN '10027114'
    And   there are '12' rows in the AllocationPeriods table in CRM for UKPRN '10037114'
    And   there are '12' rows in the AllocationPeriods table in CRM for UKPRN '10047114'

    # Check AllocationHistory in CRM
    Then  the following AllocationHistory details are present in CRM
    | ContractingUKPRN | AllocationRef     | Action                       | NewStatus           | NewSubStatus        | PreviousStatus      | PreviousSubStatus   | CompletedBy          |
    | 10017114         | 11401-ALLF005     | Record Imported              | Pre-Release         | In Review           | ?                   | ?                   | CRM Integration      | 
    | 10027114         | 11402-ALLF005     | Record Imported              | Pre-Release         | In Review           | ?                   | ?                   | CRM Integration      | 
    | 10037114         | 11403-ALLF005     | Record Imported              | Pre-Release         | In Review           | ?                   | ?                   | CRM Integration      | 
    | 10047114         | 11404-ALLF005     | Record Imported              | Pre-Release         | In Review           | ?                   | ?                   | CRM Integration      | 

    # Check the row count in the CRM AllocationHistory table
    And   there is '1' row in the AllocationHistory table in CRM for UKPRN '10017114'
	And   there is '1' row in the AllocationHistory table in CRM for UKPRN '10027114'
	And   there is '1' row in the AllocationHistory table in CRM for UKPRN '10037114'
	And   there is '1' row in the AllocationHistory table in CRM for UKPRN '10047114'



    # Mark data for providers 1 and 3 as ready for release
	
	# Select Allocations in CRM which are now ready for release and run WF35 against each (25310)
    When  the following Allocations are selected for release and the appropriate CRM workflow is triggered
    | ContractingUKPRN | AllocationRef     |
    | 10017114         | 11401-ALLF005     |
#   | 10027114         | 11402-ALLF005     |
    | 10037114         | 11403-ALLF005     |
#   | 10047114         | 11404-ALLF005     |

    # Check Allocations in CRM
    Then  the following Allocations details are present in CRM
    | ContractingUKPRN | AllocationRef     | ContractingProvider | DeliverableCode | DeliverableName                        | TotalValue | StartDate  | EndDate    | Status              | SubStatus           | FundingStreamPeriodCode | FundingType | FundingPeriod | Owner                | MajorVersion | MinorVersion | DeliveryUKPRN | DeliveryProvider |
    | 10017114         | 11401-ALLF005     | 10017114 Co Ltd     | 5               | Advanced Learner Loans Facility        | 20012.00   | 01/08/2018 | 31/07/2019 | Pre-Release         | Ready for Release   | ALLF1819                | LOANS       | AY1819        | CRM Integration      | 1            | 1            | ?             | ?                | 
    | 10027114         | 11402-ALLF005     | 10027114 Co Ltd     | 5               | Advanced Learner Loans Facility        | 23478.00   | 01/08/2018 | 31/07/2019 | Pre-Release         | In Review           | ALLF1819                | LOANS       | AY1819        | CRM Integration      | 1            | 6            | ?             | ?                | 
    | 10037114         | 11403-ALLF005     | 10037114 Co Ltd     | 5               | Advanced Learner Loans Facility        | 22450.00   | 01/08/2018 | 31/07/2019 | Pre-Release         | Ready for Release   | ALLF1819                | LOANS       | AY1819        | CRM Integration      | 1            | 2            | ?             | ?                | 
    | 10047114         | 11404-ALLF005     | 10047114 Co Ltd     | 5               | Advanced Learner Loans Facility        | 17748.00   | 01/08/2018 | 31/07/2019 | Pre-Release         | In Review           | ALLF1819                | LOANS       | AY1819        | CRM Integration      | 1            | 5            | ?             | ?                | 

    # Check the row count in the CRM Allocations table
    And   there is '1' row in the Allocations table in CRM for UKPRN '10017114'
	And   there is '1' row in the Allocations table in CRM for UKPRN '10027114'
	And   there is '1' row in the Allocations table in CRM for UKPRN '10037114'
	And   there is '1' row in the Allocations table in CRM for UKPRN '10047114'

    # Check AllocationHistory in CRM
    Then  the following AllocationHistory details are present in CRM
    | ContractingUKPRN | AllocationRef     | Action                       | NewStatus           | NewSubStatus        | PreviousStatus      | PreviousSubStatus   | CompletedBy          |
    | 10017114         | 11401-ALLF005     | Confirm Ready for Release    | Pre-Release         | Ready for Release   | Pre-Release         | In Review           | CRM Integration      | 
    | 10017114         | 11401-ALLF005     | Record Imported              | Pre-Release         | In Review           | ?                   | ?                   | CRM Integration      | 
    | 10027114         | 11402-ALLF005     | Record Imported              | Pre-Release         | In Review           | ?                   | ?                   | CRM Integration      | 
    | 10037114         | 11403-ALLF005     | Confirm Ready for Release    | Pre-Release         | Ready for Release   | Pre-Release         | In Review           | CRM Integration      | 
    | 10037114         | 11403-ALLF005     | Record Imported              | Pre-Release         | In Review           | ?                   | ?                   | CRM Integration      | 
    | 10047114         | 11404-ALLF005     | Record Imported              | Pre-Release         | In Review           | ?                   | ?                   | CRM Integration      | 

    # Check the row count in the CRM AllocationHistory table
    And   there are '2' rows in the AllocationHistory table in CRM for UKPRN '10017114'
	And   there is '1' row in the AllocationHistory table in CRM for UKPRN '10027114'
	And   there are '2' rows in the AllocationHistory table in CRM for UKPRN '10037114'
	And   there is '1' row in the AllocationHistory table in CRM for UKPRN '10047114'




	# Mark data for providers 2 and 4 as ready for release

    # Select Allocations in CRM which are now ready for release and run WF35 against each (25310)
    When  the following Allocations are selected for release and the appropriate CRM workflow is triggered
    | ContractingUKPRN | AllocationRef     |
#   | 10017114         | 11401-ALLF005     |
    | 10027114         | 11402-ALLF005     |
#   | 10037114         | 11403-ALLF005     |
    | 10047114         | 11404-ALLF005     |

    # Check Allocations in CRM
    Then  the following Allocations details are present in CRM
    | ContractingUKPRN | AllocationRef     | ContractingProvider | DeliverableCode | DeliverableName                        | TotalValue | StartDate  | EndDate    | Status              | SubStatus           | FundingStreamPeriodCode | FundingType | FundingPeriod | Owner                | MajorVersion | MinorVersion | DeliveryUKPRN | DeliveryProvider |
    | 10017114         | 11401-ALLF005     | 10017114 Co Ltd     | 5               | Advanced Learner Loans Facility        | 20012.00   | 01/08/2018 | 31/07/2019 | Pre-Release         | Ready for Release   | ALLF1819                | LOANS       | AY1819        | CRM Integration      | 1            | 1            | ?             | ?                | 
    | 10027114         | 11402-ALLF005     | 10027114 Co Ltd     | 5               | Advanced Learner Loans Facility        | 23478.00   | 01/08/2018 | 31/07/2019 | Pre-Release         | Ready for Release   | ALLF1819                | LOANS       | AY1819        | CRM Integration      | 1            | 6            | ?             | ?                | 
    | 10037114         | 11403-ALLF005     | 10037114 Co Ltd     | 5               | Advanced Learner Loans Facility        | 22450.00   | 01/08/2018 | 31/07/2019 | Pre-Release         | Ready for Release   | ALLF1819                | LOANS       | AY1819        | CRM Integration      | 1            | 2            | ?             | ?                | 
    | 10047114         | 11404-ALLF005     | 10047114 Co Ltd     | 5               | Advanced Learner Loans Facility        | 17748.00   | 01/08/2018 | 31/07/2019 | Pre-Release         | Ready for Release   | ALLF1819                | LOANS       | AY1819        | CRM Integration      | 1            | 5            | ?             | ?                | 

    # Check the row count in the CRM Allocations table
    And   there is '1' row in the Allocations table in CRM for UKPRN '10017114'
	And   there is '1' row in the Allocations table in CRM for UKPRN '10027114'
	And   there is '1' row in the Allocations table in CRM for UKPRN '10037114'
	And   there is '1' row in the Allocations table in CRM for UKPRN '10047114'

    # Check AllocationHistory in CRM
    Then  the following AllocationHistory details are present in CRM
    | ContractingUKPRN | AllocationRef     | Action                       | NewStatus           | NewSubStatus        | PreviousStatus      | PreviousSubStatus   | CompletedBy          |
    | 10017114         | 11401-ALLF005     | Confirm Ready for Release    | Pre-Release         | Ready for Release   | Pre-Release         | In Review           | CRM Integration      | 
    | 10017114         | 11401-ALLF005     | Record Imported              | Pre-Release         | In Review           | ?                   | ?                   | CRM Integration      | 
    | 10027114         | 11402-ALLF005     | Confirm Ready for Release    | Pre-Release         | Ready for Release   | Pre-Release         | In Review           | CRM Integration      | 
    | 10027114         | 11402-ALLF005     | Record Imported              | Pre-Release         | In Review           | ?                   | ?                   | CRM Integration      | 
    | 10037114         | 11403-ALLF005     | Confirm Ready for Release    | Pre-Release         | Ready for Release   | Pre-Release         | In Review           | CRM Integration      | 
    | 10037114         | 11403-ALLF005     | Record Imported              | Pre-Release         | In Review           | ?                   | ?                   | CRM Integration      | 
    | 10047114         | 11404-ALLF005     | Confirm Ready for Release    | Pre-Release         | Ready for Release   | Pre-Release         | In Review           | CRM Integration      | 
    | 10047114         | 11404-ALLF005     | Record Imported              | Pre-Release         | In Review           | ?                   | ?                   | CRM Integration      | 

    # Check the row count in the CRM AllocationHistory table
    And   there are '2' rows in the AllocationHistory table in CRM for UKPRN '10017114'
	And   there are '2' rows in the AllocationHistory table in CRM for UKPRN '10027114'
	And   there are '2' rows in the AllocationHistory table in CRM for UKPRN '10037114'
	And   there are '2' rows in the AllocationHistory table in CRM for UKPRN '10047114'



    # Tidy up
    And   the override date is reset

@AcceptanceTest @Withdrawn20200604
@UiTest
Scenario: A115 Retrieve 1819 LOANS data from CFS for one UKPRN and save in CRM. Org data exists in CRM and PaaS. No assigned Caseload. Mark as Ready for Release then release. Check CRM
    Given there is no Contract, Task or Workflow data for UKPRN '10017115' 
	And   the Allocation Delivery Monitoring Service atom feed is empty
    And   the Contract Management atom feed is empty
	And   there are no files prefixed '10017115' in the Sharepoint 'LOANS-1819-Input-Appendices' folder

#   # Set organisation and advisors
#   And   there is no Organisation data for UKPRN '10017115'
#   And   caseload advisor 'FCS2 Test' is assigned to provider '10017115 Co Ltd' with UKPRN '10017115' and OrgId 'ORG0017115' and has 'FCS1 Test' as a manager
    And   there is no caseload for provider with UKPRN '10017115'

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode |
    | 10017115 | 701115 | 10017115 Co Ltd | 0              | Active                | Yes           | AA017115      | ?             | 14 Meadway Court       | Rutherford Close       | ?                      | ?                      | Stevenage              | Hertfordshire          | SG1 2EF  |


    # Put the same Provider data in the CRM Organisation table J057
    And   the following Organisations exist in CRM
    | OrgId      | UKPRN    | UPIN   | Name            | Status                | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode |
    | ORG0017115 | 10017115 | 701115 | 10017115 Co Ltd | Active                | AA017115      | ?             | 14 Meadway Court       | Rutherford Close       | ?                      | ?                      | Stevenage              | Hertfordshire          | SG1 2EF  |



    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Clear down the feed control/audit table in PaaS
    And   there is no data in the AllocationNotifications table for the following UKPRNs
    | UKPRN    | 
    | 10017115 |

    # Clear down CRM Allocations data
    And   there is no data in the Allocations, AllocationPeriods or AllocationHistory tables in CRM for the following UKPRNs
    | UKPRN    | 
    | 10017115 |

    # Populate the CFS stub
    Given the following Provider, Allocation and Profile details are either assumed or available in the CFS stub
    | ContractingUKPRN | AllocationRef     | DeliveryUKPRN | ContractRequired | LegalName        | FundingStreamPeriodCode | DeliverableCode | FundingType | FundingPeriod | MajorVersion | MinorVersion | StartDate  | EndDate    | Status        | TotalValue | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | 
    | 10017115         | 11501-ALLF005     | ?             | Y                | 10017115 Co Ltd  | ALLF1819                | 5               | LOANS       | AY1819        | 1            | 9            | 01/08/2018 | 31/07/2019 | Published     | 22432.00   | 1831.00  | 2329.00  | 836.00   | 1484.00  | 869.00   | 2713.00  | 1521.00  | 2596.00  | 2536.00  | 1387.00  | 2996.00  | 1334.00  | 

	

	# Process the stub data into CRM
    
	# Read control\header data from stub
   #When  the FCT system consumes the CFS data
    When  the feed-reading process is started

    # Has the stub control data arrived in ContractRequest.AllocationNotification
    And   the header data for the following UKPRNs is present in the AllocationNotification table
    | UKPRN    |
    | 10017115 |

    # Stub data is processed into CRM  
    And   the CFS stub data is processed into CRM



    # Check Allocations in CRM
    Then  the following Allocations details are present in CRM
    | ContractingUKPRN | AllocationRef     | ContractingProvider | DeliverableCode | DeliverableName                                                 | TotalValue | StartDate  | EndDate    | Status              | SubStatus           | FundingStreamPeriodCode | FundingType | FundingPeriod | Owner                | MajorVersion | MinorVersion | DeliveryUKPRN | DeliveryProvider |
    | 10017115         | 11501-ALLF005     | 10017115 Co Ltd     | 5               | Advanced Learner Loans Facility                                 | 22432.00   | 01/08/2018 | 31/07/2019 | Pre-Release         | In Review           | ALLF1819                | LOANS       | AY1819        | CRM Integration      | 1            | 9            | ?             | ?                | 

    # Check the row count in the CRM Allocations table
    And   there is '1' row in the Allocations table in CRM for UKPRN '10017115'

    # Check AllocationPeriods in CRM
    Then  the following AllocationPeriods details are present in CRM
    | ContractingUKPRN | AllocationRef     | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Owner                |
    | 10017115         | 11501-ALLF005     | 22432.00  | 1831.00  | 2329.00  | 836.00   | 1484.00  | 869.00   | 2713.00  | 1521.00  | 2596.00  | 2536.00  | 1387.00  | 2996.00  | 1334.00  | CRM Integration      | 

    # Check the row count in the CRM AllocationPeriods table
    And   there are '12' rows in the AllocationPeriods table in CRM for UKPRN '10017115'

    # Check AllocationHistory in CRM
    Then  the following AllocationHistory details are present in CRM
    | ContractingUKPRN | AllocationRef     | Action                       | NewStatus           | NewSubStatus        | PreviousStatus      | PreviousSubStatus   | CompletedBy          |
    | 10017115         | 11501-ALLF005     | Record Imported              | Pre-Release         | In Review           | ?                   | ?                   | CRM Integration      | 

    # Check the row count in the CRM AllocationHistory table
    And   there is '1' row in the AllocationHistory table in CRM for UKPRN '10017115'




    # Select Allocations in CRM which are now ready for release and run WF35 against each (25310)
    When  the following Allocations are selected for release and the appropriate CRM workflow is triggered
    | ContractingUKPRN | AllocationRef     |
    | 10017115         | 11501-ALLF005     |

    # Check Allocations in CRM
    Then  the following Allocations details are present in CRM
    | ContractingUKPRN | AllocationRef     | ContractingProvider | DeliverableCode | DeliverableName                                                 | TotalValue | StartDate  | EndDate    | Status              | SubStatus           | FundingStreamPeriodCode | FundingType | FundingPeriod | Owner                | MajorVersion | MinorVersion | DeliveryUKPRN | DeliveryProvider |
    | 10017115         | 11501-ALLF005     | 10017115 Co Ltd     | 5               | Advanced Learner Loans Facility                                 | 22432.00   | 01/08/2018 | 31/07/2019 | Pre-Release         | Ready for Release   | ALLF1819                | LOANS       | AY1819        | CRM Integration      | 1            | 9            | ?             | ?                | 

    # Check the row count in the CRM Allocations table
    And   there is '1' row in the Allocations table in CRM for UKPRN '10017115'

    # Check AllocationHistory in CRM
    Then  the following AllocationHistory details are present in CRM
    | ContractingUKPRN | AllocationRef     | Action                       | NewStatus           | NewSubStatus        | PreviousStatus      | PreviousSubStatus   | CompletedBy          |
    | 10017115         | 11501-ALLF005     | Confirm Ready for Release    | Pre-Release         | Ready for Release   | Pre-Release         | In Review           | CRM Integration      | 
    | 10017115         | 11501-ALLF005     | Record Imported              | Pre-Release         | In Review           | ?                   | ?                   | CRM Integration      | 

    # Check the row count in the CRM AllocationHistory table
    And   there are '2' rows in the AllocationHistory table in CRM for UKPRN '10017115'




    # Release CFS Allocation and create Contract (25230)

    # Release Allocations (and create contracts) for the following Funding Type and Period and run WF?? (25230)
    When  FundingTypePeriod 'Advanced Learner Loans - AY1819' is selected from the Release Allocations for Contracting dropdown and the appropriate CRM workflow is triggered

    # Retrieve parameters and check contents of the Appendices
    Then  I retrieve the latest contract details from CRM for provider '10017115' for FundingType 'LOANS' and period '1819'
    And   a file for this contract exists in sharepoint location 'LOANS-1819-Input-Appendices'
   #And   the pdf file contains the following simple lines in order
    And   the pdf file contains the following parameterized lines in order
    """
    APPENDIX 1 - SUMMARY OF FUNDING 2018/19
    Organisation Name:
    UKPRN: 10017115
    Maximum Values
    Ref Aug 18 - Mar 19 Apr 19 - Jul 19 2018/19 Total
    Advanced Learner Loans Facility [AllocRef_ALLF] £14,179 £8,253 £22,432
    Total Funding for this agreement £22,432
    Appendix 1 2018/19 Master ref: [MasterContractNo]
    """

    # Appendix 2 (Funding Agreement) should never be produced for ALLF
    And   the pdf file does not contain the following line
    """
    Funding Agreement Advanced Learner Loans Facility
    """




    # Check that the Contract and Master Contract have been created correctly in CRM
    Then  the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType             | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType             | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | 
    | 10017115 | [ContractNo]       | Advanced Learner Loans  | Contract      | Draft          | Unassigned              | 22432.00      | 1                     | 0                        | 01/08/2018        | 31/07/2019      | True          | False               | ?             | Contract for Services    | ?                        | ?             | ?                        | Yes                   | [MasterContractNo] | AY1819 | ?               | 10017115 Co Ltd  | Active | Unassigned                |
    | 10017115 | [MasterContractNo] | Advanced Learner Loans  | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2018        | 31/07/2019      | False         | False               | ?             | Contract for Services    | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017115 Co Ltd  | Active | CRM Integration           |

    # Check that the Contract Allocations have been created correctly in CRM
    Then  the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType       |
    | 10017115 | [ContractNo]       | [AllocRef_ALLF]       | ?                             | 22432.00        | ?             | ?                | 01/08/2018 | 31/07/2019 | ALLF          | ALLF1819            | Contract Allocation |

    # Check that the Contract Deliverables have been created correctly in CRM
    Then  the following Contract Deliverables exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | DeliverableCode | DisplayOrder | ParentDeliverableCode | ContractDeliverableName               | ContractDeliverableDescription       | PlannedValue | PlannedVolume | UnitCost |
    | 10017115 | [ContractNo]       | [AllocRef_ALLF]       | 5               | 1            | ?                     | Advanced Learner Loans Facility       | ?                                    | 22432.00     | 0             | 0        |

    # Check that the Contract Deliverable Periods have been created correctly in CRM
    Then  the following Contract Deliverable Periods exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | DeliverableCode | Year | Month | PeriodType | Period  | PeriodName | PlannedValue | PlannedVolume | PaymentPosted |
    | 10017115 | [ContractNo]       | [AllocRef_ALLF]       | 5               | 2018 | 08    | CM         | Aug-18  | Aug-18     | 1831.00      | 0             | No            |
    | 10017115 | [ContractNo]       | [AllocRef_ALLF]       | 5               | 2018 | 09    | CM         | Sep-18  | Sep-18     | 2329.00      | 0             | No            |
    | 10017115 | [ContractNo]       | [AllocRef_ALLF]       | 5               | 2018 | 10    | CM         | Oct-18  | Oct-18     | 836.00       | 0             | No            |
    | 10017115 | [ContractNo]       | [AllocRef_ALLF]       | 5               | 2018 | 11    | CM         | Nov-18  | Nov-18     | 1484.00      | 0             | No            |
    | 10017115 | [ContractNo]       | [AllocRef_ALLF]       | 5               | 2018 | 12    | CM         | Dec-18  | Dec-18     | 869.00       | 0             | No            |
    | 10017115 | [ContractNo]       | [AllocRef_ALLF]       | 5               | 2019 | 01    | CM         | Jan-19  | Jan-19     | 2713.00      | 0             | No            |
    | 10017115 | [ContractNo]       | [AllocRef_ALLF]       | 5               | 2019 | 02    | CM         | Feb-19  | Feb-19     | 1521.00      | 0             | No            |
    | 10017115 | [ContractNo]       | [AllocRef_ALLF]       | 5               | 2019 | 03    | CM         | Mar-19  | Mar-19     | 2596.00      | 0             | No            |
    | 10017115 | [ContractNo]       | [AllocRef_ALLF]       | 5               | 2019 | 04    | CM         | Apr-19  | Apr-19     | 2536.00      | 0             | No            |
    | 10017115 | [ContractNo]       | [AllocRef_ALLF]       | 5               | 2019 | 05    | CM         | May-19  | May-19     | 1387.00      | 0             | No            |
    | 10017115 | [ContractNo]       | [AllocRef_ALLF]       | 5               | 2019 | 06    | CM         | Jun-19  | Jun-19     | 2996.00      | 0             | No            |
    | 10017115 | [ContractNo]       | [AllocRef_ALLF]       | 5               | 2019 | 07    | CM         | Jul-19  | Jul-19     | 1334.00      | 0             | No            |




    # Check the contents of the Workflow History after the contract has been created in CRM
    Then  the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus |
   #| 10017115 | [MasterContractNo] | [ContractNo]   | 1                     | Contract Created on Allocation Release      | CRM Integration | ?                | Document Management Team    | Draft         | Unassigned              | ?                     | ?                   | ?              | ?                 |
    | 10017115 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported Documentation Required      | CRM Integration | ?                | Unassigned                  | Draft         | Unassigned              | ?                     | ?                   | Draft          | ?                 |




#   # Has a Task been created ?    No task has been created because a caseload does not exist
#   And   the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017115'
#   | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
#   | Initiate Document Merge                    | 10017115 - 10017115 Co Ltd     | [ContractNo]   | Unassigned                | Document Management Team | Open            | Not Started      |




    # Check CFS AllocationHistory in CRM
    Then  the following AllocationHistory details are present in CRM
    | ContractingUKPRN | AllocationRef     | Action                       | NewStatus           | NewSubStatus        | PreviousStatus      | PreviousSubStatus   | CompletedBy          |
    | 10017115         | 11501-ALLF005     | Release Successful           | Released            | Released            | In Release          | Release in Progress | CRM Integration      | 
    | 10017115         | 11501-ALLF005     | Initiate Release             | In Release          | Release in Progress | Pre-Release         | Ready for Release   | FCS8 Test            | 
    | 10017115         | 11501-ALLF005     | Confirm Ready for Release    | Pre-Release         | Ready for Release   | Pre-Release         | In Review           | CRM Integration      | 
    | 10017115         | 11501-ALLF005     | Record Imported              | Pre-Release         | In Review           | ?                   | ?                   | CRM Integration      | 

    # Check the row count in the CRM AllocationHistory table
    And   there are '4' rows in the AllocationHistory table in CRM for UKPRN '10017115'


    # Tidy up
    And   the override date is reset

@AcceptanceTest @Withdrawn20200604
@UiTest
Scenario: A320 Retrieve 1819 LOANS data from CFS for one UKPRN and save in CRM. Org exists and Caseload assigned. Mark as Ready for Release then release. Check docs. Publish and approve. Consume actuals. Check CRM and PaaS
    Given there is no Contract, Task or Workflow data for UKPRN '10017320' 
	And   the Allocation Delivery Monitoring Service atom feed is empty
    And   the Contract Management atom feed is empty
	And   there are no files prefixed '10017320' in the Sharepoint 'LOANS-1819-Input-Appendices' folder

    # Set organisation and advisors
    And   there is no Organisation data for UKPRN '10017320'
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017320 Co Ltd' with UKPRN '10017320' and OrgId 'ORG0017320' and has 'FCS1 Test' as a manager

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode |
    | 10017320 | 701320 | 10017320 Co Ltd | 0              | In Administration     | Yes           | AA017320      | ?             | 7 Claymore             | Tame Valley            | ?                      | ?                      | Tamworth               | Staffordshire          | B77 5DQ  |

    # Put the same Provider data in the CRM Organisation table (Comment this out if contract being created by Bulk import)
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017320 |


    # Clear down the CFS stub
    And   there is no data in the CFS stub

    # Clear down the feed control/audit table in PaaS
    And   there is no data in the AllocationNotifications table for the following UKPRNs
    | UKPRN    | 
    | 10017320 |


    # Clear down CRM Allocations data
    And   there is no data in the Allocations, AllocationPeriods or AllocationHistory tables in CRM for the following UKPRNs
    | UKPRN    | 
    | 10017320 |

    # Populate the CFS stub
    Given the following Provider, Allocation and Profile details are either assumed or available in the CFS stub
    | ContractingUKPRN | AllocationRef     | DeliveryUKPRN | ContractRequired | LegalName        | FundingStreamPeriodCode | DeliverableCode | FundingType | FundingPeriod | MajorVersion | MinorVersion | StartDate  | EndDate    | Status        | TotalValue | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | 
    | 10017320         | 32001-ALLF005     | ?             | Y                | 10017320 Co Ltd  | ALLF1819                | 5               | LOANS       | AY1819        | 1            | 5            | 01/08/2018 | 31/07/2019 | Published     | 16801.00   | 1117.00  | 841.00   | 873.00   | 776.00   | 1065.00  | 3200.00  | 592.00   | 1009.00  | 1962.00  | 508.00   | 3465.00  | 1393.00  | 



    # Process the stub data into CRM

    # Read control\header data from stub
   #When  the FCT system consumes the CFS data
    When  the feed-reading process is started 

    # Has the stub control data arrived in ContractRequest.AllocationNotification
    And   the header data for the following UKPRNs is present in the AllocationNotification table
    | UKPRN    |
    | 10017320 |

    # Stub data is processed into CRM
    And   the CFS stub data is processed into CRM



    # Check CFS Allocations in CRM
    Then  the following Allocations details are present in CRM
    | ContractingUKPRN | AllocationRef     | ContractingProvider | DeliverableCode | DeliverableName                     | TotalValue | StartDate  | EndDate    | Status              | SubStatus           | FundingStreamPeriodCode | FundingType | FundingPeriod | Owner                | MajorVersion | MinorVersion | DeliveryUKPRN | DeliveryProvider |
    | 10017320         | 32001-ALLF005     | 10017320 Co Ltd     | 5               | Advanced Learner Loans Facility     | 16801.00   | 01/08/2018 | 31/07/2019 | Pre-Release         | In Review           | ALLF1819                | LOANS       | AY1819        | CRM Integration      | 1            | 5            | ?             | ?                | 

    # Check the row count in the CRM Allocations table
    And   there is '1' row in the Allocations table in CRM for UKPRN '10017320'

    # Check CFS AllocationPeriods in CRM
    Then  the following AllocationPeriods details are present in CRM
    | ContractingUKPRN | AllocationRef     | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Owner                |
    | 10017320         | 32001-ALLF005     | 16801.00  | 1117.00  | 841.00   | 873.00   | 776.00   | 1065.00  | 3200.00  | 592.00   | 1009.00  | 1962.00  | 508.00   | 3465.00  | 1393.00  | CRM Integration      | 

    # Check the row count in the CRM AllocationPeriods table
    And   there are '12' rows in the AllocationPeriods table in CRM for UKPRN '10017320'

    # Check CFS AllocationHistory in CRM
    Then  the following AllocationHistory details are present in CRM
    | ContractingUKPRN | AllocationRef     | Action                       | NewStatus           | NewSubStatus        | PreviousStatus      | PreviousSubStatus   | CompletedBy          |
    | 10017320         | 32001-ALLF005     | Record Imported              | Pre-Release         | In Review           | ?                   | ?                   | CRM Integration      | 

    # Check the row count in the CRM AllocationHistory table
    And   there is '1' row in the AllocationHistory table in CRM for UKPRN '10017320'




    # Select CFS Allocations in CRM which are now ready for release and run WF35 against each (25310)
    When  the following Allocations are selected for release and the appropriate CRM workflow is triggered
    | ContractingUKPRN | AllocationRef     |
    | 10017320         | 32001-ALLF005     |

    # Check CFS Allocations in CRM
    Then  the following Allocations details are present in CRM
    | ContractingUKPRN | AllocationRef     | ContractingProvider | DeliverableCode | DeliverableName                     | TotalValue | StartDate  | EndDate    | Status              | SubStatus           | FundingStreamPeriodCode | FundingType | FundingPeriod | Owner                | MajorVersion | MinorVersion | DeliveryUKPRN | DeliveryProvider |
    | 10017320         | 32001-ALLF005     | 10017320 Co Ltd     | 5               | Advanced Learner Loans Facility     | 16801.00   | 01/08/2018 | 31/07/2019 | Pre-Release         | Ready for Release   | ALLF1819                | LOANS       | AY1819        | CRM Integration      | 1            | 5            | ?             | ?                | 

    # Check the row count in the CRM Allocations table
    And   there is '1' row in the Allocations table in CRM for UKPRN '10017320'

    # Check CFS AllocationHistory in CRM
    Then  the following AllocationHistory details are present in CRM
    | ContractingUKPRN | AllocationRef     | Action                       | NewStatus           | NewSubStatus        | PreviousStatus      | PreviousSubStatus   | CompletedBy          |
    | 10017320         | 32001-ALLF005     | Confirm Ready for Release    | Pre-Release         | Ready for Release   | Pre-Release         | In Review           | CRM Integration      | 
    | 10017320         | 32001-ALLF005     | Record Imported              | Pre-Release         | In Review           | ?                   | ?                   | CRM Integration      | 

    # Check the row count in the CRM AllocationHistory table
    And   there are '2' rows in the AllocationHistory table in CRM for UKPRN '10017320'




    # Release CFS Allocation and create Contract (25230)

    # Release Allocations (and create contracts) for the following Funding Type and Period and run WF?? (25230)
    When  FundingTypePeriod 'Advanced Learner Loans - AY1819' is selected from the Release Allocations for Contracting dropdown and the appropriate CRM workflow is triggered

    # Retrieve parameters and check contents of the Appendices
    Then  I retrieve the latest contract details from CRM for provider '10017320' for FundingType 'LOANS' and period '1819'
    And   a file for this contract exists in sharepoint location 'LOANS-1819-Input-Appendices'
   #And   the pdf file contains the following simple lines in order
    And   the pdf file contains the following parameterized lines in order
    """
    APPENDIX 1 - SUMMARY OF FUNDING 2018/19
	Organisation Name:
    UKPRN: 10017320
    Maximum Values
    Ref Aug 18 - Mar 19 Apr 19 - Jul 19 2018/19 Total
    Advanced Learner Loans Facility [AllocRef_ALLF] £9,473 £7,328 £16,801
    Total Funding for this agreement £16,801
    Appendix 1 2018/19 Master ref: [MasterContractNo]
    """

    # Appendix 2 (Funding Agreement) should never be produced for ALLF
    And   the pdf file does not contain the following line
    """
    Funding Agreement Advanced Learner Loans Facility
    """




    # Check that the Contract and Master Contract have been created correctly in CRM
    Then  the following Contracts exist in CRM
    | UKPRN    | ContractNumber     | FundingType             | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType             | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | 
    | 10017320 | [ContractNo]       | Advanced Learner Loans  | Contract      | Draft          | Awaiting Documentation  | 16801.00      | 1                     | 0                        | 01/08/2018        | 31/07/2019      | True          | False               | Unassigned    | Contract for Services    | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY1819 | ?               | 10017320 Co Ltd  | Active | Document Management Team  |
    | 10017320 | [MasterContractNo] | Advanced Learner Loans  | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2018        | 31/07/2019      | False         | False               | Unassigned    | Contract for Services    | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017320 Co Ltd  | Active | CRM Integration           |

    # Check that the Contract Allocations have been created correctly in CRM
    Then  the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType       |
    | 10017320 | [ContractNo]       | [AllocRef_ALLF]       | ?                             | 16801.00        | ?             | ?                | 01/08/2018 | 31/07/2019 | ALLF          | ALLF1819            | Contract Allocation |

    # Check that the Contract Deliverables have been created correctly in CRM
    Then  the following Contract Deliverables exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | DeliverableCode | DisplayOrder | ParentDeliverableCode | ContractDeliverableName               | ContractDeliverableDescription       | PlannedValue | PlannedVolume | UnitCost |
    | 10017320 | [ContractNo]       | [AllocRef_ALLF]       | 5               | 1            | ?                     | Advanced Learner Loans Facility       | ?                                    | 16801.00     | 0             | 0        |

    # Check that the Contract Deliverable Periods have been created correctly in CRM
    Then  the following Contract Deliverable Periods exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | DeliverableCode | Year | Month | PeriodType | Period  | PeriodName | PlannedValue | PlannedVolume | PaymentPosted |
    | 10017320 | [ContractNo]       | [AllocRef_ALLF]       | 5               | 2018 | 08    | CM         | Aug-18  | Aug-18     | 1117.00      | 0             | No            |
    | 10017320 | [ContractNo]       | [AllocRef_ALLF]       | 5               | 2018 | 09    | CM         | Sep-18  | Sep-18     | 841.00       | 0             | No            |
    | 10017320 | [ContractNo]       | [AllocRef_ALLF]       | 5               | 2018 | 10    | CM         | Oct-18  | Oct-18     | 873.00       | 0             | No            |
    | 10017320 | [ContractNo]       | [AllocRef_ALLF]       | 5               | 2018 | 11    | CM         | Nov-18  | Nov-18     | 776.00       | 0             | No            |
    | 10017320 | [ContractNo]       | [AllocRef_ALLF]       | 5               | 2018 | 12    | CM         | Dec-18  | Dec-18     | 1065.00      | 0             | No            |
    | 10017320 | [ContractNo]       | [AllocRef_ALLF]       | 5               | 2019 | 01    | CM         | Jan-19  | Jan-19     | 3200.00      | 0             | No            |
    | 10017320 | [ContractNo]       | [AllocRef_ALLF]       | 5               | 2019 | 02    | CM         | Feb-19  | Feb-19     | 592.00       | 0             | No            |
    | 10017320 | [ContractNo]       | [AllocRef_ALLF]       | 5               | 2019 | 03    | CM         | Mar-19  | Mar-19     | 1009.00      | 0             | No            |
    | 10017320 | [ContractNo]       | [AllocRef_ALLF]       | 5               | 2019 | 04    | CM         | Apr-19  | Apr-19     | 1962.00      | 0             | No            |
    | 10017320 | [ContractNo]       | [AllocRef_ALLF]       | 5               | 2019 | 05    | CM         | May-19  | May-19     | 508.00       | 0             | No            |
    | 10017320 | [ContractNo]       | [AllocRef_ALLF]       | 5               | 2019 | 06    | CM         | Jun-19  | Jun-19     | 3465.00      | 0             | No            |
    | 10017320 | [ContractNo]       | [AllocRef_ALLF]       | 5               | 2019 | 07    | CM         | Jul-19  | Jul-19     | 1393.00      | 0             | No            |

	
	
	
	# Check the contents of the Workflow History after the contract has been created in CRM
    Then  the Workflow History for version '1' of contract '[ContractNo]' includes the following
    | UKPRN    | ParentContract     | ContractNumber | ContractVersionNumber | Action                                      | CompletedBy     | NewContractOwner | NewTaskOwner                | NewStatus     | NewSubStatus            | PreviousContractOwner | PreviousTaskOwner   | PreviousStatus | PreviousSubStatus |
   #| 10017320 | [MasterContractNo] | [ContractNo]   | 1                     | Contract Created on Allocation Release      | CRM Integration | FCS2 Test        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | ?              | ?                 |
    | 10017320 | [MasterContractNo] | [ContractNo]   | 1                     | Record Imported (Task generated)            | CRM Integration | FCS2 TEST        | Document Management Team    | Draft         | Awaiting Documentation  | ?                     | ?                   | Draft          | ?                 |



    # Has a Task been created ?
    And   the following Tasks are present against version '1' of contract '[ContractNo]' for provider '10017320'
    | Task                                       | Description                                         | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Initiate Document Merge                    | 10017320 - 10017320 Co Ltd Awaiting documentation   | [ContractNo]   | Document Management Team  | ?                        | Open            | Not Started      |




    # Check CFS AllocationHistory in CRM
    Then  the following AllocationHistory details are present in CRM
    | ContractingUKPRN | AllocationRef     | Action                       | NewStatus           | NewSubStatus        | PreviousStatus      | PreviousSubStatus   | CompletedBy          |
    | 10017320         | 32001-ALLF005     | Release Successful           | Released            | Released            | In Release          | Release in Progress | CRM Integration      | 
    | 10017320         | 32001-ALLF005     | Initiate Release             | In Release          | Release in Progress | Pre-Release         | Ready for Release   | FCS8 Test      | 
    | 10017320         | 32001-ALLF005     | Confirm Ready for Release    | Pre-Release         | Ready for Release   | Pre-Release         | In Review           | CRM Integration      | 
    | 10017320         | 32001-ALLF005     | Record Imported              | Pre-Release         | In Review           | ?                   | ?                   | CRM Integration      | 

    # Check the row count in the CRM AllocationHistory table
    And   there are '4' rows in the AllocationHistory table in CRM for UKPRN '10017320'




    # Publish and approve contract

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the latest version of contract '[ContractNo]' is in a state of 'Published to Provider'

    # Change the date
    Given the override date is '11/07/2018'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'


    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017320 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017320 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '48' deliverable period rows in CRM linked to the latest version of contract 'LOANS-nnnn'
	And   there are '48' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'




    # Add actuals to the contract

    # Change the date
    Given the override date is '04/01/2019'

    # Clear down the stub
    And there are no entries in the DCFS stub table

    # Pull actuals from DC for Oct 2018
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR1819        | R03                  | ORG0017320     | CM             | 201808 | ALLF1819                | [AllocRef_ALLF]          | ?          | 2               | 0            | 2197.22     |
    | ILR1819        | R03                  | ORG0017320     | CM             | 201808 | ALLF1819                | [AllocRef_ALLF]          | ?          | 6               | 0            | 223.00      |
    | ILR1819        | R03                  | ORG0017320     | CM             | 201808 | ALLF1819                | [AllocRef_ALLF]          | ?          | 7               | 0            | 599.00      |
    #
    | ILR1819        | R03                  | ORG0017320     | CM             | 201809 | ALLF1819                | [AllocRef_ALLF]          | ?          | 2               | 0            | 360.90      |
    | ILR1819        | R03                  | ORG0017320     | CM             | 201809 | ALLF1819                | [AllocRef_ALLF]          | ?          | 6               | 0            | 2455.54     |
    | ILR1819        | R03                  | ORG0017320     | CM             | 201809 | ALLF1819                | [AllocRef_ALLF]          | ?          | 7               | 0            | 1480.65     |
    #
    | ILR1819        | R03                  | ORG0017320     | CM             | 201810 | ALLF1819                | [AllocRef_ALLF]          | ?          | 2               | 0            | 928.21      |
    | ILR1819        | R03                  | ORG0017320     | CM             | 201810 | ALLF1819                | [AllocRef_ALLF]          | ?          | 6               | 0            | 2066.83     |
    | ILR1819        | R03                  | ORG0017320     | CM             | 201810 | ALLF1819                | [AllocRef_ALLF]          | ?          | 7               | 0            | 1857.09     |
    #
    | ILR1819        | R03                  | ORG0017320     | CM             | 201811 | ALLF1819                | [AllocRef_ALLF]          | ?          | 2               | 0            | 2318.01     |
    | ILR1819        | R03                  | ORG0017320     | CM             | 201811 | ALLF1819                | [AllocRef_ALLF]          | ?          | 6               | 0            | 1890.17     |
    | ILR1819        | R03                  | ORG0017320     | CM             | 201811 | ALLF1819                | [AllocRef_ALLF]          | ?          | 7               | 0            | 1358.89     |
    #
    | ILR1819        | R03                  | ORG0017320     | CM             | 201812 | ALLF1819                | [AllocRef_ALLF]          | ?          | 2               | 0            | 447.11      |
    | ILR1819        | R03                  | ORG0017320     | CM             | 201812 | ALLF1819                | [AllocRef_ALLF]          | ?          | 6               | 0            | 949.28      |
    | ILR1819        | R03                  | ORG0017320     | CM             | 201812 | ALLF1819                | [AllocRef_ALLF]          | ?          | 7               | 0            | 1792.25     |
    #
    | ILR1819        | R03                  | ORG0017320     | CM             | 201901 | ALLF1819                | [AllocRef_ALLF]          | ?          | 2               | 0            | 464.96      |
    | ILR1819        | R03                  | ORG0017320     | CM             | 201901 | ALLF1819                | [AllocRef_ALLF]          | ?          | 6               | 0            | 2492.00     |
    | ILR1819        | R03                  | ORG0017320     | CM             | 201901 | ALLF1819                | [AllocRef_ALLF]          | ?          | 7               | 0            | 2125.40     |
    #
    | ILR1819        | R03                  | ORG0017320     | CM             | 201902 | ALLF1819                | [AllocRef_ALLF]          | ?          | 2               | 0            | 931.66      |
    | ILR1819        | R03                  | ORG0017320     | CM             | 201902 | ALLF1819                | [AllocRef_ALLF]          | ?          | 6               | 0            | 443.39      |
    | ILR1819        | R03                  | ORG0017320     | CM             | 201902 | ALLF1819                | [AllocRef_ALLF]          | ?          | 7               | 0            | 1366.66     |
    #
    | ILR1819        | R03                  | ORG0017320     | CM             | 201903 | ALLF1819                | [AllocRef_ALLF]          | ?          | 2               | 0            | 2471.52     |
    | ILR1819        | R03                  | ORG0017320     | CM             | 201903 | ALLF1819                | [AllocRef_ALLF]          | ?          | 6               | 0            | 2382.98     |
    | ILR1819        | R03                  | ORG0017320     | CM             | 201903 | ALLF1819                | [AllocRef_ALLF]          | ?          | 7               | 0            | 1220.50     |
    #
    | ILR1819        | R03                  | ORG0017320     | CM             | 201904 | ALLF1819                | [AllocRef_ALLF]          | ?          | 2               | 0            | 1042.17     |
    | ILR1819        | R03                  | ORG0017320     | CM             | 201904 | ALLF1819                | [AllocRef_ALLF]          | ?          | 6               | 0            | 424.48      |
    | ILR1819        | R03                  | ORG0017320     | CM             | 201904 | ALLF1819                | [AllocRef_ALLF]          | ?          | 7               | 0            | 1385.60     |
    #
    | ILR1819        | R03                  | ORG0017320     | CM             | 201905 | ALLF1819                | [AllocRef_ALLF]          | ?          | 2               | 0            | 2228.08     |
    | ILR1819        | R03                  | ORG0017320     | CM             | 201905 | ALLF1819                | [AllocRef_ALLF]          | ?          | 6               | 0            | 2173.16     |
    | ILR1819        | R03                  | ORG0017320     | CM             | 201905 | ALLF1819                | [AllocRef_ALLF]          | ?          | 7               | 0            | 1970.39     |
    #
    | ILR1819        | R03                  | ORG0017320     | CM             | 201906 | ALLF1819                | [AllocRef_ALLF]          | ?          | 2               | 0            | 1731.27     |
    | ILR1819        | R03                  | ORG0017320     | CM             | 201906 | ALLF1819                | [AllocRef_ALLF]          | ?          | 6               | 0            | 1240.87     |
    | ILR1819        | R03                  | ORG0017320     | CM             | 201906 | ALLF1819                | [AllocRef_ALLF]          | ?          | 7               | 0            | 785.35      |
    #
    | ILR1819        | R03                  | ORG0017320     | CM             | 201907 | ALLF1819                | [AllocRef_ALLF]          | ?          | 2               | 0            | 582.04      |
    | ILR1819        | R03                  | ORG0017320     | CM             | 201907 | ALLF1819                | [AllocRef_ALLF]          | ?          | 6               | 0            | 1551.58     |
    | ILR1819        | R03                  | ORG0017320     | CM             | 201907 | ALLF1819                | [AllocRef_ALLF]          | ?          | 7               | 0            | 1014.11     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service


    # Check CRM and PaaS
	
	# Check the ACTUAL VALUES in CRM
	# Actuals are not paid by the SFA but Reconciliation and Net fields will have non-zero values for deliverable 7 to reflect what has been paid by the Student Loans Company 
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | [ContractNo]   | [AllocRef_ALLF] | 2               | 15703.15 | 2197.22  | 360.90   | 928.21   | 2318.01  | 447.11   | 464.96   | 931.66   | 2471.52  | 1042.17  | 2228.08  | 1731.27  | 582.04   | 
    | [ContractNo]   | [AllocRef_ALLF] | 5               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_ALLF] | 6               | 18293.28 | 223.00   | 2455.54  | 2066.83  | 1890.17  | 949.28   | 2492.00  | 443.39   | 2382.98  | 424.48   | 2173.16  | 1240.87  | 1551.58  | 
    | [ContractNo]   | [AllocRef_ALLF] | 7               | 16955.89 | 599.00   | 1480.65  | 1857.09  | 1358.89  | 1792.25  | 2125.40  | 1366.66  | 1220.50  | 1385.60  | 1970.39  | 785.35   | 1014.11  | 	
	
    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | [ContractNo]   | [AllocRef_ALLF] | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_ALLF] | 5               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_ALLF] | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_ALLF] | 7               | 7087.88  | 599.00   | 1480.65  | 1857.09  | 1358.89  | 1792.25  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | [ContractNo]   | [AllocRef_ALLF] | 2               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_ALLF] | 5               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_ALLF] | 6               | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_ALLF] | 7               | 7087.88  | 599.00   | 1480.65  | 1857.09  | 1358.89  | 1792.25  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 


    # Check the contents of the PaaS PaymentSchedule.DeliverablePayment table 
    Then  the PaymentSchedule.DeliverablePayment table contains the following values 
    | AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualVolume | ActualValue |
    | [AllocRef_ALLF]  | 1             | 2               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 2197.22     |
    | [AllocRef_ALLF]  | 1             | 5               | 201808 | 2              | 0             | 1117.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | [AllocRef_ALLF]  | 1             | 6               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 223.00      |
    | [AllocRef_ALLF]  | 1             | 7               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 599.00                      | 599.00           | 0            | 599.00      |
    #
    | [AllocRef_ALLF]  | 1             | 2               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 360.90      |
    | [AllocRef_ALLF]  | 1             | 5               | 201809 | 2              | 0             | 841.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | [AllocRef_ALLF]  | 1             | 6               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 2455.54     |
    | [AllocRef_ALLF]  | 1             | 7               | 201809 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1480.65                     | 1480.65          | 0            | 1480.65     |
    #
    | [AllocRef_ALLF]  | 1             | 2               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 928.21      |
    | [AllocRef_ALLF]  | 1             | 5               | 201810 | 2              | 0             | 873.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | [AllocRef_ALLF]  | 1             | 6               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 2066.83     |
    | [AllocRef_ALLF]  | 1             | 7               | 201810 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1857.09                     | 1857.09          | 0            | 1857.09     |
    #
    | [AllocRef_ALLF]  | 1             | 2               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 2318.01     |
    | [AllocRef_ALLF]  | 1             | 5               | 201811 | 2              | 0             | 776.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | [AllocRef_ALLF]  | 1             | 6               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1890.17     |
    | [AllocRef_ALLF]  | 1             | 7               | 201811 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1358.89                     | 1358.89          | 0            | 1358.89     |
    #
    | [AllocRef_ALLF]  | 1             | 2               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 447.11      |
    | [AllocRef_ALLF]  | 1             | 5               | 201812 | 2              | 0             | 1065.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | [AllocRef_ALLF]  | 1             | 6               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 949.28      |
    | [AllocRef_ALLF]  | 1             | 7               | 201812 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1792.25                     | 1792.25          | 0            | 1792.25     |
    #
    | [AllocRef_ALLF]  | 1             | 2               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 464.96      |
    | [AllocRef_ALLF]  | 1             | 5               | 201901 | 2              | 0             | 3200.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | [AllocRef_ALLF]  | 1             | 6               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 2492.00     |
    | [AllocRef_ALLF]  | 1             | 7               | 201901 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 2125.40     |
    #
    | [AllocRef_ALLF]  | 1             | 2               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 931.66      |
    | [AllocRef_ALLF]  | 1             | 5               | 201902 | 2              | 0             | 592.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | [AllocRef_ALLF]  | 1             | 6               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 443.39      |
    | [AllocRef_ALLF]  | 1             | 7               | 201902 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1366.66     |
    #
    | [AllocRef_ALLF]  | 1             | 2               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 2471.52     |
    | [AllocRef_ALLF]  | 1             | 5               | 201903 | 2              | 0             | 1009.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | [AllocRef_ALLF]  | 1             | 6               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 2382.98     |
    | [AllocRef_ALLF]  | 1             | 7               | 201903 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1220.50     |
    #
    | [AllocRef_ALLF]  | 1             | 2               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1042.17     |
    | [AllocRef_ALLF]  | 1             | 5               | 201904 | 2              | 0             | 1962.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | [AllocRef_ALLF]  | 1             | 6               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 424.48      |
    | [AllocRef_ALLF]  | 1             | 7               | 201904 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1385.60     |
    #
    | [AllocRef_ALLF]  | 1             | 2               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 2228.08     |
    | [AllocRef_ALLF]  | 1             | 5               | 201905 | 2              | 0             | 508.00       | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | [AllocRef_ALLF]  | 1             | 6               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 2173.16     |
    | [AllocRef_ALLF]  | 1             | 7               | 201905 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1970.39     |
    #
    | [AllocRef_ALLF]  | 1             | 2               | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1731.27     |
    | [AllocRef_ALLF]  | 1             | 5               | 201906 | 2              | 0             | 3465.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | [AllocRef_ALLF]  | 1             | 6               | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1240.87     |
    | [AllocRef_ALLF]  | 1             | 7               | 201906 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 785.35      |
    #
    | [AllocRef_ALLF]  | 1             | 2               | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 582.04      |
    | [AllocRef_ALLF]  | 1             | 5               | 201907 | 2              | 0             | 1393.00      | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 0.00        |
    | [AllocRef_ALLF]  | 1             | 6               | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1551.58     |
    | [AllocRef_ALLF]  | 1             | 7               | 201907 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | 0            | 1014.11     |



	# Tidy up
    Then  the override date is reset

