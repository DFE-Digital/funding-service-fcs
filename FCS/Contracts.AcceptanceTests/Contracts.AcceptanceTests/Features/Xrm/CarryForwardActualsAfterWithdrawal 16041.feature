Feature: CarryForwardActualsAfterWithdrawal 16041

@AcceptanceTest @Withdrawn20210702
@Long2Run @Long2Run67
Scenario: A719 Create and approve v1 of a 1718 16-18Apps contract. Consume DCFS-format actuals. Create v2 then withdraw same. Create and approve v3. Check actuals on V3 are as v1. Check Sharepoint and Blob storage
    Given there is no Contract, Task or Workflow data for UKPRN '10017719'
    And there are no entries in the DCFS stub table
    And   the PaaS MonthEndIsRunning indicator is set to 'False'
    And   there are no notifications of type 'Contract Withdrawn'

    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | 16AP-719      |

    # Clear down the blob document archive and the associated ArchiveDocument control table (DocumentsDomain.ArchivedDocument)
    And   there is no data in the document archive or the associated control table

    # Set organisation and advisors
    And   there is no Organisation data for UKPRN '10017719'
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017719 Co Ltd' with UKPRN '10017719' and OrgId 'ORG0017719' and has 'FCS1 Test' as a manager
    And   UPIN '117719' is associated with UKPRN '10017719' in the CRM Organisation table

    And   the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status |
    | 10017719 | 117719 | 10017719 Co Ltd | 0              | Active |
 
    And   the override date is reset 

    And   the draft contract header details for the latest version of the contract are as follows
    | UKPRN    | LegalName        | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017719 | 10017719 Co Ltd  | ESFA-719             | MAIN-719       | 1                     |  01/08/2017       |  31/07/2018     | 80904.00      | Contract for Services | 1718   | New          | ORG0017719 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName             | UoPCode | AllocationDescription  | CRMIntent    |
    | 10017719 | MAIN-719       | 16AP-719      | 16-18 APPS        | AY                      |  01/08/2017         |  31/07/2018       | 80904.00        |                     |         |                        | New          |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription                               | CRMIntent    |
    | MAIN-719       | 16AP-719      | 2               | 0                     | 6443.00  | 6613.00  | 6184.00  | 7471.00  | 6851.00  | 5238.00  | 5740.00  | 5494.00  | 9709.00  | 4879.00  | 9179.00  | 7103.00  | 16-18 Apprenticeships Total Funding                  | New          |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Check the deliverable count in CRM is 12 (1 alloc * 1 deliverable line * 12 mths)
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract 'MAIN-719'

    # Publish the contract
    And   the latest version of contract 'MAIN-719' is in a state of 'Published to Provider'

    # Inject dummy files into Sharepoint for v1
    And   a file with filename '10017719_MAIN-719_v1.pdf' is created in 'MAIN-1718-Input-Appendices'
    And   a file with filename '10017719_MAIN-719_v1.pdf' is created in 'MAIN-1718-Output-Documents for Publication'

    # Change the date
    And   the override date is '22/07/2017'

    # Ensure month end is not marked as running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'
    
    # Inject an SFS approval message
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-719' and actual ContractNumber 'MAIN-719'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017719 | MAIN-719           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017719 | ESFA-719           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check the deliverable count in CRM is now 72 (1 alloc * 6 deliverable lines * 12 mths)
    And   there are '72' deliverable period rows in CRM linked to the latest version of contract 'MAIN-719'

	# Have the two documents been removed from the Input-Appendices and Output-Documents folders ?
	And   there are '0' files prefixed '10017719_MAIN-719_v1' in the Sharepoint 'MAIN-1718-Input-Appendices' folder
    And   there are '0' files prefixed '10017719_MAIN-719_v1' in the Sharepoint 'MAIN-1718-Output-Documents for Publication' folder

    # ... and just one of them added to the Blob archive (when approval occurs) 
    And   there is '1' file prefixed '10017719_MAIN-719_v1' in the document archive and the associated control table




    # Change the date
    And   the override date is '06/09/2017'

    # DCFS Summarised Actuals for August 2017
    And   the following closed collections are available in DCFS
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode | DeliverableCode | ActualVolume | ActualValue |
    | ILR1718        | R01                  | ORG0017719     | CM             | 201708 | 16-18APPS1718           | 16AP-719                 |         | 6               | 0            | 1385.00     |
    | ILR1718        | R01                  | ORG0017719     | CM             | 201709 | 16-18APPS1718           | 16AP-719                 |         | 6               | 0            | 107.00      |
    | ILR1718        | R01                  | ORG0017719     | CM             | 201710 | 16-18APPS1718           | 16AP-719                 |         | 6               | 0            | 189.00      |
    | ILR1718        | R01                  | ORG0017719     | CM             | 201711 | 16-18APPS1718           | 16AP-719                 |         | 6               | 0            | 42.00       |
    | ILR1718        | R01                  | ORG0017719     | CM             | 201712 | 16-18APPS1718           | 16AP-719                 |         | 6               | 0            | 65.00       |
    | ILR1718        | R01                  | ORG0017719     | CM             | 201801 | 16-18APPS1718           | 16AP-719                 |         | 6               | 0            | 73.00       |
    | ILR1718        | R01                  | ORG0017719     | CM             | 201802 | 16-18APPS1718           | 16AP-719                 |         | 6               | 0            | 24.00       |
    | ILR1718        | R01                  | ORG0017719     | CM             | 201803 | 16-18APPS1718           | 16AP-719                 |         | 6               | 0            | 67.00       |
    | ILR1718        | R01                  | ORG0017719     | CM             | 201804 | 16-18APPS1718           | 16AP-719                 |         | 6               | 0            | 122.00      |
    | ILR1718        | R01                  | ORG0017719     | CM             | 201805 | 16-18APPS1718           | 16AP-719                 |         | 6               | 0            | 4.00        |
    | ILR1718        | R01                  | ORG0017719     | CM             | 201806 | 16-18APPS1718           | 16AP-719                 |         | 6               | 0            | 197.00      |
    | ILR1718        | R01                  | ORG0017719     | CM             | 201807 | 16-18APPS1718           | 16AP-719                 |         | 6               | 0            | 144.00      |
    #
    | ILR1718        | R01                  | ORG0017719     | CM             | 201708 | 16-18APPS1718           | 16AP-719                 |         | 7               | 0            | 1953.00     |
    | ILR1718        | R01                  | ORG0017719     | CM             | 201709 | 16-18APPS1718           | 16AP-719                 |         | 7               | 0            | 154.00      |
    | ILR1718        | R01                  | ORG0017719     | CM             | 201710 | 16-18APPS1718           | 16AP-719                 |         | 7               | 0            | 57.00       |
    | ILR1718        | R01                  | ORG0017719     | CM             | 201711 | 16-18APPS1718           | 16AP-719                 |         | 7               | 0            | 89.00       |
    | ILR1718        | R01                  | ORG0017719     | CM             | 201712 | 16-18APPS1718           | 16AP-719                 |         | 7               | 0            | 146.00      |
    | ILR1718        | R01                  | ORG0017719     | CM             | 201801 | 16-18APPS1718           | 16AP-719                 |         | 7               | 0            | 61.00       |
    | ILR1718        | R01                  | ORG0017719     | CM             | 201802 | 16-18APPS1718           | 16AP-719                 |         | 7               | 0            | 212.00      |
    | ILR1718        | R01                  | ORG0017719     | CM             | 201803 | 16-18APPS1718           | 16AP-719                 |         | 7               | 0            | 51.00       |
    | ILR1718        | R01                  | ORG0017719     | CM             | 201804 | 16-18APPS1718           | 16AP-719                 |         | 7               | 0            | 144.00      |
    | ILR1718        | R01                  | ORG0017719     | CM             | 201805 | 16-18APPS1718           | 16AP-719                 |         | 7               | 0            | 27.00       |
    | ILR1718        | R01                  | ORG0017719     | CM             | 201806 | 16-18APPS1718           | 16AP-719                 |         | 7               | 0            | 43.00       |
    | ILR1718        | R01                  | ORG0017719     | CM             | 201807 | 16-18APPS1718           | 16AP-719                 |         | 7               | 0            | 101.00      |
    #
    | ILR1718        | R01                  | ORG0017719     | CM             | 201708 | 16-18APPS1718           | 16AP-719                 |         | 8               | 0            | 713.00      |
    | ILR1718        | R01                  | ORG0017719     | CM             | 201709 | 16-18APPS1718           | 16AP-719                 |         | 8               | 0            | 98.00       |
    | ILR1718        | R01                  | ORG0017719     | CM             | 201710 | 16-18APPS1718           | 16AP-719                 |         | 8               | 0            | 134.00      |
    | ILR1718        | R01                  | ORG0017719     | CM             | 201711 | 16-18APPS1718           | 16AP-719                 |         | 8               | 0            | 91.00       |
    | ILR1718        | R01                  | ORG0017719     | CM             | 201712 | 16-18APPS1718           | 16AP-719                 |         | 8               | 0            | 12.00       |
    | ILR1718        | R01                  | ORG0017719     | CM             | 201801 | 16-18APPS1718           | 16AP-719                 |         | 8               | 0            | 36.00       |
    | ILR1718        | R01                  | ORG0017719     | CM             | 201802 | 16-18APPS1718           | 16AP-719                 |         | 8               | 0            | 36.00       |
    | ILR1718        | R01                  | ORG0017719     | CM             | 201803 | 16-18APPS1718           | 16AP-719                 |         | 8               | 0            | 193.00      |
    | ILR1718        | R01                  | ORG0017719     | CM             | 201804 | 16-18APPS1718           | 16AP-719                 |         | 8               | 0            | 120.00      |
    | ILR1718        | R01                  | ORG0017719     | CM             | 201805 | 16-18APPS1718           | 16AP-719                 |         | 8               | 0            | 71.00       |
    | ILR1718        | R01                  | ORG0017719     | CM             | 201806 | 16-18APPS1718           | 16AP-719                 |         | 8               | 0            | 10.00       |
    | ILR1718        | R01                  | ORG0017719     | CM             | 201807 | 16-18APPS1718           | 16AP-719                 |         | 8               | 0            | 82.00       |
    #
    | ILR1718        | R01                  | ORG0017719     | CM             | 201708 | 16-18APPS1718           | 16AP-719                 |         | 9               | 0            | 634.00      |
    | ILR1718        | R01                  | ORG0017719     | CM             | 201709 | 16-18APPS1718           | 16AP-719                 |         | 9               | 0            | 190.00      |
    | ILR1718        | R01                  | ORG0017719     | CM             | 201710 | 16-18APPS1718           | 16AP-719                 |         | 9               | 0            | 37.00       |
    | ILR1718        | R01                  | ORG0017719     | CM             | 201711 | 16-18APPS1718           | 16AP-719                 |         | 9               | 0            | 78.00       |
    | ILR1718        | R01                  | ORG0017719     | CM             | 201712 | 16-18APPS1718           | 16AP-719                 |         | 9               | 0            | 38.00       |
    | ILR1718        | R01                  | ORG0017719     | CM             | 201801 | 16-18APPS1718           | 16AP-719                 |         | 9               | 0            | 115.00      |
    | ILR1718        | R01                  | ORG0017719     | CM             | 201802 | 16-18APPS1718           | 16AP-719                 |         | 9               | 0            | 51.00       |
    | ILR1718        | R01                  | ORG0017719     | CM             | 201803 | 16-18APPS1718           | 16AP-719                 |         | 9               | 0            | 64.00       |
    | ILR1718        | R01                  | ORG0017719     | CM             | 201804 | 16-18APPS1718           | 16AP-719                 |         | 9               | 0            | 51.00       |
    | ILR1718        | R01                  | ORG0017719     | CM             | 201805 | 16-18APPS1718           | 16AP-719                 |         | 9               | 0            | 218.00      |
    | ILR1718        | R01                  | ORG0017719     | CM             | 201806 | 16-18APPS1718           | 16AP-719                 |         | 9               | 0            | 38.00       |
    | ILR1718        | R01                  | ORG0017719     | CM             | 201807 | 16-18APPS1718           | 16AP-719                 |         | 9               | 0            | 152.00      |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check the values in CRM
    Then  the Actuals Value Data is stored in CRM against the last approved version of the contract as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-17   | 
    | MAIN-719       | 16AP-719      | 6               | 1385.00  | 
    | MAIN-719       | 16AP-719      | 7               | 1953.00  | 
    | MAIN-719       | 16AP-719      | 8               | 713.00   | 
    | MAIN-719       | 16AP-719      | 9               | 634.00   | 

    And   the Reconciliation Data is calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-17   |
    | MAIN-719       | 16AP-719      | 6               | 1385.00  |
    | MAIN-719       | 16AP-719      | 7               | 1953.00  |
    | MAIN-719       | 16AP-719      | 8               | 713.00   |
    | MAIN-719       | 16AP-719      | 9               | 634.00   |

    And   the Net Payments are calculated as follows
    | ContractNumber | AllocationRef | DeliverableCode | Aug-17   |
    | MAIN-719       | 16AP-719      | 6               | 1385.00  |
    | MAIN-719       | 16AP-719      | 7               | 1953.00  |
    | MAIN-719       | 16AP-719      | 8               | 713.00   |
    | MAIN-719       | 16AP-719      | 9               | 634.00   |

    And   the Reconciliation Subnominal Amounts are calculated as follows
    | ContractNumber | AllocationRef | ReconciliationSubnominal | Aug-17   | 
    | MAIN-719       | 16AP-719      | 2240100                  | 4685.00  | 

    # Bulk amend and publish v2 of the contract but don't approve it
    Given there are no files prefixed '10017719_MAIN-719' in the Sharepoint 'MAIN-1718-Input-Appendices' folder
    And   there are no files prefixed 'MAIN AY 1718 26102017183926 v2_A719_1' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'MAIN AY 1718 26102017183926 v2_A719_1' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'MAIN AY 1718 26102017183926 v2_A719_1' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'MAIN AY 1718 26102017183926 v2_A719_1' in the Sharepoint 'Reports' folder
    And   spreadsheet 'MAIN AY 1718 26102017183926 v2_A719_1.xlsx' exists in the Datafiles folder and UKPRN '10017719' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Publish the contract
    When  the latest version of contract 'MAIN-719' is in a state of 'Published to Provider'




    # Change the date
    Given the override date is '26/10/2017'

    # Inject dummy files into Sharepoint for v2
    And   a file with filename '10017719_MAIN-719_v2.pdf' is created in 'MAIN-1718-Output-Documents for Publication'

    # Check what is where in Sharepoint before withdrawing v2
    Then  there is '1' file prefixed '10017719_MAIN-719_v2' in the Sharepoint 'MAIN-1718-Input-Appendices' folder
    And   there are '0' files prefixed '10017719_MAIN-719' in the Sharepoint 'MAIN-1718-Input-Terms and Conditions' folder
    And   there are '0' files prefixed '10017719_MAIN-719' in the Sharepoint 'MAIN-1718-Output-Merged Document' folder
    And   there is '1' file prefixed '10017719_MAIN-719_v2' in the Sharepoint 'MAIN-1718-Output-Documents for Publication' folder

   # Withdraw the contract
    When  the next action performed on the latest version of contract 'MAIN-719' is 'Withdraw On Behalf Of Provider' with reason 'Reason for withdrawal for test' by 'FCS1 Test'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017719 | MAIN-719           | 2                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/08/2017        | 31/07/2018      | Variation     |
    | 10017719 | MAIN-719           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2017        | 31/07/2018      | ?             |
    | 10017719 | ESFA-719           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      | ?             |

    # Check what is where in Sharepoint after withdrawing v2
    And   there are '0' files prefixed '10017719_MAIN-719' in the Sharepoint 'MAIN-1718-Input-Appendices' folder
    And   there are '0' files prefixed '10017719_MAIN-719' in the Sharepoint 'MAIN-1718-Input-Terms and Conditions' folder
    And   there are '0' files prefixed '10017719_MAIN-719' in the Sharepoint 'MAIN-1718-Output-Merged Document' folder
    And   there are '0' files prefixed '10017719_MAIN-719' in the Sharepoint 'MAIN-1718-Output-Documents for Publication' folder

    # Has v2 (from Output-Documents for Publication) been added to the Blob archive after withdrawing v2 
    And   there is '1' file prefixed '10017719_MAIN-719_v1' in the document archive and the associated control table
	And   there is '1' file prefixed '10017719_MAIN-719_v2' in the document archive and the associated control table




    # Change the date
    And   the override date is '28/10/2017'

    # Create and publish v3 of the contract
    Given there are no files prefixed '10017719_AEBP-719' in the Sharepoint 'MAIN-1718-Input-Appendices' folder
    And   there are no files prefixed 'MAIN AY 1718 26102017183928 v2_A719_2' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'MAIN AY 1718 26102017183928 v2_A719_2' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'MAIN AY 1718 26102017183928 v2_A719_2' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'MAIN AY 1718 26102017183928 v2_A719_2' in the Sharepoint 'Reports' folder
    And   spreadsheet 'MAIN AY 1718 26102017183928 v2_A719_2.xlsx' exists in the Datafiles folder and UKPRN '10017719' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report

    # Check the deliverable count in CRM is 12 (1 alloc * 1 deliverable line * 12 mths)
    And   there are '12' deliverable period rows in CRM linked to the latest version of contract 'MAIN-719'

    # Publish the contract
    When  the latest version of contract 'MAIN-719' is in a state of 'Published to Provider'

    # Change the date
    And   the override date is '30/10/2017'

    # Ensure month end is not marked as running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject dummy files into Sharepoint for v3
    And   a file with filename '10017719_MAIN-719_v3.pdf' is created in 'MAIN-1718-Output-Documents for Publication'

    # Inject an SFS approval message
    When  a contract approval message is received from SFS for version '3' actual MasterContractNumber 'ESFA-719' and actual ContractNumber 'MAIN-719'

    # Check the CONTRACT version, status and dates in CRM
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017719 | MAIN-719           | 3                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2017        | 31/07/2018      | Variation     |
    | 10017719 | MAIN-719           | 2                     | 0                        | Withdrawn        | Withdrawn By Provider     | False         | False               | 01/08/2017        | 31/07/2018      | Variation     |
    | 10017719 | MAIN-719           | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2017        | 31/07/2018      |	?             |
    | 10017719 | ESFA-719           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2017        | 31/07/2018      |	?             |

    # Check the deliverable count in CRM is now 72 (1 alloc * 6 deliverable lines * 12 mths)
    And   there are '72' deliverable period rows in CRM linked to the latest version of contract 'MAIN-719'

    # Check numbers in CRM match those from v1
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | MAIN-719       | 16AP-719        | 2               | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-719       | 16AP-719        | 6               | 1385.00  | 1385.00  | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-719       | 16AP-719        | 7               | 1953.00  | 1953.00  | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-719       | 16AP-719        | 8               | 713.00   | 713.00   | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-719       | 16AP-719        | 9               | 634.00   | 634.00   | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-719       | 16AP-719        | 10              | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | MAIN-719       | 16AP-719        | 2               | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-719       | 16AP-719        | 6               | 1385.00  | 1385.00  | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-719       | 16AP-719        | 7               | 1953.00  | 1953.00  | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-719       | 16AP-719        | 8               | 713.00   | 713.00   | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-719       | 16AP-719        | 9               | 634.00   | 634.00   | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-719       | 16AP-719        | 10              | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the NET AMOUNTS in CRM
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   |
    | MAIN-719       | 16AP-719        | 2               | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-719       | 16AP-719        | 6               | 1385.00  | 1385.00  | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-719       | 16AP-719        | 7               | 1953.00  | 1953.00  | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-719       | 16AP-719        | 8               | 713.00   | 713.00   | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-719       | 16AP-719        | 9               | 634.00   | 634.00   | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | MAIN-719       | 16AP-719        | 10              | 0.00     | 0.00     | 0.00     | 0.00     | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    And   the Reconciliation Subnominal Amounts are calculated as follows
    | ContractNumber | AllocationRef | ReconciliationSubnominal | Aug-17   | Sep-17   | Oct-17   |
    | MAIN-719       | 16AP-719      | 2240100                  | 4685.00  | 0.00     | 0.00     | 

    # Check what is where in Sharepoint after the approval of v3
    And   there are '0' files prefixed '10017719_MAIN-719_v1' in the Sharepoint 'MAIN-1718-Input-Appendices' folder
    And   there are '0' files prefixed '10017719_MAIN-719_v2' in the Sharepoint 'MAIN-1718-Input-Appendices' folder
    And   there are '0' files prefixed '10017719_MAIN-719_v3' in the Sharepoint 'MAIN-1718-Input-Appendices' folder

    And   there are '0' files prefixed '10017719_MAIN-719' in the Sharepoint 'MAIN-1718-Input-Terms and Conditions' folder
    And   there are '0' files prefixed '10017719_MAIN-719' in the Sharepoint 'MAIN-1718-Output-Merged Document' folder

    And   there are '0' files prefixed '10017719_MAIN-719_v1' in the Sharepoint 'MAIN-1718-Output-Documents for Publication' folder
    And   there are '0' files prefixed '10017719_MAIN-719_v2' in the Sharepoint 'MAIN-1718-Output-Documents for Publication' folder

    # Check the archive after approval of v3
    And   there is '1' file prefixed '10017719_MAIN-719_v1' in the document archive and the associated control table
    And   there is '1' file prefixed '10017719_MAIN-719_v2' in the document archive and the associated control table
    And   there is '1' file prefixed '10017719_MAIN-719_v3' in the document archive and the associated control table

    # Tidy up
    And   the override date is reset

