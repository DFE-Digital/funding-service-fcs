Feature: New1619ED2021Deliverables 32022

@AcceptanceTest @Withdrawn20230123
Scenario: A504 Create and approve a new 2021 EDSK contract with a 1619ED2021 allocation and deliverables 148-151. Check financials in CRM and PaaS
    Given there are no allocations marked as Under Termination for UKPRN '10017504' 
    And   there are no terminated or closed allocations for UKPRN '10017504' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017504' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017504' 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017504' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | 16ED-504      |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | 16ED-504      |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | 1619ED2021        |

    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | EDSK-504       | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017504'

    # Set the 'base' timestamp for each of the 39 EDSK document templates (DocumentsDomain.UploadedDocumentTemplate) (J107) 
    And   the following document templates have Upload timestamps as indicated 
    | DocumentTemplateName                            | UploadTimestamp         | 
    | EDSK2021_TAC_CFS_ITP_2020-08-01.docx            | 2020-06-18 12:00:00.000 | 
    | EDSK2021_TAC_COFG_COLLEGE_2020-08-01.docx       | 2020-06-18 12:00:00.000 | 
    | EDSK2021_TAC_COFG_EMPLOYER_2020-08-01.docx      | 2020-06-18 12:00:00.000 | 
    | EDSK2021_TAC_COFG_HEI_2020-08-01.docx           | 2020-06-18 12:00:00.000 | 
    | EDSK2021_TAC_COFG_LA_2020-08-01.docx            | 2020-06-18 12:00:00.000 | 
    | EDSK2021_TAC_COFG_NMSS_2020-08-01.docx          | 2020-06-18 12:00:00.000 | 
    | EDSK2021_TAC_COFG_SPI_2020-08-01.docx           | 2020-06-18 12:00:00.000 | 
    | EDSK2021_TAC_COFG_TRUST_2020-08-01.docx         | 2020-06-18 12:00:00.000 | 
    # 
    | EDSK2021_S1_1618TRN_CFS.docx                    | 2020-06-18 12:00:00.000 | 
    | EDSK2021_S1_1618TRN_COFG.docx                   | 2020-06-18 12:00:00.000 | 
    | EDSK2021_S1_1619ED_COLLEGE.docx                 | 2020-06-18 12:00:00.000 | 
    | EDSK2021_S1_1619ED_HEI.docx                     | 2020-06-18 12:00:00.000 | 
    | EDSK2021_S1_1619ED_ITP.docx                     | 2020-06-18 12:00:00.000 | 
    | EDSK2021_S1_1619ED_LA.docx                      | 2020-06-18 12:00:00.000 | 
    | EDSK2021_S1_1619ED_NMSS.docx                    | 2020-06-18 12:00:00.000 | 
    | EDSK2021_S1_1619ED_SPI.docx                     | 2020-06-18 12:00:00.000 | 
    | EDSK2021_S1_AEB_CFS.docx                        | 2020-06-18 12:00:00.000 | 
    | EDSK2021_S1_AEB_COFG.docx                       | 2020-06-18 12:00:00.000 | 
    | EDSK2021_S1_APPS_COLLEGE.docx                   | 2020-06-18 12:00:00.000 | 
    | EDSK2021_S1_APPS_OTHER.docx                     | 2020-06-18 12:00:00.000 | 
    | EDSK2021_S1_LOANS_CFS.docx                      | 2020-06-18 12:00:00.000 | 
    | EDSK2021_S1_LOANS_COFG.docx                     | 2020-06-18 12:00:00.000 | 
    # 
    | EDSK2021_S2_1618TRN_CFS.docx                    | 2020-06-18 12:00:00.000 | 
    | EDSK2021_S2_1618TRN_COFG.docx                   | 2020-06-18 12:00:00.000 | 
    | EDSK2021_S2_1619ED_CFS.docx                     | 2020-06-18 12:00:00.000 | 
    | EDSK2021_S2_1619ED_COFG.docx                    | 2020-06-18 12:00:00.000 | 
    | EDSK2021_S2_AEB_CFS.docx                        | 2020-06-18 12:00:00.000 | 
    | EDSK2021_S2_AEB_COFG.docx                       | 2020-06-18 12:00:00.000 | 
    | EDSK2021_S2_APPS_COLLEGE.docx                   | 2020-06-18 12:00:00.000 | 
    | EDSK2021_S2_APPS_OTHER.docx                     | 2020-06-18 12:00:00.000 | 
    | EDSK2021_S2_LOANS_CFS_2020-08-01.docx           | 2020-06-18 12:00:00.000 | 
    | EDSK2021_S2_LOANS_COFG_2020-08-01.docx          | 2020-06-18 12:00:00.000 | 
    # 
    | EDSK2021_S3ON_CFS_ITP_2020-08-01.docx           | 2020-06-18 12:00:00.000 | 
    | EDSK2021_S3ON_COFG_COLLEGE_2020-08-01.docx      | 2020-06-18 12:00:00.000 | 
    | EDSK2021_S3ON_COFG_EMPLOYER_2020-08-01.docx     | 2020-06-18 12:00:00.000 | 
    | EDSK2021_S3ON_COFG_LA_TRUST_HEI_2020-08-01.docx | 2020-06-18 12:00:00.000 | 
    | EDSK2021_S3ON_COFG_NMSS_2020-08-01.docx         | 2020-06-18 12:00:00.000 | 
    | EDSK2021_S3ON_COFG_SPI_2020-08-01.docx          | 2020-06-18 12:00:00.000 | 
    # 
    | FA_EDSK2021_2020-08-01.docx                     | 2020-06-18 12:00:00.000 | 




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017504' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017504 Co Ltd' with UKPRN '10017504' and OrgId 'ORG0017504' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017504' 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017504 | 117504 | 10017504 Co Ltd | 0              | Active                | Yes           | AA017504      | ?             | 29 Waterside           | 44 - 48 Wharf Road     | Islington              | London                 | ?                      | ?                      | N1 7SH    |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017504 |




    # Change the date
    Given the override date is '01/07/2020'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017504 | 10017504 Co Ltd      | ESFA-504             | EDSK-504       | 1                     | 01/08/2020        | 31/07/2021      | 30010.19      |                                       | Conditions of Funding (Grant) (HEI)        | 2021   | New          | ORG0017504 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017504 | EDSK-504       | 16ED-504      | 1619ED            | 1619ED2021              | AY                      | 01/08/2020          | 31/07/2021        | 30010.19        |                                         |            |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | P1-8      | P9-12     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   | DeliverableDescription                                          | CRMIntent    | DeliveryOrg |
    | 10017504 | EDSK-504       | 16ED-504      | 148             | 0                     | 2675.78   | 2675.78   | 0.00      | 0.00     | 0.00     | 0.00     | 2675.78  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 16-19 High Value Courses School and College Leavers Programme   | New          |             | 
    | 10017504 | EDSK-504       | 16ED-504      | 149             | 0                     | 8238.70   | 6886.81   | 1351.89   | 1629.29  | 0.00     | 0.00     | 460.62   | 739.52   | 0.00     | 1254.89  | 2802.49  | 0.00     | 0.00     | 1351.89  | 0.00     | 16-19 High Value Courses School and College Leavers Uplift      | New          |             | 
    | 10017504 | EDSK-504       | 16ED-504      | 150             | 0                     | 9524.34   | 6253.57   | 3270.77   | -1444.26 | 2381.01  | 0.00     | 1721.66  | 0.00     | 0.00     | 3595.16  | 0.00     | 3270.77  | 0.00     | 0.00     | 0.00     | SSF High Value Courses School and College Leavers Programme     | New          |             | 
    | 10017504 | EDSK-504       | 16ED-504      | 151             | 0                     | 9571.37   | 7223.73   | 2347.64   | 2158.31  | 0.00     | 0.00     | 0.00     | 1642.95  | 0.00     | 0.00     | 3422.47  | 0.00     | 378.79   | 0.00     | 1968.85  | SSF High Value Courses School and College Leavers Uplift        | New          |             | 

    And   the contract exists in CRM
    # Contract status is now at 'Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-504       | 1                     | 0                        | 2020-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'EDSK-504'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for version '1' actual MasterContractNumber 'ESFA-504' and actual ContractNumber 'EDSK-504'

    # Check that the contract is now approved
    Then  the latest version of contract 'EDSK-504' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017504 | EDSK-504           | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2020        | 31/07/2021      | ?             |
    | 10017504 | ESFA-504           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2020        | 31/07/2021      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables
   #And   there are '48' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
    And   there are '48' deliverable period rows in CRM linked to the latest version of contract 'EDSK-504'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | 16ED-504        | 2218072          | Jul-21 | Profile        |




    # Check Financials

    # Check the PLANNED VALUES in CRM on the latest approved contract
    Then  the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | EDSK-504       | 16ED-504           | 148             | 2675.78   | 0.00     | 0.00     | 0.00     | 2675.78  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-504       | 16ED-504           | 149             | 8238.70   | 1629.29  | 0.00     | 0.00     | 460.62   | 739.52   | 0.00     | 1254.89  | 2802.49  | 0.00     | 0.00     | 1351.89  | 0.00     | 
    | EDSK-504       | 16ED-504           | 150             | 9524.34   | -1444.26 | 2381.01  | 0.00     | 1721.66  | 0.00     | 0.00     | 3595.16  | 0.00     | 3270.77  | 0.00     | 0.00     | 0.00     | 
    | EDSK-504       | 16ED-504           | 151             | 9571.37   | 2158.31  | 0.00     | 0.00     | 0.00     | 1642.95  | 0.00     | 0.00     | 3422.47  | 0.00     | 378.79   | 0.00     | 1968.85  | 

    # Check the PROFILE PAYMENTS in CRM on the latest approved contract
    And  the Profile Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | EDSK-504       | 16ED-504           | 148             | 2675.78   | 0.00     | 0.00     | 0.00     | 2675.78  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-504       | 16ED-504           | 149             | 8238.70   | 1629.29  | 0.00     | 0.00     | 460.62   | 739.52   | 0.00     | 1254.89  | 2802.49  | 0.00     | 0.00     | 1351.89  | 0.00     | 
    | EDSK-504       | 16ED-504           | 150             | 9524.34   | -1444.26 | 2381.01  | 0.00     | 1721.66  | 0.00     | 0.00     | 3595.16  | 0.00     | 3270.77  | 0.00     | 0.00     | 0.00     | 
    | EDSK-504       | 16ED-504           | 151             | 9571.37   | 2158.31  | 0.00     | 0.00     | 0.00     | 1642.95  | 0.00     | 0.00     | 3422.47  | 0.00     | 378.79   | 0.00     | 1968.85  | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-20   | Sep-20   | Oct-20   | Nov-20   | Dec-20   | Jan-21   | Feb-21   | Mar-21   | Apr-21   | May-21   | Jun-21   | Jul-21   |
    | EDSK-504       | 16ED-504           | 148             | 2675.78   | 0.00     | 0.00     | 0.00     | 2675.78  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | EDSK-504       | 16ED-504           | 149             | 8238.70   | 1629.29  | 0.00     | 0.00     | 460.62   | 739.52   | 0.00     | 1254.89  | 2802.49  | 0.00     | 0.00     | 1351.89  | 0.00     | 
    | EDSK-504       | 16ED-504           | 150             | 9524.34   | -1444.26 | 2381.01  | 0.00     | 1721.66  | 0.00     | 0.00     | 3595.16  | 0.00     | 3270.77  | 0.00     | 0.00     | 0.00     | 
    | EDSK-504       | 16ED-504           | 151             | 9571.37   | 2158.31  | 0.00     | 0.00     | 0.00     | 1642.95  | 0.00     | 0.00     | 3422.47  | 0.00     | 378.79   | 0.00     | 1968.85  | 


    # Check the PROFILE subnominal aggregations in CRM
    And   the Profile Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef  | ProfileSubnominal  | Total     | Aug-20    | Sep-20    | Oct-20    | Nov-20    | Dec-20    | Jan-21    | Feb-21    | Mar-21    | Apr-21    | May-21    | Jun-21    | Jul-21    |
    | 10017504 | EDSK-504       | 16ED-504       | 2203071            | 2675.78   | 0.00      | 0.00      | 0.00      | 2675.78   | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
    | 10017504 | EDSK-504       | 16ED-504       | 2203072            | 8238.70   | 1629.29   | 0.00      | 0.00      | 460.62    | 739.52    | 0.00      | 1254.89   | 2802.49   | 0.00      | 0.00      | 1351.89   | 0.00      | 
    | 10017504 | EDSK-504       | 16ED-504       | 2218071            | 9524.34   | -1444.26  | 2381.01   | 0.00      | 1721.66   | 0.00      | 0.00      | 3595.16   | 0.00      | 3270.77   | 0.00      | 0.00      | 0.00      | 
    | 10017504 | EDSK-504       | 16ED-504       | 2218072            | 9571.37   | 2158.31   | 0.00      | 0.00      | 0.00      | 1642.95   | 0.00      | 0.00      | 3422.47   | 0.00      | 378.79    | 0.00      | 1968.85   | 


    # Check the PROFILE subnominal aggregations in PaaS
    Then  the PaymentGeneration.SubnominalAggregation table contains the following values 
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Calendar Year/Period | Payment Type    | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 10017504 | ORG0017504 | 16ED-504          | 2203071         | 1619ED2021                 | 202008               | PROFILE         | CM             | False       | 0.00            |
    | 10017504 | ORG0017504 | 16ED-504          | 2203071         | 1619ED2021                 | 202009               | PROFILE         | CM             | False       | 0.00            |
    | 10017504 | ORG0017504 | 16ED-504          | 2203071         | 1619ED2021                 | 202010               | PROFILE         | CM             | False       | 0.00            |
    | 10017504 | ORG0017504 | 16ED-504          | 2203071         | 1619ED2021                 | 202011               | PROFILE         | CM             | False       | 2675.78         |
    | 10017504 | ORG0017504 | 16ED-504          | 2203071         | 1619ED2021                 | 202012               | PROFILE         | CM             | False       | 0.00            |
    | 10017504 | ORG0017504 | 16ED-504          | 2203071         | 1619ED2021                 | 202101               | PROFILE         | CM             | False       | 0.00            |
    | 10017504 | ORG0017504 | 16ED-504          | 2203071         | 1619ED2021                 | 202102               | PROFILE         | CM             | False       | 0.00            |
    | 10017504 | ORG0017504 | 16ED-504          | 2203071         | 1619ED2021                 | 202103               | PROFILE         | CM             | False       | 0.00            |
    | 10017504 | ORG0017504 | 16ED-504          | 2203071         | 1619ED2021                 | 202104               | PROFILE         | CM             | False       | 0.00            |
    | 10017504 | ORG0017504 | 16ED-504          | 2203071         | 1619ED2021                 | 202105               | PROFILE         | CM             | False       | 0.00            |
    | 10017504 | ORG0017504 | 16ED-504          | 2203071         | 1619ED2021                 | 202106               | PROFILE         | CM             | False       | 0.00            |
    | 10017504 | ORG0017504 | 16ED-504          | 2203071         | 1619ED2021                 | 202107               | PROFILE         | CM             | False       | 0.00            |
    #
    | 10017504 | ORG0017504 | 16ED-504          | 2203072         | 1619ED2021                 | 202008               | PROFILE         | CM             | False       | 1629.29         |
    | 10017504 | ORG0017504 | 16ED-504          | 2203072         | 1619ED2021                 | 202009               | PROFILE         | CM             | False       | 0.00            |
    | 10017504 | ORG0017504 | 16ED-504          | 2203072         | 1619ED2021                 | 202010               | PROFILE         | CM             | False       | 0.00            |
    | 10017504 | ORG0017504 | 16ED-504          | 2203072         | 1619ED2021                 | 202011               | PROFILE         | CM             | False       | 460.62          |
    | 10017504 | ORG0017504 | 16ED-504          | 2203072         | 1619ED2021                 | 202012               | PROFILE         | CM             | False       | 739.52          |
    | 10017504 | ORG0017504 | 16ED-504          | 2203072         | 1619ED2021                 | 202101               | PROFILE         | CM             | False       | 0.00            |
    | 10017504 | ORG0017504 | 16ED-504          | 2203072         | 1619ED2021                 | 202102               | PROFILE         | CM             | False       | 1254.89         |
    | 10017504 | ORG0017504 | 16ED-504          | 2203072         | 1619ED2021                 | 202103               | PROFILE         | CM             | False       | 2802.49         |
    | 10017504 | ORG0017504 | 16ED-504          | 2203072         | 1619ED2021                 | 202104               | PROFILE         | CM             | False       | 0.00            |
    | 10017504 | ORG0017504 | 16ED-504          | 2203072         | 1619ED2021                 | 202105               | PROFILE         | CM             | False       | 0.00            |
    | 10017504 | ORG0017504 | 16ED-504          | 2203072         | 1619ED2021                 | 202106               | PROFILE         | CM             | False       | 1351.89         |
    | 10017504 | ORG0017504 | 16ED-504          | 2203072         | 1619ED2021                 | 202107               | PROFILE         | CM             | False       | 0.00            |
    #
    | 10017504 | ORG0017504 | 16ED-504          | 2218071         | 1619ED2021                 | 202008               | PROFILE         | CM             | False       | -1444.26        |
    | 10017504 | ORG0017504 | 16ED-504          | 2218071         | 1619ED2021                 | 202009               | PROFILE         | CM             | False       | 2381.01         |
    | 10017504 | ORG0017504 | 16ED-504          | 2218071         | 1619ED2021                 | 202010               | PROFILE         | CM             | False       | 0.00            |
    | 10017504 | ORG0017504 | 16ED-504          | 2218071         | 1619ED2021                 | 202011               | PROFILE         | CM             | False       | 1721.66         |
    | 10017504 | ORG0017504 | 16ED-504          | 2218071         | 1619ED2021                 | 202012               | PROFILE         | CM             | False       | 0.00            |
    | 10017504 | ORG0017504 | 16ED-504          | 2218071         | 1619ED2021                 | 202101               | PROFILE         | CM             | False       | 0.00            |
    | 10017504 | ORG0017504 | 16ED-504          | 2218071         | 1619ED2021                 | 202102               | PROFILE         | CM             | False       | 3595.16         |
    | 10017504 | ORG0017504 | 16ED-504          | 2218071         | 1619ED2021                 | 202103               | PROFILE         | CM             | False       | 0.00            |
    | 10017504 | ORG0017504 | 16ED-504          | 2218071         | 1619ED2021                 | 202104               | PROFILE         | CM             | False       | 3270.77         |
    | 10017504 | ORG0017504 | 16ED-504          | 2218071         | 1619ED2021                 | 202105               | PROFILE         | CM             | False       | 0.00            |
    | 10017504 | ORG0017504 | 16ED-504          | 2218071         | 1619ED2021                 | 202106               | PROFILE         | CM             | False       | 0.00            |
    | 10017504 | ORG0017504 | 16ED-504          | 2218071         | 1619ED2021                 | 202107               | PROFILE         | CM             | False       | 0.00            |
    #
    | 10017504 | ORG0017504 | 16ED-504          | 2218072         | 1619ED2021                 | 202008               | PROFILE         | CM             | False       | 2158.31         |
    | 10017504 | ORG0017504 | 16ED-504          | 2218072         | 1619ED2021                 | 202009               | PROFILE         | CM             | False       | 0.00            |
    | 10017504 | ORG0017504 | 16ED-504          | 2218072         | 1619ED2021                 | 202010               | PROFILE         | CM             | False       | 0.00            |
    | 10017504 | ORG0017504 | 16ED-504          | 2218072         | 1619ED2021                 | 202011               | PROFILE         | CM             | False       | 0.00            |
    | 10017504 | ORG0017504 | 16ED-504          | 2218072         | 1619ED2021                 | 202012               | PROFILE         | CM             | False       | 1642.95         |
    | 10017504 | ORG0017504 | 16ED-504          | 2218072         | 1619ED2021                 | 202101               | PROFILE         | CM             | False       | 0.00            |
    | 10017504 | ORG0017504 | 16ED-504          | 2218072         | 1619ED2021                 | 202102               | PROFILE         | CM             | False       | 0.00            |
    | 10017504 | ORG0017504 | 16ED-504          | 2218072         | 1619ED2021                 | 202103               | PROFILE         | CM             | False       | 3422.47         |
    | 10017504 | ORG0017504 | 16ED-504          | 2218072         | 1619ED2021                 | 202104               | PROFILE         | CM             | False       | 0.00            |
    | 10017504 | ORG0017504 | 16ED-504          | 2218072         | 1619ED2021                 | 202105               | PROFILE         | CM             | False       | 378.79          |
    | 10017504 | ORG0017504 | 16ED-504          | 2218072         | 1619ED2021                 | 202106               | PROFILE         | CM             | False       | 0.00            |
    | 10017504 | ORG0017504 | 16ED-504          | 2218072         | 1619ED2021                 | 202107               | PROFILE         | CM             | False       | 1968.85         |


    # Tidy up
    And   the override date is reset
       