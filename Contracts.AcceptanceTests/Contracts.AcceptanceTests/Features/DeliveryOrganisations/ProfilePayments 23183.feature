Feature: ProfilePayments 23183

@AcceptanceTest @Withdrawn20200717
@Long2Run @Long2Run45
Scenario: A500 Create a 1718 1619F(EFA) contract with a Delivery Org. Run Tasks to Published. Approve. Check Financials. Amend (fail then ok) and approve. Check Financials. Check Delivery Org is shown on the feeds
    Given there are no allocations marked as Under Termination for UKPRN '10017500' 
    And   there are no terminated or closed allocations for UKPRN '10017500' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017500' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017500' 

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | 16LR-500      |
    | NMF-500       |
    | SSF-500       |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP            |
    | 1619LR1718     |
    | NMF1718        |
    | SSF1718        |




    # Set organisation and advisors for Provider
    Given there is no Organisation data for UKPRN '10017500' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017500 Co Ltd' with UKPRN '10017500' and OrgId 'ORG0017500' and has 'FCS1 Test' as a manager 
    And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017500' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017500 | 117500 | 10017500 Co Ltd | 0              | Active                | Yes           | AA017500      | ?             | 9 Kneesworth Street    | ?                      | ?                      | ?                      | Royston                | Hertfordshire          | SG8 5AA   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017500 |


    # Set organisation and advisors for Delivery Org
    Given there is no Organisation data for UKPRN '10022276' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10022276 Co Ltd' with UKPRN '10022276' and OrgId 'ORG0022276' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10022276' 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10022276 | 122276 | 10022276 Co Ltd | 0              | Active                | Yes           | AA022276      | ?             | 4 Kneesworth Gardens   | ?                      | ?                      | ?                      | Royston                | Hertfordshire          | SG8 5AA   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10022276 |

	


    # Change the date
    Given the override date is '01/07/2017'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017500 | 10017500 Co Ltd      | ESFA-500             | 1619F-500      | 1                     | 01/08/2017        | 31/07/2018      | 214067.00     |                                    | 16-19 Funding                              | 1718   | New          | ORG0017500 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017500 | 1619F-500      | 16LR-500      | 1619LR            | 1619LR1718              | AY                      | 01/08/2017          | 31/07/2018        | 46741.00        |                                         |            | 10022276 Co Ltd (10022276)                                  | New          | 10022276    |
    | 10017500 | 1619F-500      | NMF-500       | NMF               | NMF1718                 | AY                      | 01/08/2017          | 31/07/2018        | 90474.00        |                                         |            | 10022276 Co Ltd (10022276)                                  | New          | 10022276    |
    | 10017500 | 1619F-500      | SSF-500       | SSF               | SSF1718                 | AY                      | 01/08/2017          | 31/07/2018        | 76852.00        |                                         |            | 10022276 Co Ltd (10022276)                                  | New          | 10022276    |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017500 | 1619F-500      | 16LR-500      | 8               | 0                     | 25556.00  | 822.00   | 797.00   | 3589.00  | 2616.00  | 852.00   | 2442.00  | 3337.00  | 654.00   | 3035.00  | 575.00   | 3273.00  | 3564.00  | 16-19 Transitional Protection                                   | New          | 10022276    |
    | 10017500 | 1619F-500      | 16LR-500      | 18              | 0                     | 19879.00  | 1536.00  | 691.00   | 508.00   | 73.00    | 1378.00  | 1165.00  | 2786.00  | 642.00   | 2391.00  | 2811.00  | 2534.00  | 3364.00  | 16-19 Resource Management (16-19)                               | New          | 10022276    |
    | 10017500 | 1619F-500      | 16LR-500      | 19              | 0                     | 26862.00  | 3180.00  | 531.00   | 2058.00  | 2162.00  | 2834.00  | 3536.00  | 3165.00  | 1559.00  | 2676.00  | 309.00   | 1742.00  | 3110.00  | 16-19 Bursary Funds                                             | New          | 10022276    |
    #
    | 10017500 | 1619F-500      | NMF-500       | 100             | 0                     | 26643.00  | 304.00   | 3698.00  | 2883.00  | 645.00   | 3659.00  | 3002.00  | 289.00   | 1025.00  | 3501.00  | 3476.00  | 2567.00  | 1594.00  | Strategic College Improvement Fund (SCIF)                       | New          | 10022276    |
    | 10017500 | 1619F-500      | NMF-500       | 101             | 0                     | 22405.00  | 950.00   | 2541.00  | 3435.00  | 753.00   | 3134.00  | 674.00   | 3371.00  | 3663.00  | 1805.00  | 960.00   | 777.00   | 342.00   | Principals Reference Group                                      | New          | 10022276    |
    | 10017500 | 1619F-500      | NMF-500       | 102             | 0                     | 23134.00  | 3552.00  | 3340.00  | 1260.00  | 2816.00  | 864.00   | 1284.00  | 1007.00  | 1838.00  | 2065.00  | 3118.00  | 943.00   | 1047.00  | National Leaders of Further Education (NLFE)                    | New          | 10022276    |
    | 10017500 | 1619F-500      | NMF-500       | 103             | 0                     | 18292.00  | 1329.00  | 2031.00  | 1660.00  | 54.00    | 1171.00  | 2505.00  | 237.00   | 1606.00  | 1201.00  | 450.00   | 2703.00  | 3345.00  | Forensic Unit                                                   | New          | 10022276    |
    #
    | 10017500 | 1619F-500      | SSF-500       | 16              | 0                     | 21147.00  | 2817.00  | 1339.00  | 3054.00  | 628.00   | 2471.00  | 643.00   | 1443.00  | 1008.00  | 2313.00  | 1117.00  | 2738.00  | 1576.00  | Free School Meals SSF                                           | New          | 10022276    |
    | 10017500 | 1619F-500      | SSF-500       | 17              | 0                     | 27885.00  | 3062.00  | 3482.00  | 3205.00  | 335.00   | 1545.00  | 2598.00  | 3141.00  | 3245.00  | 216.00   | 1901.00  | 1530.00  | 3625.00  | Maintained Special SSF Element 2                                | New          | 10022276    |
    | 10017500 | 1619F-500      | SSF-500       | 18              | 0                     | 27820.00  | 991.00   | 3309.00  | 57.00    | 1426.00  | 2004.00  | 1253.00  | 3506.00  | 3166.00  | 3205.00  | 3086.00  | 3442.00  | 2375.00  | Maintained Special SSF Student Support                          | New          | 10022276    |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Create a dummy Appendix file containing just the word 'Appendices'
    Given there are no files prefixed '10017500_1619F-500' in the Sharepoint '1619FUND-1718-Input-Appendices' folder
    And   a file with filename '10017500_1619F-500_v1.pdf' is created in '1619FUND-1718-Input-Appendices'

    # Create two dummy Terms and Conditions files. Each has just one page containing just the work 'Appendices'
    Given there are no files prefixed '10017500_1619F-500' in the Sharepoint '1619FUND-1718-Input-Terms And Conditions' folder
    And   a file with filename '10017500_1619F-500_11.pdf' is created in '1619FUND-1718-Input-Terms And Conditions'
    And   a file with filename '10017500_1619F-500_61.pdf' is created in '1619FUND-1718-Input-Terms And Conditions'



	# Process Tasks through to publication

    # Complete an existing open Task (Initiate Document Merge -> Review Contract Details)
    When  the following open Task currently linked to version '1' of contract '1619F-500' for provider '10017500' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Initiate Document Merge          | Document Management Team |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '1619F-500' for provider '10017500'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Review Contract Details          | 10017500 - 10017500 Co Ltd Please review the contract       | 1619F-500      | FCS2 Test                 | Contract Advisers Team   | Open            | Not Started      |


    # Complete an existing open Task (Review Contract Details -> Confirm Internal Approval)
    When  the following open Task currently linked to version '1' of contract '1619F-500' for provider '10017500' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Review Contract Details          | FCS2 Test                |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '1619F-500' for provider '10017500'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Internal Approval        | 10017500 - 10017500 Co Ltd                                  | 1619F-500      | FCS1 Test                 | Contract Managers Team   | Open            | Not Started      |


    # Complete an existing open Task (Confirm Internal Approval -> Confirm Publication to Provider)
    When  the following open Task currently linked to version '1' of contract '1619F-500' for provider '10017500' is triggered by User 'FCS1 Test'
    | Task                             | Owner                    |
    | Confirm Internal Approval        | FCS1 Test                |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract '1619F-500' for provider '10017500'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Publication to Provider  | 10017500 - 10017500 Co Ltd                                  | 1619F-500      | Lead Manager Team         | ?                        | Open            | Not Started      |


    # Complete an existing open Task (Confirm Publication to Provider -> End)
    When  the following open Task currently linked to version '1' of contract '1619F-500' for provider '10017500' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Confirm Publication to Provider  | Lead Manager Team        |


    # Check that the Tasks on the contract are all marked as completed
    Then  the following Tasks are present against version '1' of contract '1619F-500' for provider '10017500'
    | Task                             | Description                                                 | Regarding      | Owner                      | Assigned Team            | State           | Status           |
    | Confirm Publication to Provider  | 10017500 - 10017500 Co Ltd                                  | 1619F-500      | Lead Manager Team          | ?                        | Completed       | Completed        |
    | Confirm Internal Approval        | 10017500 - 10017500 Co Ltd                                  | 1619F-500      | FCS1 Test                  | Contract Managers Team   | Completed       | Completed        |
    | Review Contract Details          | 10017500 - 10017500 Co Ltd Please review the contract       | 1619F-500      | FCS2 Test                  | Contract Advisers Team   | Completed       | Completed        |
    | Initiate Document Merge          | 10017500 - 10017500 Co Ltd Awaiting documentation           | 1619F-500      | Document Management Team   | ?                        | Completed       | Completed        |

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017500 | 1619F-500          | 1                     | 0                        | Draft            | Published to Provider     | True          | False               | 01/08/2017        | 31/07/2018      | ?             |
    | 10017500 | ESFA-500           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |




    # Change the date
    Given the override date is '09/07/2017'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-500' and actual ContractNumber '1619F-500'

    # Check the CONTRACT version, status and dates in CRM.
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017500 | 1619F-500          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017500 | ESFA-500           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables (10x12=120)
    And   there are '120' deliverable period rows in CRM linked to the latest version of contract '1619F-500'


	# Check Financials

    # Check the PROFILE PAYMENTS in CRM on v1
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | 1619F-500      | 16LR-500           | 8               | 25556.00  | 822.00   | 797.00   | 3589.00  | 2616.00  | 852.00   | 2442.00  | 3337.00  | 654.00   | 3035.00  | 575.00   | 3273.00  | 3564.00  | 
    | 1619F-500      | 16LR-500           | 18              | 19879.00  | 1536.00  | 691.00   | 508.00   | 73.00    | 1378.00  | 1165.00  | 2786.00  | 642.00   | 2391.00  | 2811.00  | 2534.00  | 3364.00  | 
    | 1619F-500      | 16LR-500           | 19              | 26862.00  | 3180.00  | 531.00   | 2058.00  | 2162.00  | 2834.00  | 3536.00  | 3165.00  | 1559.00  | 2676.00  | 309.00   | 1742.00  | 3110.00  | 
    #
    | 1619F-500      | NMF-500            | 100             | 26643.00  | 304.00   | 3698.00  | 2883.00  | 645.00   | 3659.00  | 3002.00  | 289.00   | 1025.00  | 3501.00  | 3476.00  | 2567.00  | 1594.00  | 
    | 1619F-500      | NMF-500            | 101             | 22405.00  | 950.00   | 2541.00  | 3435.00  | 753.00   | 3134.00  | 674.00   | 3371.00  | 3663.00  | 1805.00  | 960.00   | 777.00   | 342.00   | 
    | 1619F-500      | NMF-500            | 102             | 23134.00  | 3552.00  | 3340.00  | 1260.00  | 2816.00  | 864.00   | 1284.00  | 1007.00  | 1838.00  | 2065.00  | 3118.00  | 943.00   | 1047.00  | 
    | 1619F-500      | NMF-500            | 103             | 18292.00  | 1329.00  | 2031.00  | 1660.00  | 54.00    | 1171.00  | 2505.00  | 237.00   | 1606.00  | 1201.00  | 450.00   | 2703.00  | 3345.00  | 
    #
    | 1619F-500      | SSF-500            | 16              | 21147.00  | 2817.00  | 1339.00  | 3054.00  | 628.00   | 2471.00  | 643.00   | 1443.00  | 1008.00  | 2313.00  | 1117.00  | 2738.00  | 1576.00  | 
    | 1619F-500      | SSF-500            | 17              | 27885.00  | 3062.00  | 3482.00  | 3205.00  | 335.00   | 1545.00  | 2598.00  | 3141.00  | 3245.00  | 216.00   | 1901.00  | 1530.00  | 3625.00  | 
    | 1619F-500      | SSF-500            | 18              | 27820.00  | 991.00   | 3309.00  | 57.00    | 1426.00  | 2004.00  | 1253.00  | 3506.00  | 3166.00  | 3205.00  | 3086.00  | 3442.00  | 2375.00  | 

    # Check the BALANCING PAYMENTS in CRM on v1
    And   the Balancing Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | 1619F-500      | 16LR-500           | 8               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | 1619F-500      | 16LR-500           | 18              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | 1619F-500      | 16LR-500           | 19              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | 1619F-500      | NMF-500            | 100             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | 1619F-500      | NMF-500            | 101             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | 1619F-500      | NMF-500            | 102             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | 1619F-500      | NMF-500            | 103             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #
    | 1619F-500      | SSF-500            | 16              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | 1619F-500      | SSF-500            | 17              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | 1619F-500      | SSF-500            | 18              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    
    # Check the PROFILE subnominal aggregations in PaaS
    Then  the PaymentGeneration.SubnominalAggregation table contains the following values 
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10022276 | ORG0022276 | 16LR-500          | 2202200         | 1619LR1718                 | 201708               | PROFILE         | CM             | False       | 1536.00         |
    | 10022276 | ORG0022276 | 16LR-500          | 2202200         | 1619LR1718                 | 201709               | PROFILE         | CM             | False       | 691.00          |
    | 10022276 | ORG0022276 | 16LR-500          | 2202200         | 1619LR1718                 | 201710               | PROFILE         | CM             | False       | 508.00          |
    | 10022276 | ORG0022276 | 16LR-500          | 2202200         | 1619LR1718                 | 201711               | PROFILE         | CM             | False       | 73.00           |
    | 10022276 | ORG0022276 | 16LR-500          | 2202200         | 1619LR1718                 | 201712               | PROFILE         | CM             | False       | 1378.00         |
    | 10022276 | ORG0022276 | 16LR-500          | 2202200         | 1619LR1718                 | 201801               | PROFILE         | CM             | False       | 1165.00         |
    | 10022276 | ORG0022276 | 16LR-500          | 2202200         | 1619LR1718                 | 201802               | PROFILE         | CM             | False       | 2786.00         |
    | 10022276 | ORG0022276 | 16LR-500          | 2202200         | 1619LR1718                 | 201803               | PROFILE         | CM             | False       | 642.00          |
    | 10022276 | ORG0022276 | 16LR-500          | 2202200         | 1619LR1718                 | 201804               | PROFILE         | CM             | False       | 2391.00         |
    | 10022276 | ORG0022276 | 16LR-500          | 2202200         | 1619LR1718                 | 201805               | PROFILE         | CM             | False       | 2811.00         |
    | 10022276 | ORG0022276 | 16LR-500          | 2202200         | 1619LR1718                 | 201806               | PROFILE         | CM             | False       | 2534.00         |
    | 10022276 | ORG0022276 | 16LR-500          | 2202200         | 1619LR1718                 | 201807               | PROFILE         | CM             | False       | 3364.00         |
    #
    | 10022276 | ORG0022276 | 16LR-500          | 2203003         | 1619LR1718                 | 201708               | PROFILE         | CM             | False       | 822.00          |
    | 10022276 | ORG0022276 | 16LR-500          | 2203003         | 1619LR1718                 | 201709               | PROFILE         | CM             | False       | 797.00          |
    | 10022276 | ORG0022276 | 16LR-500          | 2203003         | 1619LR1718                 | 201710               | PROFILE         | CM             | False       | 3589.00         |
    | 10022276 | ORG0022276 | 16LR-500          | 2203003         | 1619LR1718                 | 201711               | PROFILE         | CM             | False       | 2616.00         |
    | 10022276 | ORG0022276 | 16LR-500          | 2203003         | 1619LR1718                 | 201712               | PROFILE         | CM             | False       | 852.00          |
    | 10022276 | ORG0022276 | 16LR-500          | 2203003         | 1619LR1718                 | 201801               | PROFILE         | CM             | False       | 2442.00         |
    | 10022276 | ORG0022276 | 16LR-500          | 2203003         | 1619LR1718                 | 201802               | PROFILE         | CM             | False       | 3337.00         |
    | 10022276 | ORG0022276 | 16LR-500          | 2203003         | 1619LR1718                 | 201803               | PROFILE         | CM             | False       | 654.00          |
    | 10022276 | ORG0022276 | 16LR-500          | 2203003         | 1619LR1718                 | 201804               | PROFILE         | CM             | False       | 3035.00         |
    | 10022276 | ORG0022276 | 16LR-500          | 2203003         | 1619LR1718                 | 201805               | PROFILE         | CM             | False       | 575.00          |
    | 10022276 | ORG0022276 | 16LR-500          | 2203003         | 1619LR1718                 | 201806               | PROFILE         | CM             | False       | 3273.00         |
    | 10022276 | ORG0022276 | 16LR-500          | 2203003         | 1619LR1718                 | 201807               | PROFILE         | CM             | False       | 3564.00         |
    #
    | 10022276 | ORG0022276 | 16LR-500          | 2206036         | 1619LR1718                 | 201708               | PROFILE         | CM             | False       | 3180.00         |
    | 10022276 | ORG0022276 | 16LR-500          | 2206036         | 1619LR1718                 | 201709               | PROFILE         | CM             | False       | 531.00          |
    | 10022276 | ORG0022276 | 16LR-500          | 2206036         | 1619LR1718                 | 201710               | PROFILE         | CM             | False       | 2058.00         |
    | 10022276 | ORG0022276 | 16LR-500          | 2206036         | 1619LR1718                 | 201711               | PROFILE         | CM             | False       | 2162.00         |
    | 10022276 | ORG0022276 | 16LR-500          | 2206036         | 1619LR1718                 | 201712               | PROFILE         | CM             | False       | 2834.00         |
    | 10022276 | ORG0022276 | 16LR-500          | 2206036         | 1619LR1718                 | 201801               | PROFILE         | CM             | False       | 3536.00         |
    | 10022276 | ORG0022276 | 16LR-500          | 2206036         | 1619LR1718                 | 201802               | PROFILE         | CM             | False       | 3165.00         |
    | 10022276 | ORG0022276 | 16LR-500          | 2206036         | 1619LR1718                 | 201803               | PROFILE         | CM             | False       | 1559.00         |
    | 10022276 | ORG0022276 | 16LR-500          | 2206036         | 1619LR1718                 | 201804               | PROFILE         | CM             | False       | 2676.00         |
    | 10022276 | ORG0022276 | 16LR-500          | 2206036         | 1619LR1718                 | 201805               | PROFILE         | CM             | False       | 309.00          |
    | 10022276 | ORG0022276 | 16LR-500          | 2206036         | 1619LR1718                 | 201806               | PROFILE         | CM             | False       | 1742.00         |
    | 10022276 | ORG0022276 | 16LR-500          | 2206036         | 1619LR1718                 | 201807               | PROFILE         | CM             | False       | 3110.00         |
    #
    | 10022276 | ORG0022276 | NMF-500           | 2208000         | NMF1718                    | 201708               | PROFILE         | CM             | False       | 304.00          |
    | 10022276 | ORG0022276 | NMF-500           | 2208000         | NMF1718                    | 201709               | PROFILE         | CM             | False       | 3698.00         |
    | 10022276 | ORG0022276 | NMF-500           | 2208000         | NMF1718                    | 201710               | PROFILE         | CM             | False       | 2883.00         |
    | 10022276 | ORG0022276 | NMF-500           | 2208000         | NMF1718                    | 201711               | PROFILE         | CM             | False       | 645.00          |
    | 10022276 | ORG0022276 | NMF-500           | 2208000         | NMF1718                    | 201712               | PROFILE         | CM             | False       | 3659.00         |
    | 10022276 | ORG0022276 | NMF-500           | 2208000         | NMF1718                    | 201801               | PROFILE         | CM             | False       | 3002.00         |
    | 10022276 | ORG0022276 | NMF-500           | 2208000         | NMF1718                    | 201802               | PROFILE         | CM             | False       | 289.00          |
    | 10022276 | ORG0022276 | NMF-500           | 2208000         | NMF1718                    | 201803               | PROFILE         | CM             | False       | 1025.00         |
    | 10022276 | ORG0022276 | NMF-500           | 2208000         | NMF1718                    | 201804               | PROFILE         | CM             | False       | 3501.00         |
    | 10022276 | ORG0022276 | NMF-500           | 2208000         | NMF1718                    | 201805               | PROFILE         | CM             | False       | 3476.00         |
    | 10022276 | ORG0022276 | NMF-500           | 2208000         | NMF1718                    | 201806               | PROFILE         | CM             | False       | 2567.00         |
    | 10022276 | ORG0022276 | NMF-500           | 2208000         | NMF1718                    | 201807               | PROFILE         | CM             | False       | 1594.00         |
    #
    | 10022276 | ORG0022276 | NMF-500           | 2208100         | NMF1718                    | 201708               | PROFILE         | CM             | False       | 950.00          |
    | 10022276 | ORG0022276 | NMF-500           | 2208100         | NMF1718                    | 201709               | PROFILE         | CM             | False       | 2541.00         |
    | 10022276 | ORG0022276 | NMF-500           | 2208100         | NMF1718                    | 201710               | PROFILE         | CM             | False       | 3435.00         |
    | 10022276 | ORG0022276 | NMF-500           | 2208100         | NMF1718                    | 201711               | PROFILE         | CM             | False       | 753.00          |
    | 10022276 | ORG0022276 | NMF-500           | 2208100         | NMF1718                    | 201712               | PROFILE         | CM             | False       | 3134.00         |
    | 10022276 | ORG0022276 | NMF-500           | 2208100         | NMF1718                    | 201801               | PROFILE         | CM             | False       | 674.00          |
    | 10022276 | ORG0022276 | NMF-500           | 2208100         | NMF1718                    | 201802               | PROFILE         | CM             | False       | 3371.00         |
    | 10022276 | ORG0022276 | NMF-500           | 2208100         | NMF1718                    | 201803               | PROFILE         | CM             | False       | 3663.00         |
    | 10022276 | ORG0022276 | NMF-500           | 2208100         | NMF1718                    | 201804               | PROFILE         | CM             | False       | 1805.00         |
    | 10022276 | ORG0022276 | NMF-500           | 2208100         | NMF1718                    | 201805               | PROFILE         | CM             | False       | 960.00          |
    | 10022276 | ORG0022276 | NMF-500           | 2208100         | NMF1718                    | 201806               | PROFILE         | CM             | False       | 777.00          |
    | 10022276 | ORG0022276 | NMF-500           | 2208100         | NMF1718                    | 201807               | PROFILE         | CM             | False       | 342.00          |
    #
    | 10022276 | ORG0022276 | NMF-500           | 2208200         | NMF1718                    | 201708               | PROFILE         | CM             | False       | 3552.00         |
    | 10022276 | ORG0022276 | NMF-500           | 2208200         | NMF1718                    | 201709               | PROFILE         | CM             | False       | 3340.00         |
    | 10022276 | ORG0022276 | NMF-500           | 2208200         | NMF1718                    | 201710               | PROFILE         | CM             | False       | 1260.00         |
    | 10022276 | ORG0022276 | NMF-500           | 2208200         | NMF1718                    | 201711               | PROFILE         | CM             | False       | 2816.00         |
    | 10022276 | ORG0022276 | NMF-500           | 2208200         | NMF1718                    | 201712               | PROFILE         | CM             | False       | 864.00          |
    | 10022276 | ORG0022276 | NMF-500           | 2208200         | NMF1718                    | 201801               | PROFILE         | CM             | False       | 1284.00         |
    | 10022276 | ORG0022276 | NMF-500           | 2208200         | NMF1718                    | 201802               | PROFILE         | CM             | False       | 1007.00         |
    | 10022276 | ORG0022276 | NMF-500           | 2208200         | NMF1718                    | 201803               | PROFILE         | CM             | False       | 1838.00         |
    | 10022276 | ORG0022276 | NMF-500           | 2208200         | NMF1718                    | 201804               | PROFILE         | CM             | False       | 2065.00         |
    | 10022276 | ORG0022276 | NMF-500           | 2208200         | NMF1718                    | 201805               | PROFILE         | CM             | False       | 3118.00         |
    | 10022276 | ORG0022276 | NMF-500           | 2208200         | NMF1718                    | 201806               | PROFILE         | CM             | False       | 943.00          |
    | 10022276 | ORG0022276 | NMF-500           | 2208200         | NMF1718                    | 201807               | PROFILE         | CM             | False       | 1047.00         |
    #
    | 10022276 | ORG0022276 | NMF-500           | 2430670         | NMF1718                    | 201708               | PROFILE         | CM             | False       | 1329.00         |
    | 10022276 | ORG0022276 | NMF-500           | 2430670         | NMF1718                    | 201709               | PROFILE         | CM             | False       | 2031.00         |
    | 10022276 | ORG0022276 | NMF-500           | 2430670         | NMF1718                    | 201710               | PROFILE         | CM             | False       | 1660.00         |
    | 10022276 | ORG0022276 | NMF-500           | 2430670         | NMF1718                    | 201711               | PROFILE         | CM             | False       | 54.00           |
    | 10022276 | ORG0022276 | NMF-500           | 2430670         | NMF1718                    | 201712               | PROFILE         | CM             | False       | 1171.00         |
    | 10022276 | ORG0022276 | NMF-500           | 2430670         | NMF1718                    | 201801               | PROFILE         | CM             | False       | 2505.00         |
    | 10022276 | ORG0022276 | NMF-500           | 2430670         | NMF1718                    | 201802               | PROFILE         | CM             | False       | 237.00          |
    | 10022276 | ORG0022276 | NMF-500           | 2430670         | NMF1718                    | 201803               | PROFILE         | CM             | False       | 1606.00         |
    | 10022276 | ORG0022276 | NMF-500           | 2430670         | NMF1718                    | 201804               | PROFILE         | CM             | False       | 1201.00         |
    | 10022276 | ORG0022276 | NMF-500           | 2430670         | NMF1718                    | 201805               | PROFILE         | CM             | False       | 450.00          |
    | 10022276 | ORG0022276 | NMF-500           | 2430670         | NMF1718                    | 201806               | PROFILE         | CM             | False       | 2703.00         |
    | 10022276 | ORG0022276 | NMF-500           | 2430670         | NMF1718                    | 201807               | PROFILE         | CM             | False       | 3345.00         |
    #
    | 10022276 | ORG0022276 | SSF-500           | 2203007         | SSF1718                    | 201708               | PROFILE         | CM             | False       | 3062.00         |
    | 10022276 | ORG0022276 | SSF-500           | 2203007         | SSF1718                    | 201709               | PROFILE         | CM             | False       | 3482.00         |
    | 10022276 | ORG0022276 | SSF-500           | 2203007         | SSF1718                    | 201710               | PROFILE         | CM             | False       | 3205.00         |
    | 10022276 | ORG0022276 | SSF-500           | 2203007         | SSF1718                    | 201711               | PROFILE         | CM             | False       | 335.00          |
    | 10022276 | ORG0022276 | SSF-500           | 2203007         | SSF1718                    | 201712               | PROFILE         | CM             | False       | 1545.00         |
    | 10022276 | ORG0022276 | SSF-500           | 2203007         | SSF1718                    | 201801               | PROFILE         | CM             | False       | 2598.00         |
    | 10022276 | ORG0022276 | SSF-500           | 2203007         | SSF1718                    | 201802               | PROFILE         | CM             | False       | 3141.00         |
    | 10022276 | ORG0022276 | SSF-500           | 2203007         | SSF1718                    | 201803               | PROFILE         | CM             | False       | 3245.00         |
    | 10022276 | ORG0022276 | SSF-500           | 2203007         | SSF1718                    | 201804               | PROFILE         | CM             | False       | 216.00          |
    | 10022276 | ORG0022276 | SSF-500           | 2203007         | SSF1718                    | 201805               | PROFILE         | CM             | False       | 1901.00         |
    | 10022276 | ORG0022276 | SSF-500           | 2203007         | SSF1718                    | 201806               | PROFILE         | CM             | False       | 1530.00         |
    | 10022276 | ORG0022276 | SSF-500           | 2203007         | SSF1718                    | 201807               | PROFILE         | CM             | False       | 3625.00         |
    #
    | 10022276 | ORG0022276 | SSF-500           | 2206029         | SSF1718                    | 201708               | PROFILE         | CM             | False       | 991.00          |
    | 10022276 | ORG0022276 | SSF-500           | 2206029         | SSF1718                    | 201709               | PROFILE         | CM             | False       | 3309.00         |
    | 10022276 | ORG0022276 | SSF-500           | 2206029         | SSF1718                    | 201710               | PROFILE         | CM             | False       | 57.00           |
    | 10022276 | ORG0022276 | SSF-500           | 2206029         | SSF1718                    | 201711               | PROFILE         | CM             | False       | 1426.00         |
    | 10022276 | ORG0022276 | SSF-500           | 2206029         | SSF1718                    | 201712               | PROFILE         | CM             | False       | 2004.00         |
    | 10022276 | ORG0022276 | SSF-500           | 2206029         | SSF1718                    | 201801               | PROFILE         | CM             | False       | 1253.00         |
    | 10022276 | ORG0022276 | SSF-500           | 2206029         | SSF1718                    | 201802               | PROFILE         | CM             | False       | 3506.00         |
    | 10022276 | ORG0022276 | SSF-500           | 2206029         | SSF1718                    | 201803               | PROFILE         | CM             | False       | 3166.00         |
    | 10022276 | ORG0022276 | SSF-500           | 2206029         | SSF1718                    | 201804               | PROFILE         | CM             | False       | 3205.00         |
    | 10022276 | ORG0022276 | SSF-500           | 2206029         | SSF1718                    | 201805               | PROFILE         | CM             | False       | 3086.00         |
    | 10022276 | ORG0022276 | SSF-500           | 2206029         | SSF1718                    | 201806               | PROFILE         | CM             | False       | 3442.00         |
    | 10022276 | ORG0022276 | SSF-500           | 2206029         | SSF1718                    | 201807               | PROFILE         | CM             | False       | 2375.00         |
    #
    | 10022276 | ORG0022276 | SSF-500           | 2219140         | SSF1718                    | 201708               | PROFILE         | CM             | False       | 2817.00         |
    | 10022276 | ORG0022276 | SSF-500           | 2219140         | SSF1718                    | 201709               | PROFILE         | CM             | False       | 1339.00         |
    | 10022276 | ORG0022276 | SSF-500           | 2219140         | SSF1718                    | 201710               | PROFILE         | CM             | False       | 3054.00         |
    | 10022276 | ORG0022276 | SSF-500           | 2219140         | SSF1718                    | 201711               | PROFILE         | CM             | False       | 628.00          |
    | 10022276 | ORG0022276 | SSF-500           | 2219140         | SSF1718                    | 201712               | PROFILE         | CM             | False       | 2471.00         |
    | 10022276 | ORG0022276 | SSF-500           | 2219140         | SSF1718                    | 201801               | PROFILE         | CM             | False       | 643.00          |
    | 10022276 | ORG0022276 | SSF-500           | 2219140         | SSF1718                    | 201802               | PROFILE         | CM             | False       | 1443.00         |
    | 10022276 | ORG0022276 | SSF-500           | 2219140         | SSF1718                    | 201803               | PROFILE         | CM             | False       | 1008.00         |
    | 10022276 | ORG0022276 | SSF-500           | 2219140         | SSF1718                    | 201804               | PROFILE         | CM             | False       | 2313.00         |
    | 10022276 | ORG0022276 | SSF-500           | 2219140         | SSF1718                    | 201805               | PROFILE         | CM             | False       | 1117.00         |
    | 10022276 | ORG0022276 | SSF-500           | 2219140         | SSF1718                    | 201806               | PROFILE         | CM             | False       | 2738.00         |
    | 10022276 | ORG0022276 | SSF-500           | 2219140         | SSF1718                    | 201807               | PROFILE         | CM             | False       | 1576.00         |

    # Check the ContractManagement.AtomFeedItem (CM) feed for specific items and values (23185 and 23482)
    And   the Legal Contract Feed includes the following values
    | UKPRN    | ContractNumber | ContractVersion | ItemType | AllocationRef | DeliveryOrganisationUKPRN | DeliveryOrganisationProvider  |
    | 10017500 | 1619F-500      | 1               | 0        | 16LR-500      | 10022276                  | 10022276 Co Ltd               |
    | 10017500 | 1619F-500      | 1               | 1        | 16LR-500      | 10022276                  | 10022276 Co Ltd               |
    | 10017500 | 1619F-500      | 1               | 0        | NMF-500       | 10022276                  | 10022276 Co Ltd               |
    | 10017500 | 1619F-500      | 1               | 1        | NMF-500       | 10022276                  | 10022276 Co Ltd               |
    | 10017500 | 1619F-500      | 1               | 0        | SSF-500       | 10022276                  | 10022276 Co Ltd               |
    | 10017500 | 1619F-500      | 1               | 1        | SSF-500       | 10022276                  | 10022276 Co Ltd               |
	     
    # Check the AllocationDelivery.AllocationDeliveryEntry (ADP) feed for specific items and values (23186 and 23482)
    And   the ADP feed includes the following values
    | AllocationDeliveryEntryCategory | ADCode | ContractNumber | ContractVersionNumber | SubVersionNumber | AllocationNumber | DeliveryOrganisationUKPRN | DeliveryOrganisationProvider |
    | NewContractAllocationApproved   | 0      | 1619F-500      | 1                     | 0                | 16LR-500         | 10022276                  | 10022276 Co Ltd              |
    | NewContractAllocationApproved   | 0      | 1619F-500      | 1                     | 0                | NMF-500          | 10022276                  | 10022276 Co Ltd              |
    | NewContractAllocationApproved   | 0      | 1619F-500      | 1                     | 0                | SSF-500          | 10022276                  | 10022276 Co Ltd              |




	# Attempt to amend the file AFTER the contracting activity close date

	# Change the date
	Given the override date is '10/02/2020'

    # Bulk file to issue a Notification amendment (28558)  This should fail at syntax validation
    And   there are no files prefixed '10017500' in the Sharepoint '1619FUND-1718-Input-Appendices' folder
    And   there are no files prefixed '1619FUND AY 1718 19122019164219 v3_A500' in the Sharepoint 'Input' folder
    And   there are no files prefixed '1619FUND AY 1718 19122019164219 v3_A500' in the Sharepoint 'Processing' folder
    And   there are no files prefixed '1619FUND AY 1718 19122019164219 v3_A500' in the Sharepoint 'Processed' folder
    And   there are no files prefixed '1619FUND AY 1718 19122019164219 v3_A500' in the Sharepoint 'Reports' folder
    And   spreadsheet '1619FUND AY 1718 19122019164219 v3_A500.xlsx' exists in the Datafiles folder and UKPRN '10017500' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   
    # Fail (Happens when the override date is AFTER the contracting activity closed date)
	Then  a syntax report showing file failure should exist in the Sharepoint Reports folder
	And   the syntax report includes the phrase 'Contracting activity has closed for this Funding Type Period'




    # Attempt to amend the file BEFORE the contracting activity close date

	# Change the date
	Given the override date is '15/01/2020'

    # Bulk file to issue a Notification amendment (28558)  This should pass validation
    And   there are no files prefixed '10017500' in the Sharepoint '1619FUND-1718-Input-Appendices' folder
    And   there are no files prefixed '1619FUND AY 1718 19122019164219 v3_A500' in the Sharepoint 'Input' folder
    And   there are no files prefixed '1619FUND AY 1718 19122019164219 v3_A500' in the Sharepoint 'Processing' folder
    And   there are no files prefixed '1619FUND AY 1718 19122019164219 v3_A500' in the Sharepoint 'Processed' folder
    And   there are no files prefixed '1619FUND AY 1718 19122019164219 v3_A500' in the Sharepoint 'Reports' folder
    And   spreadsheet '1619FUND AY 1718 19122019164219 v3_A500.xlsx' exists in the Datafiles folder and UKPRN '10017500' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   
    # Success (Happens when the override date is BEFORE the contracting activity closed date)
	Then  a syntax report showing file success should exist in the Sharepoint Reports folder
	And   a results report should exist in the Sharepoint Reports folder
	And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report




    # Contract status is now at 'Awaiting Documentation'

#    # Create a dummy Appendix file containing just the word 'Appendices'
#    Given there are no files prefixed '10017500_1619F-500' in the Sharepoint '1619FUND-1718-Input-Appendices' folder
#    And   a file with filename '10017500_1619F-500_v1.pdf' is created in '1619FUND-1718-Input-Appendices'

    # Create a dummy Terms and Conditions file. Each has just one page containing just the work 'Appendices'
    Given there are no files prefixed '10017500_1619F-500' in the Sharepoint '1619FUND-1718-Input-Terms And Conditions' folder
    And   a file with filename '10017500_1619F-500_33.pdf' is created in '1619FUND-1718-Input-Terms And Conditions'




	# Process Tasks through to publication

    # Complete an existing open Task (Initiate Document Merge -> Review Contract Details)
    When  the following open Task currently linked to version '2' of contract '1619F-500' for provider '10017500' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Initiate Document Merge          | Document Management Team |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '2' of contract '1619F-500' for provider '10017500'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Review Contract Details          | 10017500 - 10017500 Co Ltd Please review the contract       | 1619F-500      | FCS2 Test                 | Contract Advisers Team   | Open            | Not Started      |


    # Complete an existing open Task (Review Contract Details -> Confirm Internal Approval)
    When  the following open Task currently linked to version '2' of contract '1619F-500' for provider '10017500' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Review Contract Details          | FCS2 Test                |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '2' of contract '1619F-500' for provider '10017500'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Internal Approval        | 10017500 - 10017500 Co Ltd                                  | 1619F-500      | FCS1 Test                 | Contract Managers Team   | Open            | Not Started      |


    # Complete an existing open Task (Confirm Internal Approval -> Confirm Publication to Provider)
    When  the following open Task currently linked to version '2' of contract '1619F-500' for provider '10017500' is triggered by User 'FCS1 Test'
    | Task                             | Owner                    |
    | Confirm Internal Approval        | FCS1 Test                |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '2' of contract '1619F-500' for provider '10017500'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Publication to Provider  | 10017500 - 10017500 Co Ltd                                  | 1619F-500      | Lead Manager Team         | ?                        | Open            | Not Started      |


    # Complete an existing open Task (Confirm Publication to Provider -> End)
    When  the following open Task currently linked to version '2' of contract '1619F-500' for provider '10017500' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Confirm Publication to Provider  | Lead Manager Team        |


    # Check that the Tasks on the contract are all marked as completed
    Then  the following Tasks are present against version '1' of contract '1619F-500' for provider '10017500'
    | Task                             | Description                                                 | Regarding      | Owner                      | Assigned Team            | State           | Status           |
    | Confirm Publication to Provider  | 10017500 - 10017500 Co Ltd                                  | 1619F-500      | Lead Manager Team          | ?                        | Completed       | Completed        |
    | Confirm Internal Approval        | 10017500 - 10017500 Co Ltd                                  | 1619F-500      | FCS1 Test                  | Contract Managers Team   | Completed       | Completed        |
    | Review Contract Details          | 10017500 - 10017500 Co Ltd Please review the contract       | 1619F-500      | FCS2 Test                  | Contract Advisers Team   | Completed       | Completed        |
    | Initiate Document Merge          | 10017500 - 10017500 Co Ltd Awaiting documentation           | 1619F-500      | Document Management Team   | ?                        | Completed       | Completed        |



	# Contract should auto-approve after publication because the amendment was a 'Notification' amendment

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017500 | 1619F-500          | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2017        | 31/07/2018      | Notification  |
    | 10017500 | 1619F-500          | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2017        | 31/07/2018      | ?             |
    | 10017500 | ESFA-500           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check the deliverable count in CRM  (10x12)+Jan'20(10x1)=130
    And   there are '120' deliverable period rows in CRM linked to the latest version of contract '1619F-500'


	# Check Financials

    # Check the PROFILE PAYMENTS in CRM on the latest approved contract (Amounts paid out against contract v1)
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Jan-20   |
    | 1619F-500      | 16LR-500           | 8               | 25556.00  | 822.00   | 797.00   | 3589.00  | 2616.00  | 852.00   | 2442.00  | 3337.00  | 654.00   | 3035.00  | 575.00   | 3273.00  | 3564.00  | 0.00     | 
    | 1619F-500      | 16LR-500           | 18              | 19879.00  | 1536.00  | 691.00   | 508.00   | 73.00    | 1378.00  | 1165.00  | 2786.00  | 642.00   | 2391.00  | 2811.00  | 2534.00  | 3364.00  | 0.00     | 
    | 1619F-500      | 16LR-500           | 19              | 26862.00  | 3180.00  | 531.00   | 2058.00  | 2162.00  | 2834.00  | 3536.00  | 3165.00  | 1559.00  | 2676.00  | 309.00   | 1742.00  | 3110.00  | 0.00     | 
    #
    | 1619F-500      | NMF-500            | 100             | 26643.00  | 304.00   | 3698.00  | 2883.00  | 645.00   | 3659.00  | 3002.00  | 289.00   | 1025.00  | 3501.00  | 3476.00  | 2567.00  | 1594.00  | 0.00     | 
    | 1619F-500      | NMF-500            | 101             | 22405.00  | 950.00   | 2541.00  | 3435.00  | 753.00   | 3134.00  | 674.00   | 3371.00  | 3663.00  | 1805.00  | 960.00   | 777.00   | 342.00   | 0.00     | 
    | 1619F-500      | NMF-500            | 102             | 23134.00  | 3552.00  | 3340.00  | 1260.00  | 2816.00  | 864.00   | 1284.00  | 1007.00  | 1838.00  | 2065.00  | 3118.00  | 943.00   | 1047.00  | 0.00     | 
    | 1619F-500      | NMF-500            | 103             | 18292.00  | 1329.00  | 2031.00  | 1660.00  | 54.00    | 1171.00  | 2505.00  | 237.00   | 1606.00  | 1201.00  | 450.00   | 2703.00  | 3345.00  | 0.00     | 
    #
    | 1619F-500      | SSF-500            | 16              | 21147.00  | 2817.00  | 1339.00  | 3054.00  | 628.00   | 2471.00  | 643.00   | 1443.00  | 1008.00  | 2313.00  | 1117.00  | 2738.00  | 1576.00  | 0.00     | 
    | 1619F-500      | SSF-500            | 17              | 27885.00  | 3062.00  | 3482.00  | 3205.00  | 335.00   | 1545.00  | 2598.00  | 3141.00  | 3245.00  | 216.00   | 1901.00  | 1530.00  | 3625.00  | 0.00     | 
    | 1619F-500      | SSF-500            | 18              | 27820.00  | 991.00   | 3309.00  | 57.00    | 1426.00  | 2004.00  | 1253.00  | 3506.00  | 3166.00  | 3205.00  | 3086.00  | 3442.00  | 2375.00  | 0.00     | 

    # Check the PLANNED VALUES in CRM on the latest approved contract (Amounts due to be paid after amendment to v2)
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Jan-20   |
    | 1619F-500      | 16LR-500           | 8               | 55865.00  | 5839.00  | 5181.00  | 3429.00  | 6572.00  | 5096.00  | 3684.00  | 5807.00  | 7389.00  | 4756.00  | 4703.00  | 2750.00  | 659.00   | 0.00     | 
    | 1619F-500      | 16LR-500           | 18              | 41726.00  | 4820.00  | 287.00   | 2208.00  | 4396.00  | 1561.00  | 4226.00  | 2071.00  | 2697.00  | 6657.00  | 4841.00  | 4448.00  | 3514.00  | 0.00     | 
    | 1619F-500      | 16LR-500           | 19              | 45505.00  | 6317.00  | 5860.00  | 1391.00  | 6022.00  | 1829.00  | 2731.00  | 2136.00  | 3920.00  | 4409.00  | 6670.00  | 1999.00  | 2221.00  | 0.00     | 
    #
    | 1619F-500      | NMF-500            | 100             | 54457.00  | 2241.00  | 4704.00  | 5266.00  | 5691.00  | 4417.00  | 287.00   | 4724.00  | 1476.00  | 6997.00  | 6338.00  | 4587.00  | 7729.00  | 0.00     | 
    | 1619F-500      | NMF-500            | 101             | 52489.00  | 6253.00  | 4841.00  | 6964.00  | 595.00   | 5913.00  | 5860.00  | 3907.00  | 1816.00  | 5978.00  | 1444.00  | 3365.00  | 5553.00  | 0.00     | 
    | 1619F-500      | NMF-500            | 102             | 62204.00  | 2718.00  | 5383.00  | 3228.00  | 3854.00  | 7814.00  | 5998.00  | 5606.00  | 4671.00  | 7474.00  | 7017.00  | 2548.00  | 5893.00  | 0.00     | 
    | 1619F-500      | NMF-500            | 103             | 41730.00  | 1699.00  | 2601.00  | 2007.00  | 3790.00  | 4279.00  | 6540.00  | 1869.00  | 2091.00  | 3535.00  | 5043.00  | 4247.00  | 4029.00  | 0.00     | 
    #
    | 1619F-500      | SSF-500            | 16              | 44251.00  | 7110.00  | 1218.00  | 5104.00  | 5125.00  | 1335.00  | 2641.00  | 4563.00  | 911.00   | 3915.00  | 741.00   | 4425.00  | 7163.00  | 0.00     | 
    | 1619F-500      | SSF-500            | 17              | 42285.00  | 3172.00  | 7195.00  | 963.00   | 7980.00  | 2832.00  | 263.00   | 3745.00  | 1250.00  | 2896.00  | 3798.00  | 3204.00  | 4987.00  | 0.00     | 
    | 1619F-500      | SSF-500            | 18              | 46163.00  | 7588.00  | 1898.00  | 3066.00  | 3289.00  | 4732.00  | 401.00   | 7556.00  | 4106.00  | 4393.00  | 1420.00  | 2387.00  | 5327.00  | 0.00     | 

    # Check the BALANCING PAYMENTS in CRM on the latest approved contract (Difference between v1 and v2 due to be paid in Jan-20) 
    And   the Balancing Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | Jan-20   |
    | 1619F-500      | 16LR-500           | 8               | 30309.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 30309.00 | 
    | 1619F-500      | 16LR-500           | 18              | 21847.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 21847.00 | 
    | 1619F-500      | 16LR-500           | 19              | 18643.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 18643.00 | 
    #
    | 1619F-500      | NMF-500            | 100             | 27814.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 27814.00 | 
    | 1619F-500      | NMF-500            | 101             | 30084.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 30084.00 | 
    | 1619F-500      | NMF-500            | 102             | 39070.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 39070.00 | 
    | 1619F-500      | NMF-500            | 103             | 23438.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 23438.00 | 
    #
    | 1619F-500      | SSF-500            | 16              | 23104.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 23104.00 | 
    | 1619F-500      | SSF-500            | 17              | 14400.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 14400.00 | 
    | 1619F-500      | SSF-500            | 18              | 18343.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 18343.00 | 


	# Check Subnominals in CRM

    # Check the PROFILE subnominal aggregations in CRM
    And   the Profile Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ProfileSubnominal        | Aug-17    | Sep-17    | Oct-17    | Nov-17    | Dec-17    | Jan-18    | Feb-18    | Mar-18    | Apr-18    | May-18    | Jun-18    | Jul-18    | Jan-20    |
    | 10022276 | 1619F-500      | 16LR-500           | 2202200                  | 1536.00   | 691.00    | 508.00    | 73.00     | 1378.00   | 1165.00   | 2786.00   | 642.00    | 2391.00   | 2811.00   | 2534.00   | 3364.00   | 21847.00  | 
    | 10022276 | 1619F-500      | 16LR-500           | 2203003                  | 822.00    | 797.00    | 3589.00   | 2616.00   | 852.00    | 2442.00   | 3337.00   | 654.00    | 3035.00   | 575.00    | 3273.00   | 3564.00   | 30309.00  | 
    | 10022276 | 1619F-500      | 16LR-500           | 2206036                  | 3180.00   | 531.00    | 2058.00   | 2162.00   | 2834.00   | 3536.00   | 3165.00   | 1559.00   | 2676.00   | 309.00    | 1742.00   | 3110.00   | 18643.00  | 
    | 10022276 | 1619F-500      | NMF-500            | 2208000                  | 304.00    | 3698.00   | 2883.00   | 645.00    | 3659.00   | 3002.00   | 289.00    | 1025.00   | 3501.00   | 3476.00   | 2567.00   | 1594.00   | 27814.00  | 
    | 10022276 | 1619F-500      | NMF-500            | 2208100                  | 950.00    | 2541.00   | 3435.00   | 753.00    | 3134.00   | 674.00    | 3371.00   | 3663.00   | 1805.00   | 960.00    | 777.00    | 342.00    | 30084.00  | 
    | 10022276 | 1619F-500      | NMF-500            | 2208200                  | 3552.00   | 3340.00   | 1260.00   | 2816.00   | 864.00    | 1284.00   | 1007.00   | 1838.00   | 2065.00   | 3118.00   | 943.00    | 1047.00   | 39070.00  | 
    | 10022276 | 1619F-500      | NMF-500            | 2430670                  | 1329.00   | 2031.00   | 1660.00   | 54.00     | 1171.00   | 2505.00   | 237.00    | 1606.00   | 1201.00   | 450.00    | 2703.00   | 3345.00   | 23438.00  | 
    | 10022276 | 1619F-500      | SSF-500            | 2203007                  | 3062.00   | 3482.00   | 3205.00   | 335.00    | 1545.00   | 2598.00   | 3141.00   | 3245.00   | 216.00    | 1901.00   | 1530.00   | 3625.00   | 14400.00  | 
    | 10022276 | 1619F-500      | SSF-500            | 2206029                  | 991.00    | 3309.00   | 57.00     | 1426.00   | 2004.00   | 1253.00   | 3506.00   | 3166.00   | 3205.00   | 3086.00   | 3442.00   | 2375.00   | 18343.00  | 
    | 10022276 | 1619F-500      | SSF-500            | 2219140                  | 2817.00   | 1339.00   | 3054.00   | 628.00    | 2471.00   | 643.00    | 1443.00   | 1008.00   | 2313.00   | 1117.00   | 2738.00   | 1576.00   | 23104.00  | 


	# Check Subnominals in PaaS

    # Check the PROFILE subnominal aggregations in PaaS for the 'extra' period 
    Then  the PaymentGeneration.SubnominalAggregation table contains the following values 
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10022276 | ORG0022276 | 16LR-500          | 2202200         | 1619LR1718                 | 202001               | PROFILE         | CM             | False       | 21847.00        |
    | 10022276 | ORG0022276 | 16LR-500          | 2203003         | 1619LR1718                 | 202001               | PROFILE         | CM             | False       | 30309.00        |
    | 10022276 | ORG0022276 | 16LR-500          | 2206036         | 1619LR1718                 | 202001               | PROFILE         | CM             | False       | 18643.00        |
    #
    | 10022276 | ORG0022276 | NMF-500           | 2208000         | NMF1718                    | 202001               | PROFILE         | CM             | False       | 27814.00        |
    | 10022276 | ORG0022276 | NMF-500           | 2208100         | NMF1718                    | 202001               | PROFILE         | CM             | False       | 30084.00        |
    | 10022276 | ORG0022276 | NMF-500           | 2208200         | NMF1718                    | 202001               | PROFILE         | CM             | False       | 39070.00        |
    | 10022276 | ORG0022276 | NMF-500           | 2430670         | NMF1718                    | 202001               | PROFILE         | CM             | False       | 23438.00        |
    #
    | 10022276 | ORG0022276 | SSF-500           | 2203007         | SSF1718                    | 202001               | PROFILE         | CM             | False       | 14400.00        |
    | 10022276 | ORG0022276 | SSF-500           | 2206029         | SSF1718                    | 202001               | PROFILE         | CM             | False       | 18343.00        |
    | 10022276 | ORG0022276 | SSF-500           | 2219140         | SSF1718                    | 202001               | PROFILE         | CM             | False       | 23104.00        |


    # Check Feeds

    # Check contents of the ContractManagement.AtomFeedItem (CM) feed for a Type 0 (Approval) event messages for v1 and v2
	#   Type 0 = Approval. Type 1 = 'Published to Provider'. Type 2 = Withdrawal. Type 3 = Closure. Type 4 = 'Contract Termination Initiated'. Type 5 = 'Contract Termination Cancelled'
    Then   the Legal Contract Feed includes the following values
    | UKPRN    | ContractNumber | ContractVersion | ItemType | AllocationRef | DeliveryOrganisationUKPRN | DeliveryOrganisationProvider  |
    | 10017500 | 1619F-500      | 1               | 0        | 16LR-500      | 10022276                  | 10022276 Co Ltd               |
    | 10017500 | 1619F-500      | 1               | 1        | 16LR-500      | 10022276                  | 10022276 Co Ltd               |
    | 10017500 | 1619F-500      | 1               | 0        | NMF-500       | 10022276                  | 10022276 Co Ltd               |
    | 10017500 | 1619F-500      | 1               | 1        | NMF-500       | 10022276                  | 10022276 Co Ltd               |
    | 10017500 | 1619F-500      | 1               | 0        | SSF-500       | 10022276                  | 10022276 Co Ltd               |
    | 10017500 | 1619F-500      | 1               | 1        | SSF-500       | 10022276                  | 10022276 Co Ltd               |
	#
    | 10017500 | 1619F-500      | 2               | 0        | 16LR-500      | 10022276                  | 10022276 Co Ltd               |
    | 10017500 | 1619F-500      | 2               | 1        | 16LR-500      | 10022276                  | 10022276 Co Ltd               |
    | 10017500 | 1619F-500      | 2               | 0        | NMF-500       | 10022276                  | 10022276 Co Ltd               |
    | 10017500 | 1619F-500      | 2               | 1        | NMF-500       | 10022276                  | 10022276 Co Ltd               |
    | 10017500 | 1619F-500      | 2               | 0        | SSF-500       | 10022276                  | 10022276 Co Ltd               |
    | 10017500 | 1619F-500      | 2               | 1        | SSF-500       | 10022276                  | 10022276 Co Ltd               |
	     
    # Check AllocationDelivery.AllocationDeliveryEntry (ADP) feed for type 0 (New Approval) and type 1 (Amendment Approval) events
    And   the ADP feed includes the following values
    | AllocationDeliveryEntryCategory    | ADCode | ContractNumber | ContractVersionNumber | SubVersionNumber | AllocationNumber | DeliveryOrganisationUKPRN | DeliveryOrganisationProvider |
    | NewContractAllocationApproved      | 0      | 1619F-500      | 1                     | 0                | 16LR-500         | 10022276                  | 10022276 Co Ltd              |
    | NewContractAllocationApproved      | 0      | 1619F-500      | 1                     | 0                | NMF-500          | 10022276                  | 10022276 Co Ltd              |
    | NewContractAllocationApproved      | 0      | 1619F-500      | 1                     | 0                | SSF-500          | 10022276                  | 10022276 Co Ltd              |
	#
    | AmendedContractAllocationApproved  | 1      | 1619F-500      | 2                     | 0                | 16LR-500         | 10022276                  | 10022276 Co Ltd              |
    | AmendedContractAllocationApproved  | 1      | 1619F-500      | 2                     | 0                | NMF-500          | 10022276                  | 10022276 Co Ltd              |
    | AmendedContractAllocationApproved  | 1      | 1619F-500      | 2                     | 0                | SSF-500          | 10022276                  | 10022276 Co Ltd              |


    # Tidy up
    And   the override date is reset

@AcceptanceTest @Withdrawn20210702
Scenario: A527 Create and approve an 1819 LOANS contract with just an ALLBC(PoP) allocation and no Delivery Org. Create PoP payment files. Check CRM and PaaS   
    Given there is no Contract, Task or Workflow data for UKPRN '10017527' 

	# Clear down the ADP and CM feeds
    And   the Allocation Delivery Monitoring Service atom feed is empty
	And   the Contract Management atom feed is empty

	# Clear down the subnominal data
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | ALLC-527      |

    # Clear down data from the CRM Organisation table
    And   there is no Organisation data for UKPRN '10017527'

#    # Add data to dbo.Organisations
#    And   the following Organisations exist in the FCT Organisation Service 
#    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber |
#    | 10017527 | 817527 | 10017527 Co Ltd | 0              | Active | Yes           | AA817527      | ?             |
#
#    # Add data to CRM Organisations table
#    And   the following Organisations exist in the CRM Organisations table
#    | UKPRN    | UPIN   | Name             | CompanyNumber | CharityNumber |
#    | 10017527 | 817527 | 10017527 Co Ltd  | AA017527      | ?             |
#
#    # Associate an Advisor with the main provider without creating an Org in CRM
#    And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017527'

    # Associate an Advisor with a provider and create an Org in CRM
   #And   caseload advisor 'FCS2 Test' is assigned to provider '10017527 Co Ltd' with UKPRN '10017527' and OrgId 'ORG0017527' already created and has 'FCS1 Test' as a manager
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017527 Co Ltd' with UKPRN '10017527' and OrgId 'ORG0017527' and has 'FCS1 Test' as a manager

    # Change the date
    And   the override date is '15/07/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription      | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017527 | 10017527 Co Ltd      | ESFA-527             | LOANS-527      | 1                     | 01/08/2018        | 31/07/2019      | 29426.00      |                          | Contract for Services | 1819   | New          | ORG0017527 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName        | UoPCode    | AllocationDescription     | CRMIntent    | DeliveryOrg |
    | 10017527 | LOANS-527      | ALLC-527      | ALLBC             | ALLBC1819               | AY                      | 01/08/2018          | 31/07/2019        | 29426.00        |                |            |                           | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableDescription                        | CRMIntent    | DeliveryOrg |
    | 10017527 | LOANS-527      | ALLC-527      | 1               | 0                     | 29426.00  | 3661.00  | 2846.00  | 608.00   | 3622.00  | 2965.00  | 252.00   | 988.00   | 3464.00  | 3439.00  | 2530.00  | 1557.00  | 3494.00  | Total Advanced Learner Loans Bursary Funding  | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Create a dummy Appendix file containing just the word 'Appendices'
    Given there are no files prefixed '10017527_LOANS-527' in the Sharepoint 'LOANS-1819-Input-Appendices' folder
    And   a file with filename '10017527_LOANS-527_v1.pdf' is created in 'LOANS-1819-Input-Appendices'

    # Create two dummy Terms and Conditions files. Each has just one page containing just the work 'Appendices'
    Given there are no files prefixed '10017527_LOANS-527' in the Sharepoint 'LOANS-1819-Input-Terms And Conditions' folder
    And   a file with filename '10017527_LOANS-527_11.pdf' is created in 'LOANS-1819-Input-Terms And Conditions'
    And   a file with filename '10017527_LOANS-527_61.pdf' is created in 'LOANS-1819-Input-Terms And Conditions'

    # Complete an existing open Task (Initiate Document Merge -> Review Contract Details)
    When  the following open Task currently linked to version '1' of contract 'LOANS-527' for provider '10017527' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Initiate Document Merge          | Document Management Team |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract 'LOANS-527' for provider '10017527'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Review Contract Details          | 10017527 - 10017527 Co Ltd Please review the contract       | LOANS-527      | FCS2 Test                | Contract Advisers Team   | Open            | Not Started      |


    # Complete an existing open Task (Review Contract Details -> Confirm Internal Approval)
    When  the following open Task currently linked to version '1' of contract 'LOANS-527' for provider '10017527' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Review Contract Details          | FCS2 Test               |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract 'LOANS-527' for provider '10017527'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Internal Approval        | 10017527 - 10017527 Co Ltd                                  | LOANS-527      | FCS1 Test                | Contract Managers Team   | Open            | Not Started      |


    # Complete an existing open Task (Confirm Internal Approval -> Confirm Publication to Provider)
    When  the following open Task currently linked to version '1' of contract 'LOANS-527' for provider '10017527' is triggered by User 'FCS1 Test'
    | Task                             | Owner                    |
    | Confirm Internal Approval        | FCS1 Test               |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract 'LOANS-527' for provider '10017527'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Publication to Provider  | 10017527 - 10017527 Co Ltd                                  | LOANS-527      | Lead Manager Team         | ?                        | Open            | Not Started      |


    # Complete an existing open Task (Confirm Publication to Provider -> End)
    When  the following open Task currently linked to version '1' of contract 'LOANS-527' for provider '10017527' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Confirm Publication to Provider  | Lead Manager Team        |

    # Check the CONTRACT version, status and dates in CRM.
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017527 | LOANS-527          | 1                     | 0                        | Draft            | Published to Provider     | True          | False               | 01/08/2018        | 31/07/2019      | ?             |
    | 10017527 | ESFA-527           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Change the date
    And   the override date is '16/07/2018'

    # Inject an SFS approval message
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-527' and actual ContractNumber 'LOANS-527'

    # Check that the contract is now approved
    Then  the latest version of contract 'LOANS-527' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017527 | LOANS-527          | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017527 | ESFA-527           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '48' deliverable period rows in CRM linked to the latest version of contract 'LOANS-527'

    # Check the PLANNED VALUES in CRM
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | LOANS-527      | ALLC-527        | 1               | 29426.00 | 3661.00  | 2846.00  | 608.00   | 3622.00  | 2965.00  | 252.00   | 988.00   | 3464.00  | 3439.00  | 2530.00  | 1557.00  | 3494.00  | 

    # Check the PROFILE subnominal aggregations in PaaS
    And   the PaymentGeneration.SubnominalAggregation table contains the following values 
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017527 | ORG0017527 | ALLC-527          | 2303900         | ALLBC1819                  | 201808               | PROFILE         | CM             | False       | 3661.00         |
    | 10017527 | ORG0017527 | ALLC-527          | 2303900         | ALLBC1819                  | 201809               | PROFILE         | CM             | False       | 2846.00         |
    | 10017527 | ORG0017527 | ALLC-527          | 2303900         | ALLBC1819                  | 201810               | PROFILE         | CM             | False       | 608.00          |
    | 10017527 | ORG0017527 | ALLC-527          | 2303900         | ALLBC1819                  | 201811               | PROFILE         | CM             | False       | 3622.00         |
    | 10017527 | ORG0017527 | ALLC-527          | 2303900         | ALLBC1819                  | 201812               | PROFILE         | CM             | False       | 2965.00         |
    | 10017527 | ORG0017527 | ALLC-527          | 2303900         | ALLBC1819                  | 201901               | PROFILE         | CM             | False       | 252.00          |
    | 10017527 | ORG0017527 | ALLC-527          | 2303900         | ALLBC1819                  | 201902               | PROFILE         | CM             | False       | 988.00          |
    | 10017527 | ORG0017527 | ALLC-527          | 2303900         | ALLBC1819                  | 201903               | PROFILE         | CM             | False       | 3464.00         |
    | 10017527 | ORG0017527 | ALLC-527          | 2303900         | ALLBC1819                  | 201904               | PROFILE         | CM             | False       | 3439.00         |
    | 10017527 | ORG0017527 | ALLC-527          | 2303900         | ALLBC1819                  | 201905               | PROFILE         | CM             | False       | 2530.00         |
    | 10017527 | ORG0017527 | ALLC-527          | 2303900         | ALLBC1819                  | 201906               | PROFILE         | CM             | False       | 1557.00         |
    | 10017527 | ORG0017527 | ALLC-527          | 2303900         | ALLBC1819                  | 201907               | PROFILE         | CM             | False       | 3494.00         |
  
    # Check the ContractManagement.AtomFeedItem (CM) feed for specific items and values (23185)
    And   the Legal Contract Feed includes the following values
    | UKPRN    | ContractNumber | ContractVersion | ItemType | AllocationRef | DeliveryOrganisationUKPRN | DeliveryOrganisationProvider |
    # ItemType 0 = Approved
	| 10017527 | LOANS-527      | 1               | 0        | ALLC-527      | ?                         | ?                            |
    # ItemType 1 = Published
    | 10017527 | LOANS-527      | 1               | 1        | ALLC-527      | ?                         | ?                            |
	     
	# Check the AllocationDelivery.AllocationDeliveryEntry (ADP) feed for specific items and values (23186)
   And   the ADP feed includes the following values
   | AllocationDeliveryEntryCategory   | ADCode | ContractNumber | ContractVersionNumber | SubVersionNumber | AllocationNumber | DeliveryOrganisationUKPRN | DeliveryOrganisationProvider |
   # ADCode 0 = New Approval
   | NewContractAllocationApproved     | 0      | LOANS-527      | 1                     | 0                | ALLC-527         | ?                         | ?                            | 

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Run the payment batch to create ALLBC (PoP) payment files in Maytech's FTP site
    Given the override date is '03/08/2018 22:05'

#   # Delete all NAT, PAY and ERR files from the Maytech FTP server
#   And   there are no files on the Maytech FTP server
    
    # This bit checks that there is something in PaaS. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | ALLC-527                 | 201808 |

	# PaymentGeneration.PaymentBatchFeedItem
	And   there is no data in the Payment feed for FundingStreamPeriod 'ALLBC1819' PaymentPeriod '201805' CensusEndDate '03/08/2018' and LinkCodeSuffix 'A'

    # PaymentGeneration.PaymentTimetable
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | ALLBC1819                  | 201808               |                      | A              | NotStarted |

#    # Coda.AccountCode
#    And   the following configuration exists in the Account Codes table
#    | Ukprn    | Funding Stream Period Code | Coda Code | Control Code | Effective Start Date | Effective End Date |
#    | 10017527 | ALLBC1819                  | CODA527   | 8115000      | 01/08/1990           | 31/08/2020         |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | ALLBC1819                  | 201808               | Completed |

#    # File created in Maytech FTP folder for 'Advanced Learner Loans Bursary (College)'
#    And   Payment file 'LBCO20180503A.pay' is created in the FTP Folder
#
#    # Save a copy of the output to the datafiles/Downloads folder
#    Given there is an encrypted file called 'LBCO20180503A.pay' in the Maytech FTP folder decrypt it then save it to 'DataFiles/Downloads'
#
#    Then  the following details are present in payment file 'LBCO20180503A.pay'
#    | LinkCode    | CompanyCode | Element1 | Element2 | Element3 | Element4 | Element5 | Element6 | Element7 | Element8 | Year | Period | Date       | Amount   | Dc   | LineType | Doc     | Desc                            | DueDate    | Tax | Extref1                       | Extref2     | Extref3 | Extref4 | Extref5  | Extref6 | Num   | DocLineNo |
#    | LBCO180503A | SFA         | AAA40    | +        | 8115000  | CODA527  | 02       | ALLC-527 | ?        | ?        | 2018 | 05     | 03/08/2018 | 3661.00  | 160  | 157      | LBCOP   | Adv LL Bursary Prf Aug18        | 15/08/2018 | ?   | ALLC PROFILE 2018/19          | LBCO180503A | ?       | ?       | 10017527 | 2303900 | 1     | 1         |
#    | LBCO180503A | SFA         | AAA40    | +        | 2303900  | 5000     | 02       | ALLC-527 | ?        | ?        | 2018 | 05     | 03/08/2018 | 3661.00  | 161  | 158      | LBCOP   | Adv LL Bursary Prf Aug18        | 15/08/2018 | VIO | ALLC PROFILE 2018/19          | LBCO180503A | ?       | ?       | 10017527 | CODA527 | 1     | 2         |

    # Tidy up
    And   the override date is reset
    And   the PaaS MonthEndIsRunning indicator is set to 'False'
	       
@AcceptanceTest @Withdrawn20210702
@Long2Run @Long2Run45
Scenario: A529 Create and approve an 1819 Mainstream contract (16TR and AEC) which has a Delivery Org different to the Contracting Org. Amend and Approve. Create PoP payment files. Execute a non-financial variation amendment. Check CRM and PaaS plus CM, ADP and Payment feeds
    Given there is no Contract, Task or Workflow data for UKPRN '10017529' 

	# Clear down the ADP and CM feeds
    And   the Allocation Delivery Monitoring Service atom feed is empty
	And   the Contract Management atom feed is empty

	# Clear down the subnominal data
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | 16TR-529      |
    | AEC-529       |

	# Clear down data from the CRM Organisation table
    And   there is no Organisation data for UKPRN '10017529'
    And   there is no Organisation data for UKPRN '10117529'

	# Add data to dbo.Organisations
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber |
    | 10017529 | 817529 | 10017529 Co Ltd | 0              | Active | Yes           | AA817529      | ?             |
    | 10117529 | 117529 | 10117529 Co Ltd | 0              | Active | Yes           | ?             | 117529        |

#    # Add data to CRM Organisations table
#    And   the following Organisations exist in the CRM Organisations table
#    | UKPRN    | UPIN   | Name             | CompanyNumber | CharityNumber |
#    | 10117529 | 117529 | 10117529 Co Ltd  | AA117529      | ?             |
#
#	 # Associate an Advisor with the main provider without creating an Org in CRM
#	 And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017529'

    # Associate an Advisor with a provider and create an Org in CRM
	And   caseload advisor 'FCS2 Test' is assigned to provider '10017529 Co Ltd' with UKPRN '10017529' and OrgId 'ORG0017529' and has 'FCS1 Test' as a manager
    And   caseload advisor 'FCS2 Test' is assigned to provider '10117529 Co Ltd' with UKPRN '10117529' and OrgId 'ORG0117529' and has 'FCS1 Test' as a manager
   #And   caseload advisor 'FCS2 Test' is assigned to provider '10017529 Co Ltd' with UKPRN '10017529' and OrgId 'ORG0017529' already created and has 'FCS1 Test' as a manager




    # Change the date
    Given the override date is '12/07/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017529 | 10017529 Co Ltd      | ESFA-529             | MAIN-529       | 1                     | 01/08/2018        | 31/07/2019      | 88227.00      |                                | Contract for Services | 1819   | New          | ORG0017529 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName     | UoPCode    | AllocationDescription       | CRMIntent    | DeliveryOrg |
    | 10017529 | MAIN-529       | 16TR-529      | 16-18TRN          | 16-18TRN1819            | AY                      | 01/08/2018          | 31/07/2019        | 40447.00        |             |            |                             | New          | 10117529    |
    | 10017529 | MAIN-529       | AEC-529       | AEBC              | AEBC1819                | AY                      | 01/08/2018          | 31/07/2019        | 47780.00        |             |            |                             | New          | 10117529    |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | DeliverableDescription                  | CRMIntent    | DeliveryOrg |
    | 10017529 | MAIN-529       | 16TR-529      | 1               | 0                     | 40447.00  | 1675.00  | 5803.00  | 1688.00  | 3568.00  | 4804.00  | 2209.00  | 4346.00  | 3308.00  | 2799.00  | 3637.00  | 876.00   | 5734.00  | Total 16-18 Traineeships Funding        | New          | 10117529    |
    | 10017529 | MAIN-529       | 16TR-529      | 2               | 1                     | 24699.00  | 876.00   | 2213.00  | 1395.00  | 3291.00  | 1819.00  | 755.00   | 2581.00  | 2816.00  | 2322.00  | 2944.00  | 648.00   | 3039.00  | 16-18 Traineeships Programme Funding    | New          | 10117529    |
    | 10017529 | MAIN-529       | 16TR-529      | 3               | 1                     | 15748.00  | 799.00   | 3590.00  | 293.00   | 277.00   | 2985.00  | 1454.00  | 1765.00  | 492.00   | 477.00   | 693.00   | 228.00   | 2695.00  | 16-18 Traineeships Bursary Funding      | New          | 10117529    |
    | 10017529 | MAIN-529       | AEC-529       | 1               | 0                     | 47780.00  | 2130.00  | 3771.00  | 2389.00  | 2850.00  | 6508.00  | 5854.00  | 4152.00  | 4987.00  | 5578.00  | 1452.00  | 3767.00  | 4342.00  | Adult Education Budget Total Funding    | New          | 10117529    |
    | 10017529 | MAIN-529       | AEC-529       | 13              | 1                     | 25619.00  | 2022.00  | 2126.00  | 852.00   | 1782.00  | 2812.00  | 2834.00  | 1526.00  | 3392.00  | 2810.00  | 377.00   | 2398.00  | 2688.00  | Community Learning                      | New          | 10117529    |
    | 10017529 | MAIN-529       | AEC-529       | 14              | 1                     | 22161.00  | 108.00   | 1645.00  | 1537.00  | 1068.00  | 3696.00  | 3020.00  | 2626.00  | 1595.00  | 2768.00  | 1075.00  | 1369.00  | 1654.00  | Other AEB Funding                       | New          | 10117529    |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Create a dummy Appendix file containing just the word 'Appendices'
    Given there are no files prefixed '10017529_MAIN-529' in the Sharepoint 'MAIN-1819-Input-Appendices' folder
    And   a file with filename '10017529_MAIN-529_v1.pdf' is created in 'MAIN-1819-Input-Appendices'

    # Create two dummy Terms and Conditions files. Each has just one page containing just the work 'Appendices'
    And   there are no files prefixed '10017529_MAIN-529' in the Sharepoint 'MAIN-1819-Input-Terms And Conditions' folder
    And   a file with filename '10017529_MAIN-529_11.pdf' is created in 'MAIN-1819-Input-Terms And Conditions'
    And   a file with filename '10017529_MAIN-529_61.pdf' is created in 'MAIN-1819-Input-Terms And Conditions'

    # Complete an existing open Task (Initiate Document Merge -> Review Contract Details)
    When  the following open Task currently linked to version '1' of contract 'MAIN-529' for provider '10017529' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Initiate Document Merge          | Document Management Team |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract 'MAIN-529' for provider '10017529'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Review Contract Details          | 10017529 - 10017529 Co Ltd Please review the contract       | MAIN-529       | FCS2 Test                | Contract Advisers Team   | Open            | Not Started      |


    # Complete an existing open Task (Review Contract Details -> Confirm Internal Approval)
    When  the following open Task currently linked to version '1' of contract 'MAIN-529' for provider '10017529' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Review Contract Details          | FCS2 Test               |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract 'MAIN-529' for provider '10017529'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Internal Approval        | 10017529 - 10017529 Co Ltd                                  | MAIN-529       | FCS1 Test                | Contract Managers Team   | Open            | Not Started      |


    # Complete an existing open Task (Confirm Internal Approval -> Confirm Publication to Provider)
    When  the following open Task currently linked to version '1' of contract 'MAIN-529' for provider '10017529' is triggered by User 'FCS1 Test'
    | Task                             | Owner                    |
    | Confirm Internal Approval        | FCS1 Test               |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '1' of contract 'MAIN-529' for provider '10017529'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Publication to Provider  | 10017529 - 10017529 Co Ltd                                  | MAIN-529       | Lead Manager Team         | ?                        | Open            | Not Started      |


    # Complete an existing open Task (Confirm Publication to Provider -> End)
    When  the following open Task currently linked to version '1' of contract 'MAIN-529' for provider '10017529' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Confirm Publication to Provider  | Lead Manager Team        |

    # Check the CONTRACT version, status and dates in CRM.
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017529 | MAIN-529           | 1                     | 0                        | Draft            | Published to Provider     | True          | False               | 01/08/2018        | 31/07/2019      | ?             |
    | 10017529 | ESFA-529           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |




    # Change the date
    Given the override date is '16/07/2018'

    # Inject an SFS approval message
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-529' and actual ContractNumber 'MAIN-529'

    # Check that the contract is now approved
    Then  the latest version of contract 'MAIN-529' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017529 | MAIN-529           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017529 | ESFA-529           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |




	# Change the date
	Given the override date is '18/07/2018'

    # Bulk variation amendment against v1 to create v2
    Given there are no files prefixed '10017529_MAIN' in the Sharepoint 'MAIN-1819-Input-Appendices' folder
    And   there are no files prefixed 'MAIN AY 1819 10052018170429 v3_A529' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'MAIN AY 1819 10052018170429 v3_A529' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'MAIN AY 1819 10052018170429 v3_A529' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'MAIN AY 1819 10052018170429 v3_A529' in the Sharepoint 'Reports' folder
    And   spreadsheet 'MAIN AY 1819 10052018170429 v3_A529.xlsx' exists in the Datafiles folder and UKPRN '10017529' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report
	 
	# Contract status is now at 'Awaiting Documentation'

    # Create two dummy Terms and Conditions files. Each has just one page containing just the work 'Appendices'
    Given there are no files prefixed '10017529_MAIN-529' in the Sharepoint 'MAIN-1819-Input-Terms And Conditions' folder
    And   a file with filename '10017529_MAIN-529_13.pdf' is created in 'MAIN-1819-Input-Terms And Conditions'
    And   a file with filename '10017529_MAIN-529_63.pdf' is created in 'MAIN-1819-Input-Terms And Conditions'

    # Complete an existing open Task (Initiate Document Merge -> Review Contract Details)
    When  the following open Task currently linked to version '2' of contract 'MAIN-529' for provider '10017529' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Initiate Document Merge          | Document Management Team |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '2' of contract 'MAIN-529' for provider '10017529'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Review Contract Details          | 10017529 - 10017529 Co Ltd Please review the contract       | MAIN-529       | FCS2 Test                 | Contract Advisers Team   | Open            | Not Started      |


    # Complete an existing open Task (Review Contract Details -> Confirm Internal Approval)
    When  the following open Task currently linked to version '2' of contract 'MAIN-529' for provider '10017529' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Review Contract Details          | FCS2 Test                |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '2' of contract 'MAIN-529' for provider '10017529'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Internal Approval        | 10017529 - 10017529 Co Ltd                                  | MAIN-529       | FCS1 Test                 | Contract Managers Team   | Open            | Not Started      |


    # Complete an existing open Task (Confirm Internal Approval -> Confirm Publication to Provider)
    When  the following open Task currently linked to version '2' of contract 'MAIN-529' for provider '10017529' is triggered by User 'FCS1 Test'
    | Task                             | Owner                    |
    | Confirm Internal Approval        | FCS1 Test                |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '2' of contract 'MAIN-529' for provider '10017529'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Publication to Provider  | 10017529 - 10017529 Co Ltd                                  | MAIN-529       | Lead Manager Team         | ?                        | Open            | Not Started      |


    # Complete an existing open Task (Confirm Publication to Provider -> End)
    When  the following open Task currently linked to version '2' of contract 'MAIN-529' for provider '10017529' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Confirm Publication to Provider  | Lead Manager Team        |

    # Check the CONTRACT version, status and dates in CRM.
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017529 | MAIN-529           | 2                     | 0                        | Draft            | Published to Provider     | True          | False               | 01/08/2018        | 31/07/2019      | Variation     |
    | 10017529 | MAIN-529           | 1                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2018        | 31/07/2019      | ?             |
    | 10017529 | ESFA-529           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |




    # Change the date
    Given the override date is '22/07/2018'

    # Inject an SFS approval message
    When  a contract approval message is received from SFS for version '2' actual MasterContractNumber 'ESFA-529' and actual ContractNumber 'MAIN-529'

    # Check that the contract is now approved
    Then  the latest version of contract 'MAIN-529' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017529 | MAIN-529           | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | Variation     |
    | 10017529 | MAIN-529           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2018        | 31/07/2019      | ?             |
    | 10017529 | ESFA-529           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '132' deliverable period rows in CRM linked to the latest version of contract 'MAIN-529'

    # Check the PLANNED VALUES in CRM
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-529       | 16TR-529        | 1               | 45886.00 | 2509.00  | 4228.00  | 4333.00  | 2701.00  | 4968.00  | 797.00   | 5728.00  | 7103.00  | 2978.00  | 1815.00  | 5305.00  | 3421.00  | 
    | MAIN-529       | 16TR-529        | 2               | 19919.00 | 1572.00  | 1162.00  | 71.00    | 2028.00  | 1109.00  | 230.00   | 1552.00  | 2537.00  | 897.00   | 865.00   | 4599.00  | 3297.00  | 
    | MAIN-529       | 16TR-529        | 3               | 25967.00 | 937.00   | 3066.00  | 4262.00  | 673.00   | 3859.00  | 567.00   | 4176.00  | 4566.00  | 2081.00  | 950.00   | 706.00   | 124.00   | 
    | MAIN-529       | AEC-529         | 1               | 64255.00 | 6854.00  | 2557.00  | 4230.00  | 4164.00  | 7998.00  | 5393.00  | 6939.00  | 4930.00  | 4693.00  | 5096.00  | 5202.00  | 6199.00  | 
    | MAIN-529       | AEC-529         | 13              | 34712.00 | 2178.00  | 1893.00  | 4062.00  | 1193.00  | 3533.00  | 4094.00  | 3724.00  | 4835.00  | 188.00   | 1596.00  | 3639.00  | 3777.00  | 
    | MAIN-529       | AEC-529         | 14              | 29543.00 | 4676.00  | 664.00   | 168.00   | 2971.00  | 4465.00  | 1299.00  | 3215.00  | 95.00    | 4505.00  | 3500.00  | 1563.00  | 2422.00  | 

    # Check the PROFILE subnominal aggregations in PaaS
    And   the PaymentGeneration.SubnominalAggregation table contains the following values 
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10117529 | ORG0117529 | AEC-529           | 2371010         | AEBC1819                   | 201808               | PROFILE         | CM             | False       | 6854.00         |
    | 10117529 | ORG0117529 | AEC-529           | 2371010         | AEBC1819                   | 201809               | PROFILE         | CM             | False       | 2557.00         |
    | 10117529 | ORG0117529 | AEC-529           | 2371010         | AEBC1819                   | 201810               | PROFILE         | CM             | False       | 4230.00         |
    | 10117529 | ORG0117529 | AEC-529           | 2371010         | AEBC1819                   | 201811               | PROFILE         | CM             | False       | 4164.00         |
    | 10117529 | ORG0117529 | AEC-529           | 2371010         | AEBC1819                   | 201812               | PROFILE         | CM             | False       | 7998.00         |
    | 10117529 | ORG0117529 | AEC-529           | 2371010         | AEBC1819                   | 201901               | PROFILE         | CM             | False       | 5393.00         |
    | 10117529 | ORG0117529 | AEC-529           | 2371010         | AEBC1819                   | 201902               | PROFILE         | CM             | False       | 6939.00         |
    | 10117529 | ORG0117529 | AEC-529           | 2371010         | AEBC1819                   | 201903               | PROFILE         | CM             | False       | 4930.00         |
    | 10117529 | ORG0117529 | AEC-529           | 2371010         | AEBC1819                   | 201904               | PROFILE         | CM             | False       | 4693.00         |
    | 10117529 | ORG0117529 | AEC-529           | 2371010         | AEBC1819                   | 201905               | PROFILE         | CM             | False       | 5096.00         |
    | 10117529 | ORG0117529 | AEC-529           | 2371010         | AEBC1819                   | 201906               | PROFILE         | CM             | False       | 5202.00         |
    | 10117529 | ORG0117529 | AEC-529           | 2371010         | AEBC1819                   | 201907               | PROFILE         | CM             | False       | 6199.00         |

    # Check the ContractManagement.AtomFeedItem (CM) feed for specific items and values (23185)
    And   the Legal Contract Feed includes the following values
    | UKPRN    | ContractNumber | ContractVersion | ItemType | AllocationRef | DeliveryOrganisationUKPRN | DeliveryOrganisationProvider |
    # ItemType 0 = Approved
	| 10017529 | MAIN-529       | 1               | 0        | 16TR-529      | 10117529                  | 10117529 Co Ltd              |
    | 10017529 | MAIN-529       | 1               | 0        | AEC-529       | 10117529                  | 10117529 Co Ltd              |
    | 10017529 | MAIN-529       | 2               | 0        | 16TR-529      | 10117529                  | 10117529 Co Ltd              |
    | 10017529 | MAIN-529       | 2               | 0        | AEC-529       | 10117529                  | 10117529 Co Ltd              |
    # ItemType 1 = Published
    | 10017529 | MAIN-529       | 1               | 1        | 16TR-529      | 10117529                  | 10117529 Co Ltd              |
    | 10017529 | MAIN-529       | 1               | 1        | AEC-529       | 10117529                  | 10117529 Co Ltd              |
    | 10017529 | MAIN-529       | 2               | 1        | 16TR-529      | 10117529                  | 10117529 Co Ltd              |
    | 10017529 | MAIN-529       | 2               | 1        | AEC-529       | 10117529                  | 10117529 Co Ltd              |

    # Check the AllocationDelivery.AllocationDeliveryEntry (ADP) feed for specific items and values (23186)
    And   the ADP feed includes the following values
    | AllocationDeliveryEntryCategory   | ADCode | ContractNumber | ContractVersionNumber | SubVersionNumber | AllocationNumber | DeliveryOrganisationUKPRN | DeliveryOrganisationProvider |
    # ADCode 0 = New Approval
	| NewContractAllocationApproved     | 0      | AEB-529        | 1                     | 0                | 16TR-529         | 10117529                  | 10117529 Co Ltd              | 
    | NewContractAllocationApproved     | 0      | AEB-529        | 1                     | 0                | AEC-529          | 10117529                  | 10117529 Co Ltd              | 
    # ADCode 1 = Amendment Approval
	| AmendedContractAllocationApproved | 1      | AEB-529        | 2                     | 0                | 16TR-529         | 10117529                  | 10117529 Co Ltd              | 
    | AmendedContractAllocationApproved | 1      | AEB-529        | 2                     | 0                | AEC-529          | 10117529                  | 10117529 Co Ltd              | 

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'




    # Run the payment batch to create AEBC (PoP) payment files in Maytech's FTP site
    Given the override date is '03/08/2018 22:05'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
	# Note: PaymentPeriod is the accounting year and month, eg for April 2018 the value would be 201801 not 201804
    And   there is no data in the Payment feed for FundingStreamPeriod 'AEBC1819' PaymentPeriod '201805' CensusEndDate '03/08/2018' and LinkCodeSuffix 'A'

#    # Delete all NAT, PAY and ERR files from the Maytech FTP server
#    And   there are no files on the Maytech FTP server
    
    # This bit checks that there is something in PaaS. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | AEC-529                  | 201808 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | AEBC1819                   | 201808               |                      | A              | NotStarted |

#    # Coda.AccountCode
#    And   the following configuration exists in the Account Codes table
#    | Ukprn    | Funding Stream Period Code | Coda Code | Control Code | Effective Start Date | Effective End Date |
#    | 10017529 | AEBC1819                   | CODA529   | 8115000      | 01/08/1990           | 31/08/2020         |
#    | 10117529 | AEBC1819                   | CODB529   | 8115000      | 01/08/1990           | 31/08/2020         |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | AEBC1819                   | 201808               | Completed |

#    # File created in Maytech FTP folder for 'Adult Education Budget (College)'
#    And   Payment file 'AECO20180503A.pay' is created in the FTP Folder
#
#    # Decrypt the payment file to the Output window and save a decrypted version to Datafiles/Downloads
#	Given there is an encrypted file called 'AECO20180503A.pay' in the Maytech FTP folder decrypt it then save it to 'DataFiles/Downloads'
#
#    Then  the following details are present in payment file 'AECO20180503A.pay'
#    | LinkCode    | CompanyCode | Element1 | Element2 | Element3 | Element4 | Element5 | Element6 | Element7 | Element8 | Year | Period | Date       | Amount   | Dc   | LineType | Doc     | Desc                            | DueDate    | Tax | Extref1                       | Extref2     | Extref3 | Extref4 | Extref5  | Extref6 | Num   | DocLineNo |
#    | AECO180503A | SFA         | AAA40    | +        | 8115000  | CODB529  | 02       | AEC-529  | ?        | ?        | 2018 | 05     | 03/08/2018 | 6854.00  | 160  | 157      | AECOP   | Adult Education Budg Prf Aug18  | 15/08/2018 | ?   | AEC PROFILE 2018/19           | AECO180503A | ?       | ?       | 10117529 | 2371010 | 1     | 1         |
#    | AECO180503A | SFA         | AAA40    | +        | 2371010  | 5000     | 02       | AEC-529  | ?        | ?        | 2018 | 05     | 03/08/2018 | 6854.00  | 161  | 158      | AECOP   | Adult Education Budg Prf Aug18  | 15/08/2018 | VIO | AEC PROFILE 2018/19           | AECO180503A | ?       | ?       | 10117529 | CODB529 | 1     | 2         |
#
#    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
#    Then  the Payment feed xml for FundingStreamPeriod 'AEBC1819' PaymentPeriod '201805' CensusEndDate '03/08/2018' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A529.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    Then  the Payment feed xml for FundingStreamPeriod 'AEBC1819' PaymentPeriod '201805' CensusEndDate '03/08/2018' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | AECO                   | 2018          | 05             | 03          | ?       | AEC-529       | 6854.00         | PROFILE          | Adult Education Budg               | 2018-08-15 | 2018-08-01   | 2019-07-31 | ?              | 10117529 | 2371010    |

    # Initiate non-financial amendment request on v2 to create v3 (23305)
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'AEBP-528' for a non-financial NOTIFICATION contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '2' subversion '0' of contract 'MAIN-529' for a non-financial VARIATION contract amendment

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017529 | MAIN-529           | 3                     | 0                        | Draft            | Awaiting Documentation    | True          | False               | 01/08/2018        | 31/07/2019      | Variation     |
    | 10017529 | MAIN-529           | 2                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2018        | 31/07/2019      | Variation     |
    | 10017529 | MAIN-529           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2018        | 31/07/2019      | ?             |
    | 10017529 | ESFA-529           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Create two dummy Terms and Conditions files. Each has just one page containing just the work 'Appendices'
    Given there are no files prefixed '10017529_MAIN-529' in the Sharepoint 'MAIN-1819-Input-Terms And Conditions' folder
    And   a file with filename '10017529_MAIN-529_15.pdf' is created in 'MAIN-1819-Input-Terms And Conditions'
    And   a file with filename '10017529_MAIN-529_69.pdf' is created in 'MAIN-1819-Input-Terms And Conditions'

    # Complete an existing open Task (Initiate Document Merge -> Review Contract Details)
    When  the following open Task currently linked to version '3' of contract 'MAIN-529' for provider '10017529' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Initiate Document Merge          | Document Management Team |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '3' of contract 'MAIN-529' for provider '10017529'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Review Contract Details          | 10017529 - 10017529 Co Ltd Please review the contract       | MAIN-529       | FCS2 Test                | Contract Advisers Team   | Open            | Not Started      |


    # Complete an existing open Task (Review Contract Details -> Confirm Internal Approval)
    When  the following open Task currently linked to version '3' of contract 'MAIN-529' for provider '10017529' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Review Contract Details          | FCS2 Test                |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '3' of contract 'MAIN-529' for provider '10017529'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Internal Approval        | 10017529 - 10017529 Co Ltd                                  | MAIN-529       | FCS1 Test                | Contract Managers Team   | Open            | Not Started      |


    # Complete an existing open Task (Confirm Internal Approval -> Confirm Publication to Provider)
    When  the following open Task currently linked to version '3' of contract 'MAIN-529' for provider '10017529' is triggered by User 'FCS1 Test'
    | Task                             | Owner                    |
    | Confirm Internal Approval        | FCS1 Test                |

    # Check the current state of the Tasks for this contract
    Then  the following Tasks are present against version '3' of contract 'MAIN-529' for provider '10017529'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Publication to Provider  | 10017529 - 10017529 Co Ltd                                  | MAIN-529       | Lead Manager Team         | ?                        | Open            | Not Started      |


    # Complete an existing open Task (Confirm Publication to Provider -> End)
    When  the following open Task currently linked to version '3' of contract 'MAIN-529' for provider '10017529' is triggered by User 'FCS2 Test'
    | Task                             | Owner                    |
    | Confirm Publication to Provider  | Lead Manager Team        |


    # Check that the Tasks on the contract are all marked as completed
    Then  the following Tasks are present against version '3' of contract 'MAIN-529' for provider '10017529'
    | Task                             | Description                                                 | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Publication to Provider  | 10017529 - 10017529 Co Ltd                                  | MAIN-529       | Lead Manager Team         | ?                        | Completed       | Completed        |
    | Confirm Internal Approval        | 10017529 - 10017529 Co Ltd                                  | MAIN-529       | FCS1 Test                | Contract Managers Team   | Completed       | Completed        |
    | Review Contract Details          | 10017529 - 10017529 Co Ltd Please review the contract       | MAIN-529       | FCS2 Test                | Contract Advisers Team   | Completed       | Completed        |
    | Initiate Document Merge          | 10017529 - 10017529 Co Ltd Awaiting documentation           | MAIN-529       | Document Management Team  | ?                        | Completed       | Completed        |

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017529 | MAIN-529           | 3                     | 0                        | Draft            | Published to Provider     | True          | False               | 01/08/2018        | 31/07/2019      | Variation     |
    | 10017529 | MAIN-529           | 2                     | 0                        | Approved         | Approved                  | False         | True                | 01/08/2018        | 31/07/2019      | Variation     |
    | 10017529 | MAIN-529           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2018        | 31/07/2019      | ?             |
    | 10017529 | ESFA-529           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Inject an SFS approval message
    When  a contract approval message is received from SFS for version '3' actual MasterContractNumber 'ESFA-529' and actual ContractNumber 'MAIN-529'

    # Check that the contract is now approved
    Then  the latest version of contract 'MAIN-529' is in status 'Approved'

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017529 | MAIN-529           | 3                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2018        | 31/07/2019      | Variation     |
    | 10017529 | MAIN-529           | 2                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2018        | 31/07/2019      | Variation     |
    | 10017529 | MAIN-529           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2018        | 31/07/2019      | ?             |
    | 10017529 | ESFA-529           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2018        | 31/07/2019      | ?             |

    # Check the PLANNED VALUES in CRM (Same as v2 figures)
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   |
    | MAIN-529       | 16TR-529        | 1               | 45886.00 | 2509.00  | 4228.00  | 4333.00  | 2701.00  | 4968.00  | 797.00   | 5728.00  | 7103.00  | 2978.00  | 1815.00  | 5305.00  | 3421.00  | 
    | MAIN-529       | 16TR-529        | 2               | 19919.00 | 1572.00  | 1162.00  | 71.00    | 2028.00  | 1109.00  | 230.00   | 1552.00  | 2537.00  | 897.00   | 865.00   | 4599.00  | 3297.00  | 
    | MAIN-529       | 16TR-529        | 3               | 25967.00 | 937.00   | 3066.00  | 4262.00  | 673.00   | 3859.00  | 567.00   | 4176.00  | 4566.00  | 2081.00  | 950.00   | 706.00   | 124.00   | 
    #
	| MAIN-529       | AEC-529         | 1               | 64255.00 | 6854.00  | 2557.00  | 4230.00  | 4164.00  | 7998.00  | 5393.00  | 6939.00  | 4930.00  | 4693.00  | 5096.00  | 5202.00  | 6199.00  | 
    | MAIN-529       | AEC-529         | 13              | 34712.00 | 2178.00  | 1893.00  | 4062.00  | 1193.00  | 3533.00  | 4094.00  | 3724.00  | 4835.00  | 188.00   | 1596.00  | 3639.00  | 3777.00  | 
    | MAIN-529       | AEC-529         | 14              | 29543.00 | 4676.00  | 664.00   | 168.00   | 2971.00  | 4465.00  | 1299.00  | 3215.00  | 95.00    | 4505.00  | 3500.00  | 1563.00  | 2422.00  | 


    # Tidy up
    And   the override date is reset
	And   the PaaS MonthEndIsRunning indicator is set to 'False'
	 
	  