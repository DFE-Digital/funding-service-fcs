Feature: CreateSectorBasedContracts 30807

@AcceptanceTest @Withdrawn20231002
Scenario: A067 Bulk create an EDSK2021 contract which has Sector-based values for both AEBC-ASCL2021 and AEB-AS2021 in Contract Ref Data in config (10002923). Check doc.
    Given there are no allocations marked as Under Termination for UKPRN '10002923' 
    And   there are no terminated or closed allocations for UKPRN '10002923' 
    And   there is no Contract, Task or Workflow data for UKPRN '10002923' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10002923' 

    # Don't touch Sector-based values for 10002923
#   # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
#   And   there are no Sector-based Work Academies profile values in config for UKPRN '10002923'




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10002923' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10002923 Co Ltd' with UKPRN '10002923' and OrgId 'ORG0002923' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status    | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10002923 | 002923 | 10002923 Co Ltd | 0              | Active    | Yes           | AA002923      | ?             | 34 Comet Road          | ?                      | ?                      | ?                      | Hatfield               | Hertfordshire          | AL10 0SX  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10002923 |




    # Change the date
    Given the override date is '25/07/2020'

    # These are the Live values in config for this provider so don't change them
#   # Upsert the provider config values for Sector-based Work Academies for a specific UKPRN and FSP (DocumentsDomain.ContractReferenceConfig) (30680)
#   Given the following Sector-based Work Academies profile values exist in config
#   | UKPRN    | FSPCode       | Aug20-Mar21 | Apr21-Jul21 |
#   | 10002923 | AEBC-AS2021   | 8376.00     | 4116.00     |
#   | 10002923 | AEBC-ASCL2021 | 26839.00    | 16117.00    |


    # Bulk file
    And   there are no files prefixed '10002923' in the Sharepoint 'EDSK-2021-Input-Appendices' folder
    And   there are no files prefixed 'EDSK AY 2021 07092020083517 v3_A067' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'EDSK AY 2021 07092020083517 v3_A067' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'EDSK AY 2021 07092020083517 v3_A067' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'EDSK AY 2021 07092020083517 v3_A067' in the Sharepoint 'Reports' folder
    And   spreadsheet 'EDSK AY 2021 07092020083517 v3_A067.xlsx' exists in the Datafiles folder and UKPRN '10002923' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10002923' for FundingType 'EDSK' and period '2021' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10002923' for FundingType 'EDSK' and period '2021'

    # Check the contents of the SoF (for the Sector-based parameter values)
    Then  the file named '10002923_[ContractNo]_v1.pdf' in Sharepoint location 'EDSK-2021-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING 2020/21
    Organisation Name: 10002923 Co Ltd UKPRN: 10002923
    Master Contract Number: [MasterContractNo]
    Allocation
    Contract Ref Aug 20 - Mar 21 Apr 21 - Jul 21 2020/21 Total
    ESFA AEB - Adult Skills and Community Learning [AllocRef_AECA] £67,249 £38,196 £105,445
    of which Community Learning £30,245 £22,192 £52,437
    of which Sector-based Work Academies £26,839 £16,117 £42,956
    Total Funding for this contract: £105,445
    Summary of Funding – Page 1
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10002923_[ContractNo]_v1.pdf' in 'EDSK-2021-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A067.pdf'

    # Tidy Up
    And   the override date is reset
  
@AcceptanceTest @Withdrawn20231002
Scenario: A068 Bulk create an AEBP contract which has Sector-based values for both AEBC-ASCL2021 and AEB-AS2021 in Contract Ref Data in config (10007696). Check doc.
    Given there are no allocations marked as Under Termination for UKPRN '10002923' 
    And   there are no terminated or closed allocations for UKPRN '10002923' 
    And   there is no Contract, Task or Workflow data for UKPRN '10002923' 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10002923' 

    # Don't touch Sector-based values for 10002923
#   # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
#   And   there are no Sector-based Work Academies profile values in config for UKPRN '10002923'




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10002923' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10002923 Co Ltd' with UKPRN '10002923' and OrgId 'ORG0002923' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status    | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10002923 | 002923 | 10002923 Co Ltd | 0              | Active    | Yes           | AA002923      | ?             | 34 Comet Road          | ?                      | ?                      | ?                      | Hatfield               | Hertfordshire          | AL10 0SX  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10002923 |




    # Change the date
    Given the override date is '25/07/2020'

    # These are the Live values in config for this provider so don't change them
#   # Upsert the provider config values for Sector-based Work Academies for a specific UKPRN and FSP (DocumentsDomain.ContractReferenceConfig) (30680)
#   Given the following Sector-based Work Academies profile values exist in config
#   | UKPRN    | FSPCode       | Aug20-Mar21 | Apr21-Jul21 |
#   | 10002923 | AEBC-AS2021   | 8376.00     | 4116.00     |
#   | 10002923 | AEBC-ASCL2021 | 26839.00    | 16117.00    |


    # Bulk file
    And   there are no files prefixed '10002923' in the Sharepoint 'AEB-2021-Input-Appendices' folder
    And   there are no files prefixed 'AEB AY 2021 07092020093407 v3_A068' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'AEB AY 2021 07092020093407 v3_A068' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'AEB AY 2021 07092020093407 v3_A068' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'AEB AY 2021 07092020093407 v3_A068' in the Sharepoint 'Reports' folder
    And   spreadsheet 'AEB AY 2021 07092020093407 v3_A068.xlsx' exists in the Datafiles folder and UKPRN '10002923' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
   #When  I retrieve the latest EFA contract details from CRM for provider '10002923' for FundingType 'AEB' and period '2021' and Delivery Organisation '00000000'
    When  I retrieve the latest contract details from CRM for provider '10002923' for FundingType 'AEB' and period '2021'

    # Check the contents of the SoF (for the Sector-based parameter values)
    Then  the file named '10002923_[ContractNo]_v1.pdf' in Sharepoint location 'AEB-2021-Input-Appendices' contains the following lines in order
    """
    APPENDIX 1 – SUMMARY OF FUNDING
    Organisation Name: 10002923 Co Ltd UKPRN: 10002923
    Master Contract Number: [MasterContractNo]
    Allocation
    1 August 2020 to 31 July 2021 Contract Ref Aug 20 - Mar 21 Apr 21 - Jul 21 Total
    ESFA AEB - Adult Skills [AllocRef_AEBA] £41,384 £23,616 £65,000
    of which Sector-based Work Academies £8,376 £4,116 £12,492
    Total: £65,000
    Total Funding for this contract: £65,000  
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10002923_[ContractNo]_v1.pdf' in 'AEB-2021-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A068.pdf'

    # Tidy Up
    And   the override date is reset
