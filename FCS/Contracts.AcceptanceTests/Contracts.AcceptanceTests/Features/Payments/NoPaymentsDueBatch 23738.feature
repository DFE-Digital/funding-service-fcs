Feature: NoPaymentsDueBatch 23738

@AcceptanceTest @Withdrawn20231002
Scenario: A378 Create a new 2018 NCS contract with just an NCS-I2018 allocation with non-zero profile for Sep18 only. Run payment batch for Jun18 (no output) and check Payment feed.
    Given there is no Contract, Task or Workflow data for UKPRN '10017378' 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 

#    # Delete all NAT, PAY and ERR files from the Maytech FTP server
#    And   there are no files on the Maytech FTP server

    And   there is no Subnominal data for the following contract allocations
    | AllocationRef |
    | NCSI-378      |

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017378' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017378 Co Ltd' with UKPRN '10017378' and OrgId 'ORG0017378' and has 'FCS1 Test' as a manager 
    And   UPIN '117378' is associated with UKPRN '10017378' in the CRM Organisation table 
 
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | 
    | 10017378 | 117378 | 10017378 Co Ltd | 0              | Active | Yes           | AA017378      | ?             | 

    # Change the date
    And   the override date is '01/03/2018'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription            | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017378 | 10017378 Co Ltd      | ESFA-378             | NCS-378        | 1                     | 01/04/2018        | 30/09/2018      | 25000.00      |                                | Contract for Services | 2018   | New          | ORG0017378 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017378 | NCS-378        | NCSI-378      | NCS-I             | NCS-I2018               | NCS                     | 01/04/2018          | 30/09/2018        | 25000.00        |                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017378 | NCS-378        | NCSI-378      | 1               | 0                     | 25000.00  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 25000.00 | Inspiration Activity                                            | New          |             |

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Publish the contract
    And   the latest version of contract 'NCS-378' is in a state of 'Published to Provider'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017378 | NCS-378            | 1                     | 0                        | Draft            | Published to Provider     | True          | False               | 01/04/2018        | 30/09/2018      | ?             |
    | 10017378 | ESFA-378           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2018        | 30/09/2018      | ?             |

    # Change the date
    And   the override date is '09/03/2018'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-378' and actual ContractNumber 'NCS-378'

    # Check the CONTRACT version, status and dates in CRM.
    Then  the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017378 | NCS-378            | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/04/2018        | 30/09/2018      | ?             |
    | 10017378 | ESFA-378           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/04/2018        | 30/09/2018      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
    And   there are '6' deliverable period rows in CRM linked to the latest version of contract 'NCS-378'

    # Change the date 
    Given the override date is '05/06/2018 22:05'

#   # Delete all NAT, PAY and ERR files from the Maytech FTP server
#   And   there are no files on the Maytech FTP server

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'NCS-I2018' PaymentPeriod '201803' CensusEndDate '05/06/2018' and LinkCodeSuffix 'A'

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | NCS-I2018                  | 201806               |                      | A              | NotStarted |

#    # Coda.AccountCode
#    And   the following configuration exists in the Account Codes table
#    | Ukprn    | Funding Stream Period Code | Coda Code | Control Code | Effective Start Date | Effective End Date |
#    | 10017378 | NCS-I2018                  | CODA378   | 8113000      | 01/04/1990           | 31/03/2020         |

    When  the Payment Generation Batch run is started

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    Then  the Payment feed xml for FundingStreamPeriod 'NCS-I2018' PaymentPeriod '201803' CensusEndDate '05/06/2018' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A378.xml'

    # Check that there are no payments showing in the PaymentGeneration.PaymentBatchFeedItem (23738)
    And   the Payment feed xml for FundingStreamPeriod 'NCS-I2018' PaymentPeriod '201803' CensusEndDate '05/06/2018' and LinkCodeSuffix 'A' with PaymentLineCount zero contains no payment data 

    # Check PaymentGeneration.PaymentTimetable for run completion
    And   there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | NCS-I2018                  | 201806               | Completed |

    # Check the PROFILE PAYMENTS in CRM
    And   the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef   | DeliverableCode | Total    | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   |
    | NCS-378        | NCSI-378        | 1               | 25000.00 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 25000.00 | 

	# Check the PROFILE subnominal aggregations in CRM
    And   the Profile Subnominal Amounts are calculated as follows
    | ContractNumber | AllocationRef   | ProfileSubnominal        | Apr-18   | May-18   | Jun-18   | Jul-18   | Aug-18   | Sep-18   |
    | NCS-378        | NCSI-378        | 2305310                  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 25000.00 | 

	# Check the contents of the PaaS PaymentSchedule.DeliverablePayment table 
    And   the PaymentSchedule.DeliverablePayment table contains the following values 
    | AllocationNumber | VersionNumber | DeliverableCode | Period | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | ActualVolume | ActualValue |
    | NCSI-378         | 1             | 1               | 201804 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSI-378         | 1             | 1               | 201805 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSI-378         | 1             | 1               | 201806 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSI-378         | 1             | 1               | 201807 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSI-378         | 1             | 1               | 201808 | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | ?            | ?           |
    | NCSI-378         | 1             | 1               | 201809 | 2              | 0             | 25000.00     | 25000.00             | 0.00                | 0.00                   | 0.00                        | 25000.00         | ?            | ?           |
	 
	# There are no rows in PaymentGeneration.SubnominalAggregtaion which can be checked

#	# Check that payment files for June 2018 have not been created in the Maytech FTP folder
#   Then  Payment file 'NCSI20180605A.nat' is not present on the Maytech FTP server
#   And   Payment file 'NCSI20180605A.pay' is not present on the Maytech FTP server
#   And   Payment file 'NCSI20180605A.err' is not present on the Maytech FTP server
#	# It is possible that the payment files could be created AFTER this check is done. Check manually

    # Tidy up
    And   the override date is reset
    And   the PaaS MonthEndIsRunning indicator is set to 'False'