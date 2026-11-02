Feature: CreateSkillsBootcamps 36273

@AcceptanceTest @Complete
Scenario: A620 Bulk load a Skills Bootcamp (SB2022) contract for 22/23 and check docs. Add actuals. Payment Batch. Check financials
    Given there is no Contract, Task or Workflow data for UKPRN '10017620' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017620' 
 
    # Clear down ContractManagement.FundingAllocationRelease table
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017620' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | SB2022            |
    | SB-PAA2022        |

    # Clear down subnominal data from CRM SubnominalAggregation for specified subnominal codes (J162)
    And   there is no Subnominal data in CRM for the following subnominal codes
    | SubnominalCode |
    | 101139         |



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017620' 
    And   there is no caseload advisor for UKPRN '10017620' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017620 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017620' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017620 Co Ltd' with UKPRN '10017620' and OrgId 'ORG0017620' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017620 | 117620 | 10017620 Co Ltd | 0              | Active                | Yes           | AA017620      | ?             | 54 Maple Road          | 18 Osprey Court        | Surbiton               | ?                      | ?                      | Surrey                 | KT6 4BQ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017620 |





    # Change the date
    Given the override date is '01/08/2022'

    # Bulk file (UoP = W3L1) [Note: Deliverable 3: UnitCost * Volume <> Total Value. Changed UnitCost from £273.23 to £3.73]
    And   there are no files prefixed '10017620' in the Sharepoint 'SB-2022-Input-Appendices' folder
    And   there are no files prefixed 'SB SB 2022 27052022164141 v3_A620' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'SB SB 2022 27052022164141 v3_A620' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'SB SB 2022 27052022164141 v3_A620' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'SB SB 2022 27052022164141 v3_A620' in the Sharepoint 'Reports' folder
    And   spreadsheet 'SB SB 2022 27052022164141 v3_A620.xlsx' exists in the Datafiles folder and UKPRN '10017620' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10017620' for FundingType 'SB' and period '2022'

    # Check the contents of the Appendices (SoF, TaC, Sch1, Sch2, Sch3) (No FA)
    Then  the file named '10017620_[ContractNo]_v1.pdf' in Sharepoint location 'SB-2022-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING
    Organisation Name: 10017620 Co Ltd UKPRN: 10017620
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 30/09/2023
    Allocation
    Contract Ref Cost per Learner Number of Total Funding
    Learners
    (if fully-funded)
    Skills Bootcamps £3,485,270.31
    of which Advanced Engineering and Materials Testing [AllocRef_SB]-1 £322.40 984 £317,241.60
    of which Cloud [AllocRef_SB]-3 £3.23 878 £239,895.94
    of which Cloud computing (AWS Certified Cloud Practitioner) [AllocRef_SB]-6 £333.06 1,031 £343,384.86
    of which Building Information Modelling (BIM) Level 4 [AllocRef_SB]-14 £392.89 1,036 £407,034.04
    of which Introduction to Construction Site Management [AllocRef_SB]-22 £343.72 1,078 £370,530.16
    of which Commercial Drylining Skills Boot Camp, [AllocRef_SB]-31 £403.55 932 £376,108.60
    Unemployed Pathway
    of which Data Analyst [AllocRef_SB]-72 £462.37 937 £433,240.69
    of which DevOps [AllocRef_SB]-94 £113.20 1,060 £119,992.00
    of which Extended Reality (Games) [AllocRef_SB]-129 £472.03 982 £463,533.46
    of which Coding Skills Bootcamp [AllocRef_SB]-196 £123.60 1,027 £126,937.20
    of which Care (Senior Care Workers, Nursing [AllocRef_SB]-212 £183.43 1,032 £189,299.76
    Auxiliaries/Assistants)
    of which Welding and Coding Skills Bootcamp [AllocRef_SB]-237 £133.25 736 £98,072.00
    Total Funding for this contract: £3,485,270.31
    Summary of Funding – Page 1
     
    Agreement Type Contract for Services
    Funding Period 1 August 2022 to 30 September 2023
    Between the Secretary of State for Education
    And 10017620 Co Ltd
    Funding for Skills Bootcamps Wave 3
    Master Contract Number [MasterContractNo]
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    Ceri D’Mello, Deputy Director, Head of Commercial – Skills Category Commercial Directorate,
    Operations Group
    Skills Bootcamps Wave 3 Version 1 (August 2022) - Page 1
    This Contract is made on the date the Contract is digitally signed by the
    Contractor on the Manage Your Education & Skills Funding Service
    between:
    10017620 Co Ltd THE SECRETARY OF STATE FOR
    54 Maple Road EDUCATION
    18 Osprey Court DEPARTMENT FOR EDUCATION
    Surbiton 20 GREAT SMITH STREET
    AND
    Surrey LONDON
    KT6 4BQ SW1P 3BT
    Company No: AA017620
    Hereinafter called Hereinafter called
    the “Contractor” the “DFE”
    each a “Party” and together the “Parties”.
    Skills Bootcamps Wave 3 Version 1 (August 2022) - Page 2
    Skills Bootcamps Wave 3 Version 1 (August 2022) - Page 40

    Schedule 1
    The Specification
    Skills Bootcamps Wave 3 Schedule 1 Version 1 (August 2022) - Page 1
    Skills Bootcamps Wave 3 Schedule 1 Version 1 (August 2022) - Page 12
    
    Schedule 2
    Financials
    Payment triggers
    Learners not currently in Completion of 5 Successful completion Recording of a successful
    Skills Bootcamps Wave 3 Schedule 2 Version 1 (August 2022) - Page 1
    Skills Bootcamps Wave 3 Schedule 2 Version 1 (August 2022) - Page 4
    
    Schedule 3
    Skills Bootcamps Wave 3 Schedule 3 Version 1 (August 2022) - Page 1
    Skills Bootcamps Wave 3 Schedule 7 Version 1 (August 2022) - Page 1
    """

    # There should not be a Funding Agreement
    And   the pdf file does not contain the following text
    """
    Funding Agreement
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017620_[ContractNo]_v1.pdf' in 'SB-2022-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A620.pdf'





    # Publish and approve contract

    # Chenge the date
    Given the override date is '02/08/2022'

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017620 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2022        | 30/09/2023      | ?             |
    | 10017620 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2022        | 30/09/2023      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables (12 deliverables * 14 mths)
    And   there are '168' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_SB]   | 101139           | Sep-23 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '12' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef  | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                                      | DeliverableDescription   | 
    | 10017620 | [ContractNo]   | 1               | [AllocRef_SB]  | 1               | 0                     | 317241.60    | 984           | 322.40   | Advanced Manufacturing - Advanced Engineering and Materials Testing                  | ?                        |
    | 10017620 | [ContractNo]   | 1               | [AllocRef_SB]  | 3               | 0                     | 239895.94    | 878           | 3.23     | Cloud - Cloud                                                                        | ?                        |
    | 10017620 | [ContractNo]   | 1               | [AllocRef_SB]  | 6               | 0                     | 343384.86    | 1031          | 333.06   | Cloud - Cloud computing (AWS Certified Cloud Practitioner)                           | ?                        |
    | 10017620 | [ContractNo]   | 1               | [AllocRef_SB]  | 14              | 0                     | 407034.04    | 1036          | 392.89   | Computer Aided Design - Building Information Modelling (BIM) Level 4                 | ?                        |
    | 10017620 | [ContractNo]   | 1               | [AllocRef_SB]  | 22              | 0                     | 370530.16    | 1078          | 343.72   | Construction Management - Introduction to Construction Site Management               | ?                        |
    | 10017620 | [ContractNo]   | 1               | [AllocRef_SB]  | 31              | 0                     | 376108.60    | 932           | 403.55   | Construction Trades - Commercial Drylining Skills Boot Camp, Unemployed Pathway      | ?                        |
    | 10017620 | [ContractNo]   | 1               | [AllocRef_SB]  | 72              | 0                     | 433240.69    | 937           | 462.37   | Data - Data Analyst                                                                  | ?                        |
    | 10017620 | [ContractNo]   | 1               | [AllocRef_SB]  | 94              | 0                     | 119992.00    | 1060          | 113.20   | DevOps - DevOps                                                                      | ?                        |
    | 10017620 | [ContractNo]   | 1               | [AllocRef_SB]  | 129             | 0                     | 463533.46    | 982           | 472.03   | Games - Extended Reality                                                             | ?                        |
    | 10017620 | [ContractNo]   | 1               | [AllocRef_SB]  | 196             | 0                     | 126937.20    | 1027          | 123.60   | Software Engineering - Coding Skills Bootcamp                                        | ?                        |
    | 10017620 | [ContractNo]   | 1               | [AllocRef_SB]  | 212             | 0                     | 189299.76    | 1032          | 183.43   | Technical Bespoke - Care (Senior Care Workers, Nursing Auxiliaries/Assistants)       | ?                        |
    | 10017620 | [ContractNo]   | 1               | [AllocRef_SB]  | 237             | 0                     | 98072.00     | 736           | 133.25   | Welding - Welding and Coding Skills Bootcamp                                         | ?                        |


    # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | Aug-23   | Sep-23   |
    | [ContractNo]   | [AllocRef_SB]      | 1               | 317241.60 | 39010.40 | 29983.20 | 21278.40 | 34174.40 | 43846.40 | 27726.40 | 27404.00 | 15475.20 | 2901.60  | 28371.20 | 644.80   | 12251.20 | 25792.00 | 8382.40  | 
    | [ContractNo]   | [AllocRef_SB]      | 3               | 239895.94 | 12841.81 | 33334.06 | 24044.24 | 22131.63 | 17213.49 | 31694.68 | 29235.61 | 6284.29  | 23497.78 | 1912.61  | 6557.52  | 3551.99  | 12568.58 | 15027.65 | 
    | [ContractNo]   | [AllocRef_SB]      | 6               | 343384.86 | 4662.84  | 13655.46 | 23314.20 | 18318.30 | 46628.40 | 11657.10 | 29642.34 | 48959.82 | 17652.18 | 11990.16 | 1998.36  | 32306.82 | 40966.38 | 41632.50 | 
    | [ContractNo]   | [AllocRef_SB]      | 14              | 407034.04 | 35752.99 | 27895.19 | 36145.88 | 11393.81 | 26323.63 | 25144.96 | 43610.79 | 47932.58 | 51075.70 | 41646.34 | 11000.92 | 27895.19 | 19644.50 | 1571.56  | 
    | [ContractNo]   | [AllocRef_SB]      | 22              | 370530.16 | 6186.96  | 34372.00 | 39184.08 | 1374.88  | 11342.76 | 32309.68 | 45714.76 | 32997.12 | 19248.32 | 46402.20 | 16842.28 | 15811.12 | 43652.44 | 25091.56 | 
    | [ContractNo]   | [AllocRef_SB]      | 31              | 376108.60 | 38337.25 | 8071.00  | 38740.80 | 51654.40 | 44390.50 | 5246.15  | 2017.75  | 28248.50 | 53672.15 | 21791.70 | 12510.05 | 8071.00  | 21791.70 | 41565.65 | 
    | [ContractNo]   | [AllocRef_SB]      | 72              | 433240.69 | 10172.14 | 22656.13 | 54097.29 | 47161.74 | 17107.69 | 19881.91 | 63344.69 | 20806.65 | 27742.20 | 38839.08 | 24505.61 | 67043.65 | 9709.77  | 10172.14 | 
    | [ContractNo]   | [AllocRef_SB]      | 94              | 119992.00 | 11206.80 | 13357.60 | 15734.80 | 8716.40  | 12904.80 | 12678.40 | 905.60   | 2150.80  | 3056.40  | 339.60   | 8490.00  | 13470.80 | 11093.60 | 5886.40  | 
    | [ContractNo]   | [AllocRef_SB]      | 129             | 463533.46 | 30681.95 | 69860.44 | 5192.33  | 24073.53 | 19353.23 | 66556.23 | 14160.90 | 49091.12 | 49091.12 | 15104.96 | 26905.71 | 43898.79 | 11328.72 | 38234.43 | 
    | [ContractNo]   | [AllocRef_SB]      | 196             | 126937.20 | 17551.20 | 8281.20  | 17674.80 | 3090.00  | 988.80   | 7539.60  | 1483.20  | 9640.80  | 3831.60  | 7663.20  | 9764.40  | 8404.80  | 12483.60 | 18540.00 | 
    | [ContractNo]   | [AllocRef_SB]      | 212             | 189299.76 | 12656.67 | 17792.71 | 2751.45  | 27514.50 | 15591.55 | 16508.70 | 6236.62  | 9538.36  | 19810.44 | 24029.33 | 18526.43 | 7704.06  | 5136.04  | 5502.90  | 
    | [ContractNo]   | [AllocRef_SB]      | 237             | 98072.00  | 19454.50 | 2132.00  | 4930.25  | 11193.00 | 1599.00  | 1199.25  | 7462.00  | 3597.75  | 4663.75  | 1465.75  | 11059.75 | 2132.00  | 13991.25 | 13191.75 | 

    # Check the PLANNED VOLUMES in CRM on the latest approved contract
    And   the Planned Volumes are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | Aug-23   | Sep-23   |
    | [ContractNo]   | [AllocRef_SB]      | 1               | 984       | 121      | 93       | 66       | 106      | 136      | 86       | 85       | 48       | 9        | 88       | 2        | 38       | 80       | 26       | 
    | [ContractNo]   | [AllocRef_SB]      | 3               | 878       | 47       | 122      | 88       | 81       | 63       | 116      | 107      | 23       | 86       | 7        | 24       | 13       | 46       | 55       | 
    | [ContractNo]   | [AllocRef_SB]      | 6               | 1031      | 14       | 41       | 70       | 55       | 140      | 35       | 89       | 147      | 53       | 36       | 6        | 97       | 123      | 125      | 
    | [ContractNo]   | [AllocRef_SB]      | 14              | 1036      | 91       | 71       | 92       | 29       | 67       | 64       | 111      | 122      | 130      | 106      | 28       | 71       | 50       | 4        | 
    | [ContractNo]   | [AllocRef_SB]      | 22              | 1078      | 18       | 100      | 114      | 4        | 33       | 94       | 133      | 96       | 56       | 135      | 49       | 46       | 127      | 73       | 
    | [ContractNo]   | [AllocRef_SB]      | 31              | 932       | 95       | 20       | 96       | 128      | 110      | 13       | 5        | 70       | 133      | 54       | 31       | 20       | 54       | 103      | 
    | [ContractNo]   | [AllocRef_SB]      | 72              | 937       | 22       | 49       | 117      | 102      | 37       | 43       | 137      | 45       | 60       | 84       | 53       | 145      | 21       | 22       | 
    | [ContractNo]   | [AllocRef_SB]      | 94              | 1060      | 99       | 118      | 139      | 77       | 114      | 112      | 8        | 19       | 27       | 3        | 75       | 119      | 98       | 52       | 
    | [ContractNo]   | [AllocRef_SB]      | 129             | 982       | 65       | 148      | 11       | 51       | 41       | 141      | 30       | 104      | 104      | 32       | 57       | 93       | 24       | 81       | 
    | [ContractNo]   | [AllocRef_SB]      | 196             | 1027      | 142      | 67       | 143      | 25       | 8        | 61       | 12       | 78       | 31       | 62       | 79       | 68       | 101      | 150      | 
    | [ContractNo]   | [AllocRef_SB]      | 212             | 1032      | 69       | 97       | 15       | 150      | 85       | 90       | 34       | 52       | 108      | 131      | 101      | 42       | 28       | 30       | 
    | [ContractNo]   | [AllocRef_SB]      | 237             | 736       | 146      | 16       | 37       | 84       | 12       | 9        | 56       | 27       | 35       | 11       | 83       | 16       | 105      | 99       | 

    
    # The following step won't work until we are full updated to schema v 11.05

    # Test CRM details against same in ContractManagement feed (30447)
    And   the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed




    
    # Add actuals to the contract for SB2022(PoA) 

    # Change the date
    Given the override date is '04/11/2022'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017620'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Oct 2022
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202208 | SB2022                  | [AllocRef_SB]            | W3L1       | 1               | 0            | 1174.34     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202208 | SB2022                  | [AllocRef_SB]            | W3L1       | 3               | 0            | 634.00      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202208 | SB2022                  | [AllocRef_SB]            | W3L1       | 6               | 0            | 492.54      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202208 | SB2022                  | [AllocRef_SB]            | W3L1       | 14              | 0            | 1438.70     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202208 | SB2022                  | [AllocRef_SB]            | W3L1       | 22              | 0            | 1331.80     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202208 | SB2022                  | [AllocRef_SB]            | W3L1       | 31              | 0            | 567.19      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202208 | SB2022                  | [AllocRef_SB]            | W3L1       | 72              | 0            | 1038.73     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202208 | SB2022                  | [AllocRef_SB]            | W3L1       | 94              | 0            | 325.35      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202208 | SB2022                  | [AllocRef_SB]            | W3L1       | 129             | 0            | 908.69      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202208 | SB2022                  | [AllocRef_SB]            | W3L1       | 196             | 0            | 938.40      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202208 | SB2022                  | [AllocRef_SB]            | W3L1       | 212             | 0            | 432.01      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202208 | SB2022                  | [AllocRef_SB]            | W3L1       | 237             | 0            | 937.30      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202209 | SB2022                  | [AllocRef_SB]            | W3L1       | 1               | 0            | 509.94      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202209 | SB2022                  | [AllocRef_SB]            | W3L1       | 3               | 0            | 635.93      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202209 | SB2022                  | [AllocRef_SB]            | W3L1       | 6               | 0            | 1148.08     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202209 | SB2022                  | [AllocRef_SB]            | W3L1       | 14              | 0            | 925.65      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202209 | SB2022                  | [AllocRef_SB]            | W3L1       | 22              | 0            | 697.76      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202209 | SB2022                  | [AllocRef_SB]            | W3L1       | 31              | 0            | 1176.29     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202209 | SB2022                  | [AllocRef_SB]            | W3L1       | 72              | 0            | 278.04      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202209 | SB2022                  | [AllocRef_SB]            | W3L1       | 94              | 0            | 345.13      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202209 | SB2022                  | [AllocRef_SB]            | W3L1       | 129             | 0            | 1073.67     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202209 | SB2022                  | [AllocRef_SB]            | W3L1       | 196             | 0            | 708.04      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202209 | SB2022                  | [AllocRef_SB]            | W3L1       | 212             | 0            | 1266.83     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202209 | SB2022                  | [AllocRef_SB]            | W3L1       | 237             | 0            | 1439.15     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202210 | SB2022                  | [AllocRef_SB]            | W3L1       | 1               | 0            | 923.02      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202210 | SB2022                  | [AllocRef_SB]            | W3L1       | 3               | 0            | 828.26      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202210 | SB2022                  | [AllocRef_SB]            | W3L1       | 6               | 0            | 963.86      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202210 | SB2022                  | [AllocRef_SB]            | W3L1       | 14              | 0            | 1237.51     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202210 | SB2022                  | [AllocRef_SB]            | W3L1       | 22              | 0            | 1422.05     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202210 | SB2022                  | [AllocRef_SB]            | W3L1       | 31              | 0            | 1211.39     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202210 | SB2022                  | [AllocRef_SB]            | W3L1       | 72              | 0            | 736.41      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202210 | SB2022                  | [AllocRef_SB]            | W3L1       | 94              | 0            | 716.55      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202210 | SB2022                  | [AllocRef_SB]            | W3L1       | 129             | 0            | 657.35      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202210 | SB2022                  | [AllocRef_SB]            | W3L1       | 196             | 0            | 800.68      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202210 | SB2022                  | [AllocRef_SB]            | W3L1       | 212             | 0            | 395.34      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202210 | SB2022                  | [AllocRef_SB]            | W3L1       | 237             | 0            | 521.78      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202211 | SB2022                  | [AllocRef_SB]            | W3L1       | 1               | 0            | 1458.02     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202211 | SB2022                  | [AllocRef_SB]            | W3L1       | 3               | 0            | 562.09      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202211 | SB2022                  | [AllocRef_SB]            | W3L1       | 6               | 0            | 1183.42     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202211 | SB2022                  | [AllocRef_SB]            | W3L1       | 14              | 0            | 753.09      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202211 | SB2022                  | [AllocRef_SB]            | W3L1       | 22              | 0            | 790.03      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202211 | SB2022                  | [AllocRef_SB]            | W3L1       | 31              | 0            | 300.70      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202211 | SB2022                  | [AllocRef_SB]            | W3L1       | 72              | 0            | 326.04      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202211 | SB2022                  | [AllocRef_SB]            | W3L1       | 94              | 0            | 1062.34     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202211 | SB2022                  | [AllocRef_SB]            | W3L1       | 129             | 0            | 713.43      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202211 | SB2022                  | [AllocRef_SB]            | W3L1       | 196             | 0            | 789.60      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202211 | SB2022                  | [AllocRef_SB]            | W3L1       | 212             | 0            | 894.59      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202211 | SB2022                  | [AllocRef_SB]            | W3L1       | 237             | 0            | 1063.55     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202212 | SB2022                  | [AllocRef_SB]            | W3L1       | 1               | 0            | 901.75      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202212 | SB2022                  | [AllocRef_SB]            | W3L1       | 3               | 0            | 1211.28     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202212 | SB2022                  | [AllocRef_SB]            | W3L1       | 6               | 0            | 732.15      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202212 | SB2022                  | [AllocRef_SB]            | W3L1       | 14              | 0            | 1055.57     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202212 | SB2022                  | [AllocRef_SB]            | W3L1       | 22              | 0            | 1474.09     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202212 | SB2022                  | [AllocRef_SB]            | W3L1       | 31              | 0            | 661.59      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202212 | SB2022                  | [AllocRef_SB]            | W3L1       | 72              | 0            | 441.82      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202212 | SB2022                  | [AllocRef_SB]            | W3L1       | 94              | 0            | 557.22      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202212 | SB2022                  | [AllocRef_SB]            | W3L1       | 129             | 0            | 1139.61     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202212 | SB2022                  | [AllocRef_SB]            | W3L1       | 196             | 0            | 1216.11     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202212 | SB2022                  | [AllocRef_SB]            | W3L1       | 212             | 0            | 437.51      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202212 | SB2022                  | [AllocRef_SB]            | W3L1       | 237             | 0            | 904.94      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202301 | SB2022                  | [AllocRef_SB]            | W3L1       | 1               | 0            | 654.62      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202301 | SB2022                  | [AllocRef_SB]            | W3L1       | 3               | 0            | 1309.06     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202301 | SB2022                  | [AllocRef_SB]            | W3L1       | 6               | 0            | 807.18      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202301 | SB2022                  | [AllocRef_SB]            | W3L1       | 14              | 0            | 662.94      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202301 | SB2022                  | [AllocRef_SB]            | W3L1       | 22              | 0            | 342.09      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202301 | SB2022                  | [AllocRef_SB]            | W3L1       | 31              | 0            | 674.69      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202301 | SB2022                  | [AllocRef_SB]            | W3L1       | 72              | 0            | 1488.65     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202301 | SB2022                  | [AllocRef_SB]            | W3L1       | 94              | 0            | 1345.91     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202301 | SB2022                  | [AllocRef_SB]            | W3L1       | 129             | 0            | 423.64      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202301 | SB2022                  | [AllocRef_SB]            | W3L1       | 196             | 0            | 601.25      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202301 | SB2022                  | [AllocRef_SB]            | W3L1       | 212             | 0            | 257.86      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202301 | SB2022                  | [AllocRef_SB]            | W3L1       | 237             | 0            | 954.08      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202302 | SB2022                  | [AllocRef_SB]            | W3L1       | 1               | 0            | 414.11      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202302 | SB2022                  | [AllocRef_SB]            | W3L1       | 3               | 0            | 747.31      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202302 | SB2022                  | [AllocRef_SB]            | W3L1       | 6               | 0            | 1029.71     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202302 | SB2022                  | [AllocRef_SB]            | W3L1       | 14              | 0            | 320.98      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202302 | SB2022                  | [AllocRef_SB]            | W3L1       | 22              | 0            | 1328.62     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202302 | SB2022                  | [AllocRef_SB]            | W3L1       | 31              | 0            | 1270.72     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202302 | SB2022                  | [AllocRef_SB]            | W3L1       | 72              | 0            | 1221.25     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202302 | SB2022                  | [AllocRef_SB]            | W3L1       | 94              | 0            | 1023.53     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202302 | SB2022                  | [AllocRef_SB]            | W3L1       | 129             | 0            | 702.00      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202302 | SB2022                  | [AllocRef_SB]            | W3L1       | 196             | 0            | 270.01      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202302 | SB2022                  | [AllocRef_SB]            | W3L1       | 212             | 0            | 677.52      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202302 | SB2022                  | [AllocRef_SB]            | W3L1       | 237             | 0            | 1104.70     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202303 | SB2022                  | [AllocRef_SB]            | W3L1       | 1               | 0            | 420.94      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202303 | SB2022                  | [AllocRef_SB]            | W3L1       | 3               | 0            | 288.29      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202303 | SB2022                  | [AllocRef_SB]            | W3L1       | 6               | 0            | 909.85      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202303 | SB2022                  | [AllocRef_SB]            | W3L1       | 14              | 0            | 1108.71     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202303 | SB2022                  | [AllocRef_SB]            | W3L1       | 22              | 0            | 1118.46     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202303 | SB2022                  | [AllocRef_SB]            | W3L1       | 31              | 0            | 1379.66     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202303 | SB2022                  | [AllocRef_SB]            | W3L1       | 72              | 0            | 896.58      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202303 | SB2022                  | [AllocRef_SB]            | W3L1       | 94              | 0            | 428.62      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202303 | SB2022                  | [AllocRef_SB]            | W3L1       | 129             | 0            | 630.92      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202303 | SB2022                  | [AllocRef_SB]            | W3L1       | 196             | 0            | 738.08      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202303 | SB2022                  | [AllocRef_SB]            | W3L1       | 212             | 0            | 696.36      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202303 | SB2022                  | [AllocRef_SB]            | W3L1       | 237             | 0            | 1466.58     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202304 | SB2022                  | [AllocRef_SB]            | W3L1       | 1               | 0            | 267.61      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202304 | SB2022                  | [AllocRef_SB]            | W3L1       | 3               | 0            | 1388.86     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202304 | SB2022                  | [AllocRef_SB]            | W3L1       | 6               | 0            | 373.99      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202304 | SB2022                  | [AllocRef_SB]            | W3L1       | 14              | 0            | 356.36      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202304 | SB2022                  | [AllocRef_SB]            | W3L1       | 22              | 0            | 1392.75     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202304 | SB2022                  | [AllocRef_SB]            | W3L1       | 31              | 0            | 1192.46     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202304 | SB2022                  | [AllocRef_SB]            | W3L1       | 72              | 0            | 488.61      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202304 | SB2022                  | [AllocRef_SB]            | W3L1       | 94              | 0            | 498.63      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202304 | SB2022                  | [AllocRef_SB]            | W3L1       | 129             | 0            | 1070.00     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202304 | SB2022                  | [AllocRef_SB]            | W3L1       | 196             | 0            | 911.01      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202304 | SB2022                  | [AllocRef_SB]            | W3L1       | 212             | 0            | 394.56      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202304 | SB2022                  | [AllocRef_SB]            | W3L1       | 237             | 0            | 1408.55     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202305 | SB2022                  | [AllocRef_SB]            | W3L1       | 1               | 0            | 519.54      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202305 | SB2022                  | [AllocRef_SB]            | W3L1       | 3               | 0            | 1337.11     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202305 | SB2022                  | [AllocRef_SB]            | W3L1       | 6               | 0            | 604.60      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202305 | SB2022                  | [AllocRef_SB]            | W3L1       | 14              | 0            | 375.89      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202305 | SB2022                  | [AllocRef_SB]            | W3L1       | 22              | 0            | 1387.56     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202305 | SB2022                  | [AllocRef_SB]            | W3L1       | 31              | 0            | 735.30      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202305 | SB2022                  | [AllocRef_SB]            | W3L1       | 72              | 0            | 465.73      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202305 | SB2022                  | [AllocRef_SB]            | W3L1       | 94              | 0            | 687.82      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202305 | SB2022                  | [AllocRef_SB]            | W3L1       | 129             | 0            | 1078.31     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202305 | SB2022                  | [AllocRef_SB]            | W3L1       | 196             | 0            | 1345.97     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202305 | SB2022                  | [AllocRef_SB]            | W3L1       | 212             | 0            | 1147.47     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202305 | SB2022                  | [AllocRef_SB]            | W3L1       | 237             | 0            | 1413.92     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202306 | SB2022                  | [AllocRef_SB]            | W3L1       | 1               | 0            | 898.64      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202306 | SB2022                  | [AllocRef_SB]            | W3L1       | 3               | 0            | 1201.72     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202306 | SB2022                  | [AllocRef_SB]            | W3L1       | 6               | 0            | 1442.62     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202306 | SB2022                  | [AllocRef_SB]            | W3L1       | 14              | 0            | 1253.89     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202306 | SB2022                  | [AllocRef_SB]            | W3L1       | 22              | 0            | 764.99      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202306 | SB2022                  | [AllocRef_SB]            | W3L1       | 31              | 0            | 1256.28     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202306 | SB2022                  | [AllocRef_SB]            | W3L1       | 72              | 0            | 1380.54     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202306 | SB2022                  | [AllocRef_SB]            | W3L1       | 94              | 0            | 1447.77     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202306 | SB2022                  | [AllocRef_SB]            | W3L1       | 129             | 0            | 472.98      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202306 | SB2022                  | [AllocRef_SB]            | W3L1       | 196             | 0            | 325.97      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202306 | SB2022                  | [AllocRef_SB]            | W3L1       | 212             | 0            | 1152.96     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202306 | SB2022                  | [AllocRef_SB]            | W3L1       | 237             | 0            | 1498.48     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202307 | SB2022                  | [AllocRef_SB]            | W3L1       | 1               | 0            | 1279.40     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202307 | SB2022                  | [AllocRef_SB]            | W3L1       | 3               | 0            | 343.55      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202307 | SB2022                  | [AllocRef_SB]            | W3L1       | 6               | 0            | 352.24      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202307 | SB2022                  | [AllocRef_SB]            | W3L1       | 14              | 0            | 1457.08     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202307 | SB2022                  | [AllocRef_SB]            | W3L1       | 22              | 0            | 296.74      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202307 | SB2022                  | [AllocRef_SB]            | W3L1       | 31              | 0            | 674.62      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202307 | SB2022                  | [AllocRef_SB]            | W3L1       | 72              | 0            | 1272.18     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202307 | SB2022                  | [AllocRef_SB]            | W3L1       | 94              | 0            | 770.34      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202307 | SB2022                  | [AllocRef_SB]            | W3L1       | 129             | 0            | 1450.28     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202307 | SB2022                  | [AllocRef_SB]            | W3L1       | 196             | 0            | 1496.58     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202307 | SB2022                  | [AllocRef_SB]            | W3L1       | 212             | 0            | 1271.23     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202307 | SB2022                  | [AllocRef_SB]            | W3L1       | 237             | 0            | 1190.98     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202308 | SB2022                  | [AllocRef_SB]            | W3L1       | 1               | 0            | 497.50      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202308 | SB2022                  | [AllocRef_SB]            | W3L1       | 3               | 0            | 1239.97     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202308 | SB2022                  | [AllocRef_SB]            | W3L1       | 6               | 0            | 448.34      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202308 | SB2022                  | [AllocRef_SB]            | W3L1       | 14              | 0            | 1250.26     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202308 | SB2022                  | [AllocRef_SB]            | W3L1       | 22              | 0            | 360.25      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202308 | SB2022                  | [AllocRef_SB]            | W3L1       | 31              | 0            | 592.43      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202308 | SB2022                  | [AllocRef_SB]            | W3L1       | 72              | 0            | 881.25      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202308 | SB2022                  | [AllocRef_SB]            | W3L1       | 94              | 0            | 1043.16     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202308 | SB2022                  | [AllocRef_SB]            | W3L1       | 129             | 0            | 519.21      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202308 | SB2022                  | [AllocRef_SB]            | W3L1       | 196             | 0            | 565.09      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202308 | SB2022                  | [AllocRef_SB]            | W3L1       | 212             | 0            | 1177.19     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202308 | SB2022                  | [AllocRef_SB]            | W3L1       | 237             | 0            | 1076.05     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202309 | SB2022                  | [AllocRef_SB]            | W3L1       | 1               | 0            | 470.89      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202309 | SB2022                  | [AllocRef_SB]            | W3L1       | 3               | 0            | 871.47      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202309 | SB2022                  | [AllocRef_SB]            | W3L1       | 6               | 0            | 1336.25     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202309 | SB2022                  | [AllocRef_SB]            | W3L1       | 14              | 0            | 1426.82     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202309 | SB2022                  | [AllocRef_SB]            | W3L1       | 22              | 0            | 997.25      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202309 | SB2022                  | [AllocRef_SB]            | W3L1       | 31              | 0            | 1118.87     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202309 | SB2022                  | [AllocRef_SB]            | W3L1       | 72              | 0            | 427.09      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202309 | SB2022                  | [AllocRef_SB]            | W3L1       | 94              | 0            | 1217.56     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202309 | SB2022                  | [AllocRef_SB]            | W3L1       | 129             | 0            | 747.65      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202309 | SB2022                  | [AllocRef_SB]            | W3L1       | 196             | 0            | 1062.33     |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202309 | SB2022                  | [AllocRef_SB]            | W3L1       | 212             | 0            | 825.31      |
    | ILR2022        | R03                  | ORG0017620     | CM             | 202309 | SB2022                  | [AllocRef_SB]            | W3L1       | 237             | 0            | 899.70      |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | Aug-23   | Sep-23   |
    | [ContractNo]   | [AllocRef_SB]      | 1               | 2607.30   | 1174.34  | 509.94   | 923.02   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SB]      | 3               | 2098.19   | 634.00   | 635.93   | 828.26   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SB]      | 6               | 2604.48   | 492.54   | 1148.08  | 963.86   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SB]      | 14              | 3601.86   | 1438.70  | 925.65   | 1237.51  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SB]      | 22              | 3451.61   | 1331.80  | 697.76   | 1422.05  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SB]      | 31              | 2954.87   | 567.19   | 1176.29  | 1211.39  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SB]      | 72              | 2053.18   | 1038.73  | 278.04   | 736.41   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SB]      | 94              | 1387.03   | 325.35   | 345.13   | 716.55   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SB]      | 129             | 2639.71   | 908.69   | 1073.67  | 657.35   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SB]      | 196             | 2447.12   | 938.40   | 708.04   | 800.68   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SB]      | 212             | 2094.18   | 432.01   | 1266.83  | 395.34   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SB]      | 237             | 2898.23   | 937.30   | 1439.15  | 521.78   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | Aug-23   | Sep-23   |
    | [ContractNo]   | [AllocRef_SB]      | 1               | 2607.30   | 0.00     | 0.00     | 2607.30  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 3               | 2098.19   | 0.00     | 0.00     | 2098.19  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 6               | 2604.48   | 0.00     | 0.00     | 2604.48  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 14              | 3601.86   | 0.00     | 0.00     | 3601.86  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 22              | 3451.61   | 0.00     | 0.00     | 3451.61  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 31              | 2954.87   | 0.00     | 0.00     | 2954.87  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 72              | 2053.18   | 0.00     | 0.00     | 2053.18  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 94              | 1387.03   | 0.00     | 0.00     | 1387.03  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 129             | 2639.71   | 0.00     | 0.00     | 2639.71  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 196             | 2447.12   | 0.00     | 0.00     | 2447.12  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 212             | 2094.18   | 0.00     | 0.00     | 2094.18  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 237             | 2898.23   | 0.00     | 0.00     | 2898.23  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #                                                                                         £ 30837.76

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | Aug-23   | Sep-23   |
    | [ContractNo]   | [AllocRef_SB]      | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 14              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 22              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 31              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 72              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 94              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 129             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 196             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 212             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 237             | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | Aug-23   | Sep-23   |
    | [ContractNo]   | [AllocRef_SB]      | 1               | 2607.30   | 0.00     | 0.00     | 2607.30  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 3               | 2098.19   | 0.00     | 0.00     | 2098.19  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 6               | 2604.48   | 0.00     | 0.00     | 2604.48  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 14              | 3601.86   | 0.00     | 0.00     | 3601.86  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 22              | 3451.61   | 0.00     | 0.00     | 3451.61  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 31              | 2954.87   | 0.00     | 0.00     | 2954.87  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 72              | 2053.18   | 0.00     | 0.00     | 2053.18  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 94              | 1387.03   | 0.00     | 0.00     | 1387.03  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 129             | 2639.71   | 0.00     | 0.00     | 2639.71  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 196             | 2447.12   | 0.00     | 0.00     | 2447.12  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 212             | 2094.18   | 0.00     | 0.00     | 2094.18  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SB]      | 237             | 2898.23   | 0.00     | 0.00     | 2898.23  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #                                                                                         £ 30837.76





    # Payment Batch for SB2022(PoA)

    # Change the date
    Given the override date is '08/11/2022 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'SB2022' AccountingPaymentPeriod '202207' CensusEndDate '08/11/2022' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | [AllocRef_SB]            | 202210 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | SB2022                     | 202210               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | SB2022                     | 202210               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'SB2022' PaymentPeriod '202207' CensusEndDate '08/11/2022' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A620.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'SB2022' PaymentPeriod '202207' CensusEndDate '08/11/2022' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef     | AggregatedValue | PaymentType      | SubnominalDescription              | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | SB                     | 2022          | 07             | 08          | ?       | [AllocRef_SB]     | 30837.76        | RECONCILIATION   | Skills Bootcamps                   | 2022-11-18 | 2022-08-01   | 2025-07-31 | ?              | 10017620 | 101139     |

   
    # Check the RECONCILIATION subnominal aggregations in CRM
    And   the Reconciliation Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ReconciliationSubnominal | Aug-22    | Sep-22    | Oct-22    | Nov-22    | Dec-22    | Jan-23    | Feb-23    | Mar-23    | Apr-23    | May-23    | Jun-23    | Jul-23    | Aug-23    | Sep-23    |
    | 10017620 | [ContractNo]   | [AllocRef_SB]      | 101139                   | 0.00      | 0.00      | 30837.76  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 
   

    # Tidy Up
  # Given the override date is reset

@AcceptanceTest @Complete
Scenario: A634 Bulk load a Skills Bootcamp Pathway (SB-PAA2022) contract for 22/23. Bulk amend. Publish and approve. Check docs. Add actuals. Payment Batch. Check financials
    Given there are no allocations marked as Under Termination for UKPRN '10017634' 
    And   there are no terminated or closed allocations for UKPRN '10017634' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017634' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017634' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017634' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | SB-PAA2022        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017634'



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017634' 
    And   there is no caseload advisor for UKPRN '10017634' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017634 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017634' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017634 Co Ltd' with UKPRN '10017634' and OrgId 'ORG0017634' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017634 | 117634 | 10017634 Co Ltd | 0              | In Administration     | Yes           | AA017634      | ?             | 46 The Avenue          | ?                      | ?                      | ?                      | Bournemouth            | Dorset                 | BH9 2UW   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017634 |





    # Change the date
    Given the override date is '01/07/2022'

    # Bulk file (UoP = W3L6)
    And   there are no files prefixed '10017634' in the Sharepoint 'SB-2022-Input-Appendices' folder
    And   there are no files prefixed 'SB SB 2022 13072022094413 v3_A634' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'SB SB 2022 13072022094413 v3_A634' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'SB SB 2022 13072022094413 v3_A634' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'SB SB 2022 13072022094413 v3_A634' in the Sharepoint 'Reports' folder
    And   spreadsheet 'SB SB 2022 13072022094413 v3_A634.xlsx' exists in the Datafiles folder and UKPRN '10017634' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10017634' for FundingType 'SB' and period '2022'

    # Check the contents of the Appendices (SoF, TaC, Sch1, Sch2, Sch3)
    Then  the file named '10017634_[ContractNo]_v1.pdf' in Sharepoint location 'SB-2022-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING
    Organisation Name: 10017634 Co Ltd UKPRN: 10017634
    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 30/09/2023
    Allocation
    Contract Ref Cost per Learner Number of Total Funding
    Learners
    (if fully-funded)
    Skills Bootcamps £4,967,728.47
    of which Amazon Web Services (AWS) Accelerated [AllocRef_SBA]-1 £206.25 846 £174,487.50
    Apprenticeship - Information Communication Technician
    of which Breakthrough Prison Pathway (Digital Support Tech) [AllocRef_SBA]-2 £395.13 1,136 £448,867.68
    of which Breakthrough Rehabilitation Pathway (Digital [AllocRef_SBA]-3 £475.28 1,345 £639,251.60
    Support Tech)
    of which Cloud Engineering [AllocRef_SBA]-4 £255.42 841 £214,808.22
    of which Cloud Technician [AllocRef_SBA]-5 £335.30 1,035 £347,035.50
    of which Construction - Building the road to Apprenticeships [AllocRef_SBA]-6 £242.76 945 £229,408.20
    of which Cyber Security [AllocRef_SBA]-7 £323.91 853 £276,295.23
    of which Data Analyst [AllocRef_SBA]-8 £103.05 1,222 £125,927.10
    of which Data Analyst L4 [AllocRef_SBA]-9 £183.93 942 £173,262.06
    of which Data Analytics [AllocRef_SBA]-10 £263.08 998 £262,553.84
    of which Digital Marketing [AllocRef_SBA]-11 £452.22 949 £429,156.78
    of which EPOS NOW ICT Bootcamp [AllocRef_SBA]-12 £123.10 556 £68,443.60
    of which Fast Track to Rail [AllocRef_SBA]-13 £312.25 954 £297,886.50
    of which Pathway to Materials Testing Apprenticeships [AllocRef_SBA]-14 £393.39 1,055 £415,026.45
    of which Software Developer [AllocRef_SBA]-15 £173.27 1,421 £246,216.67
    of which Software Development [AllocRef_SBA]-16 £278.48 893 £248,682.64
    of which Solar/Renewable Electrician [AllocRef_SBA]-17 £1,000.00 1,030 £370,418.90
    Total Funding for this contract: £4,967,728.47
    Summary of Funding – Page 1

    Agreement Type Contract for Services
    Funding Period 1 August 2022 to 30 September 2023
    Between the Secretary of State for Education
    And 10017634 Co Ltd
    Funding for Skills Bootcamps Wave 3
    Master Contract Number [MasterContractNo]
    SIGNED FOR AND ON BEHALF OF
    THE SECRETARY OF STATE FOR EDUCATION
    Ceri D’Mello, Deputy Director, Head of Commercial – Skills Category Commercial Directorate,
    Operations Group
    Skills Bootcamps Wave 3 Version 1 (August 2022) - Page 1
    This Contract is made on the date the Contract is digitally signed by the
    Contractor on the Manage Your Education & Skills Funding Service
    between:
    10017634 Co Ltd THE SECRETARY OF STATE FOR
    46 The Avenue EDUCATION
    Bournemouth DEPARTMENT FOR EDUCATION
    Dorset 20 GREAT SMITH STREET
    AND
    BH9 2UW LONDON
    SW1P 3BT
    Company No: AA017634
    Hereinafter called Hereinafter called
    the “Contractor” the “DFE”
    each a “Party” and together the “Parties”.
    Skills Bootcamps Wave 3 Version 1 (August 2022) - Page 2
    Skills Bootcamps Wave 3 Version 1 (August 2022) - Page 40
    
    Schedule 1
    The Specification
    Skills Bootcamps Wave 3 Schedule 1 Version 1 (August 2022) - Page 1
    Skills Bootcamps Wave 3 Schedule 1 Version 1 (August 2022) - Page 12
    
    Schedule 2
    Financials
    Payment triggers
    Learners not currently in Completion of 5 Successful completion Recording of a successful
    Skills Bootcamps Wave 3 Schedule 2 Version 1 (August 2022) - Page 1
    Skills Bootcamps Wave 3 Schedule 2 Version 1 (August 2022) - Page 4
    
    Schedule 3
    Skills Bootcamps Wave 3 Schedule 3 Version 1 (August 2022) - Page 1
    Skills Bootcamps Wave 3 Schedule 7 Version 1 (August 2022) - Page 1
    """

    # There should not be a Funding Agreement
    And   the pdf file does not contain the following text
    """
    Funding Agreement
    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017634_[ContractNo]_v1.pdf' in 'SB-2022-Input-Appendices' is copied to 'Datafiles/Downloads' as 'A634.pdf'

    
    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    Given the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017634 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2022        | 30/09/2023      | ?             |
    | 10017634 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2022        | 30/09/2023      | ?             |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed

    # Check the deliverable count in CRM includes all the monitoring deliverables (17 deliverables x 14mths)
    And   there are '238' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_SBA]  | 101139           | Sep-23 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '17' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef  | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                                      | DeliverableDescription   | 
    | 10017634 | [ContractNo]   | 1               | [AllocRef_SBA] | 1               | 0                     | 174487.50    | 846           | 206.25   | Apprenticeships Paths - Amazon Web Services (AWS) Accelerated Apprenticeship - ICT   | ?                        |
    | 10017634 | [ContractNo]   | 1               | [AllocRef_SBA] | 2               | 0                     | 448867.68    | 1136          | 395.13   | Apprenticeships Paths - Breakthrough Prison Pathway (Digital Support Tech)           | ?                        |
    | 10017634 | [ContractNo]   | 1               | [AllocRef_SBA] | 3               | 0                     | 639251.60    | 1345          | 475.28   | Apprenticeships Paths - Breakthrough Rehabilitation Pathway (Digital Support Tech)   | ?                        |
    | 10017634 | [ContractNo]   | 1               | [AllocRef_SBA] | 4               | 0                     | 214808.22    | 841           | 255.42   | Apprenticeships Paths - Cloud Engineering                                            | ?                        |
    | 10017634 | [ContractNo]   | 1               | [AllocRef_SBA] | 5               | 0                     | 347035.50    | 1035          | 335.30   | Apprenticeships Paths - Cloud Technician                                             | ?                        |
    | 10017634 | [ContractNo]   | 1               | [AllocRef_SBA] | 6               | 0                     | 229408.20    | 945           | 242.76   | Apprenticeships Paths - Construction - Building the road to Apprenticeships          | ?                        |
    | 10017634 | [ContractNo]   | 1               | [AllocRef_SBA] | 7               | 0                     | 276295.23    | 853           | 323.91   | Apprenticeships Paths - Cyber Security                                               | ?                        |
    | 10017634 | [ContractNo]   | 1               | [AllocRef_SBA] | 8               | 0                     | 125927.10    | 1222          | 103.05   | Apprenticeships Paths - Data Analyst                                                 | ?                        |
    | 10017634 | [ContractNo]   | 1               | [AllocRef_SBA] | 9               | 0                     | 173262.06    | 942           | 183.93   | Apprenticeships Paths - Data Analyst L4                                              | ?                        |
    | 10017634 | [ContractNo]   | 1               | [AllocRef_SBA] | 10              | 0                     | 262553.84    | 998           | 263.08   | Apprenticeships Paths - Data Analytics                                               | ?                        |
    | 10017634 | [ContractNo]   | 1               | [AllocRef_SBA] | 11              | 0                     | 429156.78    | 949           | 452.22   | Apprenticeships Paths - Digital Marketing                                            | ?                        |
    | 10017634 | [ContractNo]   | 1               | [AllocRef_SBA] | 12              | 0                     | 68443.60     | 556           | 123.10   | Apprenticeships Paths - EPOS NOW ICT Bootcamp                                        | ?                        |
    | 10017634 | [ContractNo]   | 1               | [AllocRef_SBA] | 13              | 0                     | 297886.50    | 954           | 312.25   | Apprenticeships Paths - Fast Track to Rail                                           | ?                        |
    | 10017634 | [ContractNo]   | 1               | [AllocRef_SBA] | 14              | 0                     | 415026.45    | 1055          | 393.39   | Apprenticeships Paths - Pathway to Materials Testing Apprenticeships                 | ?                        |
    | 10017634 | [ContractNo]   | 1               | [AllocRef_SBA] | 15              | 0                     | 246216.67    | 1421          | 173.27   | Apprenticeships Paths - Software Developer                                           | ?                        |
    | 10017634 | [ContractNo]   | 1               | [AllocRef_SBA] | 16              | 0                     | 248682.64    | 893           | 278.48   | Apprenticeships Paths - Software Development                                         | ?                        |
    | 10017634 | [ContractNo]   | 1               | [AllocRef_SBA] | 17              | 0                     | 370418.90    | 1030          | 1000.00  | Apprenticeships Paths - Solar/Renewable Electrician                                  | ?                        |

    # Test CRM details against same in ContractManagement feed (30447)
    Then  the details in CRM for version '1' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed


    # Check ADP

    # Check all activity has completed
    When  there are no messages left in the system

    # Check Planned data on the ADP feed for Aug-22
    Then  the Allocation Delivery Monitoring Service atom feed contains the following Planned data
    | AllocationDeliveryEntryCategory   | ContractNumber     | VersionNumber | AllocationNumber | DeliverableCode | Period | PlannedValue | PlannedVolume | 
    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_SBA]   | 1               | 202208 | 1237.50      | 6             |
    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_SBA]   | 2               | 202208 | 51366.90     | 130           |
    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_SBA]   | 3               | 202208 | 49904.40     | 105           |
    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_SBA]   | 4               | 202208 | 20178.18     | 79            |
    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_SBA]   | 5               | 202208 | 18106.20     | 54            |
    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_SBA]   | 6               | 202208 | 18207.00     | 75            |
    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_SBA]   | 7               | 202208 | 15871.59     | 49            |
    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_SBA]   | 8               | 202208 | 2370.15      | 23            |
    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_SBA]   | 9               | 202208 | 27221.64     | 148           |
    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_SBA]   | 10              | 202208 | 21572.56     | 82            |
    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_SBA]   | 11              | 202208 | 25776.54     | 57            |
    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_SBA]   | 12              | 202208 | 3816.10      | 31            |
    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_SBA]   | 13              | 202208 | 1561.25      | 5             |
    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_SBA]   | 14              | 202208 | 51140.70     | 130           |
    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_SBA]   | 15              | 202208 | 18020.08     | 104           |
    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_SBA]   | 16              | 202208 | 24506.24     | 88            |
    | NewContractAllocationApproved     | [ContractNo]       | 1             | [AllocRef_SBA]   | 17              | 202208 | 22297.06     | 62            |





    # Add actuals to the contract for SB-PAA2022

    # Change the date
    Given the override date is '04/09/2022'

    # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
    And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0017634'

    # Clear down the stub
    And   there are no entries in the DCFS stub table

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Pull actuals from DC for Aug 2022 (Four deliverables)
    And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | ILR2022        | R01                  | ORG0017634     | CM             | 202208 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 1               | 0            | 8229.83     |
    | ILR2022        | R01                  | ORG0017634     | CM             | 202208 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 3               | 0            | 1479.98     |
    | ILR2022        | R01                  | ORG0017634     | CM             | 202208 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 6               | 0            | 386.12      |
    | ILR2022        | R01                  | ORG0017634     | CM             | 202208 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 14              | 0            | 557.23      |
    | ILR2022        | R01                  | ORG0017634     | CM             | 202209 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 1               | 0            | 547.07      |
    | ILR2022        | R01                  | ORG0017634     | CM             | 202209 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 3               | 0            | 552.44      |
    | ILR2022        | R01                  | ORG0017634     | CM             | 202209 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 6               | 0            | 8158.52     |
    | ILR2022        | R01                  | ORG0017634     | CM             | 202209 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 14              | 0            | 833.14      |
    | ILR2022        | R01                  | ORG0017634     | CM             | 202210 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 1               | 0            | 1002.62     |
    | ILR2022        | R01                  | ORG0017634     | CM             | 202210 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 3               | 0            | 648.52      |
    | ILR2022        | R01                  | ORG0017634     | CM             | 202210 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 6               | 0            | 544.67      |
    | ILR2022        | R01                  | ORG0017634     | CM             | 202210 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 14              | 0            | 9464.05     |
    | ILR2022        | R01                  | ORG0017634     | CM             | 202211 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 1               | 0            | 554.29      |
    | ILR2022        | R01                  | ORG0017634     | CM             | 202211 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 3               | 0            | 472.80      |
    | ILR2022        | R01                  | ORG0017634     | CM             | 202211 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 6               | 0            | 946.40      |
    | ILR2022        | R01                  | ORG0017634     | CM             | 202211 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 14              | 0            | 947.65      |
    | ILR2022        | R01                  | ORG0017634     | CM             | 202212 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 1               | 0            | 349.64      |
    | ILR2022        | R01                  | ORG0017634     | CM             | 202212 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 3               | 0            | 410.80      |
    | ILR2022        | R01                  | ORG0017634     | CM             | 202212 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 6               | 0            | 972.78      |
    | ILR2022        | R01                  | ORG0017634     | CM             | 202212 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 14              | 0            | 409.82      |
    | ILR2022        | R01                  | ORG0017634     | CM             | 202301 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 1               | 0            | 1151.67     |
    | ILR2022        | R01                  | ORG0017634     | CM             | 202301 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 3               | 0            | 751.60      |
    | ILR2022        | R01                  | ORG0017634     | CM             | 202301 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 6               | 0            | 772.21      |
    | ILR2022        | R01                  | ORG0017634     | CM             | 202301 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 14              | 0            | 1358.51     |
    | ILR2022        | R01                  | ORG0017634     | CM             | 202302 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 1               | 0            | 1327.16     |
    | ILR2022        | R01                  | ORG0017634     | CM             | 202302 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 3               | 0            | 1473.01     |
    | ILR2022        | R01                  | ORG0017634     | CM             | 202302 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 6               | 0            | 1426.93     |
    | ILR2022        | R01                  | ORG0017634     | CM             | 202302 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 14              | 0            | 1250.15     |
    | ILR2022        | R01                  | ORG0017634     | CM             | 202303 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 1               | 0            | 1397.43     |
    | ILR2022        | R01                  | ORG0017634     | CM             | 202303 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 3               | 0            | 1089.18     |
    | ILR2022        | R01                  | ORG0017634     | CM             | 202303 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 6               | 0            | 910.02      |
    | ILR2022        | R01                  | ORG0017634     | CM             | 202303 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 14              | 0            | 618.56      |
    | ILR2022        | R01                  | ORG0017634     | CM             | 202304 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 1               | 0            | 1401.61     |
    | ILR2022        | R01                  | ORG0017634     | CM             | 202304 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 3               | 0            | 810.83      |
    | ILR2022        | R01                  | ORG0017634     | CM             | 202304 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 6               | 0            | 354.98      |
    | ILR2022        | R01                  | ORG0017634     | CM             | 202304 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 14              | 0            | 516.39      |
    | ILR2022        | R01                  | ORG0017634     | CM             | 202305 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 1               | 0            | 1072.44     |
    | ILR2022        | R01                  | ORG0017634     | CM             | 202305 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 3               | 0            | 267.86      |
    | ILR2022        | R01                  | ORG0017634     | CM             | 202305 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 6               | 0            | 637.75      |
    | ILR2022        | R01                  | ORG0017634     | CM             | 202305 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 14              | 0            | 268.95      |
    | ILR2022        | R01                  | ORG0017634     | CM             | 202306 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 1               | 0            | 324.56      |
    | ILR2022        | R01                  | ORG0017634     | CM             | 202306 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 3               | 0            | 1044.52     |
    | ILR2022        | R01                  | ORG0017634     | CM             | 202306 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 6               | 0            | 521.23      |
    | ILR2022        | R01                  | ORG0017634     | CM             | 202306 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 14              | 0            | 540.71      |
    | ILR2022        | R01                  | ORG0017634     | CM             | 202307 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 1               | 0            | 1305.26     |
    | ILR2022        | R01                  | ORG0017634     | CM             | 202307 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 3               | 0            | 527.04      |
    | ILR2022        | R01                  | ORG0017634     | CM             | 202307 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 6               | 0            | 1362.30     |
    | ILR2022        | R01                  | ORG0017634     | CM             | 202307 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 14              | 0            | 464.11      |
    | ILR2022        | R01                  | ORG0017634     | CM             | 202308 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 1               | 0            | 757.78      |
    | ILR2022        | R01                  | ORG0017634     | CM             | 202308 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 3               | 0            | 1063.84     |
    | ILR2022        | R01                  | ORG0017634     | CM             | 202308 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 6               | 0            | 881.36      |
    | ILR2022        | R01                  | ORG0017634     | CM             | 202308 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 14              | 0            | 1331.05     |
    | ILR2022        | R01                  | ORG0017634     | CM             | 202309 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 1               | 0            | 1447.09     |
    | ILR2022        | R01                  | ORG0017634     | CM             | 202309 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 3               | 0            | 688.12      |
    | ILR2022        | R01                  | ORG0017634     | CM             | 202309 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 6               | 0            | 994.40      |
    | ILR2022        | R01                  | ORG0017634     | CM             | 202309 | SB-PAA2022              | [AllocRef_SBA]           | W3L6       | 14              | 0            | 596.72      |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    # Check the ACTUAL VALUES in CRM on the latest approved contract
    Then  the Actuals Value Data is as follows
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | Aug-23   | Sep-23   |
    | [ContractNo]   | [AllocRef_SBA]     | 1               | 8229.83   | 8229.83  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SBA]     | 2               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SBA]     | 3               | 1479.98   | 1479.98  | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SBA]     | 4               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SBA]     | 5               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SBA]     | 6               | 386.12    | 386.12   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SBA]     | 7               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SBA]     | 8               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SBA]     | 9               | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SBA]     | 10              | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SBA]     | 11              | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SBA]     | 12              | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SBA]     | 13              | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SBA]     | 14              | 557.23    | 557.23   | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SBA]     | 15              | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SBA]     | 16              | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 
    | [ContractNo]   | [AllocRef_SBA]     | 17              | 0.00      | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | ?        | 

    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | Aug-23   | Sep-23   |
    | [ContractNo]   | [AllocRef_SBA]     | 1               | 8229.83   | 8229.83  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 3               | 1479.98   | 1479.98  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 6               | 386.12    | 386.12   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 8               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 9               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 10              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 11              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 12              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 13              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 14              | 557.23    | 557.23   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 15              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 16              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 17              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #                                                                   £ 10653.16

    # Check the CAPPING AMOUNTS in CRM on the latest approved contract
    And   the Capping Amounts are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | Aug-23   | Sep-23   |
    | [ContractNo]   | [AllocRef_SBA]     | 1               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 3               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 6               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 8               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 9               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 10              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 11              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 12              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 13              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 14              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 15              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 16              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 17              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 

    # Check the NET AMOUNTS in CRM on the latest approved contract
    And   the Net Payments are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | Aug-23   | Sep-23   |
    | [ContractNo]   | [AllocRef_SBA]     | 1               | 8229.83   | 8229.83  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 2               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 3               | 1479.98   | 1479.98  | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 4               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 5               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 6               | 386.12    | 386.12   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 7               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 8               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 9               | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 10              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 11              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 12              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 13              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 14              | 557.23    | 557.23   | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 15              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 16              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_SBA]     | 17              | 0.00      | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 
    #                                                                   £ 10653.16





    # Payment Batch for SB-PAA2022(PoA)

    # Change the date
    Given the override date is '08/09/2022 22:05'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
    And   there is no data in the Payment feed for FundingStreamPeriod 'SB-PAA2022' AccountingPaymentPeriod '202205' CensusEndDate '08/09/2022' and LinkCodeSuffix 'A'

    # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
    And   the following allocation periods are present in the subnominal aggregation PaaS table
    | ContractAllocationNumber | Period |
    | [AllocRef_SBA]           | 202208 |

    # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
    And   the following configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
    | SB-PAA2022                 | 202208               |                      | A              | NotStarted |

    When  the Payment Generation Batch run is started

    # PaymentGeneration.PaymentTimetable
    Then  there is an entry in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Status    |
    | SB-PAA2022                 | 202208               | Completed |

    # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
    And   the Payment feed xml for FundingStreamPeriod 'SB-PAA2022' PaymentPeriod '202205' CensusEndDate '08/09/2022' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'A634.xml'

    # Use the latest Payment Generation corporate schema to check the PaymentGeneration.PaymentBatchFeedItem for specific items and values (19014)
    And   the Payment feed xml for FundingStreamPeriod 'SB-PAA2022' PaymentPeriod '202205' CensusEndDate '08/09/2022' and LinkCodeSuffix 'A' includes the following values
    | FundingStreamShortCode | FinancialYear | FinancialMonth | CensusEndDD | LEPCode | AllocationRef     | AggregatedValue | PaymentType      | SubnominalDescription  | DueDate    | FSPStartDate | FSPEndDate | LEPAgreementNo | UKPRN    | Subnominal |
    | SBPA                   | 2022          | 05             | 08          | ?       | [AllocRef_SBA]    | 10653.16        | RECONCILIATION   | Skills Bootcamps       | 2022-09-20 | 2022-08-01   | 2025-07-31 | ?              | 10017634 | 101139     |


    # Check the RECONCILIATION subnominal aggregations in CRM
    And   the Reconciliation Subnominal Amounts are calculated as follows
    | UKPRN    | ContractNumber | AllocationRef      | ReconciliationSubnominal | Aug-22    | Sep-22    | Oct-22    | Nov-22    | Dec-22    | Jan-23    | Feb-23    | Mar-23    | Apr-23    | May-23    | Jun-23    | Jul-23    | Aug-23    | Sep-23    |
    | 10017634 | [ContractNo]   | [AllocRef_SBA]     | 101139                   | 10653.16  | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 0.00      | 


    # Tidy Up
    Given the override date is reset

@AcceptanceTest @Withdrawn20230118
Scenario: A582
    Given there are no allocations marked as Under Termination for UKPRN '10017582' 
    And   there are no terminated or closed allocations for UKPRN '10017582' 
    And   there is no Contract, Task or Workflow data for UKPRN '10017582' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10017582' 
 
    # Clear down ContractManagement.FundingAllocationRelease table (J146) 
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10017582' 


    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down subnominal data from CRM and PaaS for an allocation
    And   there is no Subnominal data in CRM or PaaS for the following contract allocations
    | AllocationRef |
    | SB-582        |


    # Clear down PaymentSchedule.DeliverablePayment data for a specified allocation number
    And   there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | SB-582        |

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | SB2022            |

    # Clear down subnominal data from CRM SubnominalAggregation for specified subnominal codes (J162)
    And   there is no Subnominal data in CRM for the following subnominal codes
    | SubnominalCode |
    | 101139         |


    # Delete specific rows from the ContractManagement.CreatedContract table (J105)
    And   there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber |
    | SBP-582        | 1                     | 0                        |

    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    And   there are no Sector-based Work Academies profile values in config for UKPRN '10017582'




    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10017582' 
    And   there is no caseload advisor for UKPRN '10017582' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10017582 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10017582' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017582 Co Ltd' with UKPRN '10017582' and OrgId 'ORG0017582' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017582 | 117582 | 10017582 Co Ltd | 0              | Active                | Yes           | AA017582      | ?             | 35 Mosbach Gardens     | Hutton                 | ?                      | ?                      | Brentwood              | Essex                  | CM13 2UW  |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017582 |





    # Change the date
    Given the override date is '01/07/2022'

    # Remove all contract details from ContractManagement.CreatedContract
 #  And   there are no created contracts for this number 'SBP-582'
    And   there are no details in ContractManagement.CreatedContract for 'SBP-582'

    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractDescription                   | ContractType                               | Period | CRMIntent    | OrgId      |
    | 10017582 | 10017582 Co Ltd      | ESFA-582             | SBP-582        | 1                     | 01/08/2022        | 31/07/2025      | 13680.00      |                                       | Contract for Services (SB Wave 3)          | 2022   | New          | ORG0017582 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName                                 | UoPCode    | AllocationDescription                                       | CRMIntent    | DeliveryOrg |
    | 10017582 | SBP-582        | SB-582        | SB                | SB2022                  | SB                      | 01/08/2022          | 31/07/2025        | 13680.00        | Wave 3 Lot 4 - Technical Bespoke        | W3L4       |                                                             | New          |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | Total     | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | Aug-23   | Sep-23   | DeliverableDescription                                                          | CRMIntent    | DeliveryOrg |
    | 10017582 | SBP-582        | SB-582        | 1               | 0                     | 13680.00  | 900.00   | 580.00   | 1060.00  | 1420.00  | 820.00   | 800.00   | 360.00   | 1700.00  | 840.00   | 1620.00  | 240.00   | 740.00   | 1900.00  | 700.00   | Advanced Manufacturing - Advanced Engineering and Materials Testing             | New          |             | 

    And   the draft contract deliverable volume details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | UnitCost | Total   | Aug-22   | Sep-22   | Oct-22   | Nov-22   | Dec-22   | Jan-23   | Feb-23   | Mar-23   | Apr-23   | May-23   | Jun-23   | Jul-23   | Aug-23   | Sep-23   | 
    | 10017582 | SBP-582        | SB-582        | 1               | 20       | 684     | 45       | 29       | 53       | 71       | 41       | 40       | 18       | 85       | 42       | 81       | 12       | 37       | 95       | 35       |

    And   the contract exists in CRM
    # Contract is now at 'Draft\Awaiting Documentation'

    # Insert/Update details into the ContractManagement.CreatedContract table (J104)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    And   the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | SBP-582        | 1                     | 0                        | 2022-07-01 09:12:35.000 |

    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    And   the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'SBP-582'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
 #  When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    When  a contract approval message is received from SFS for MasterContractNumber 'ESFA-582' and ContractNumber 'SBP-582' and Version '1'

    # Check that the contract is now approved
    Then  the latest version of contract 'SBP-582' has a substatus of 'Approved'

    # Check the CONTRACT version, status and dates in CRM.
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017582 | SBP-582            | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2022        | 31/07/2025      | ?             |
    | 10017582 | ESFA-582           | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2022        | 31/07/2025      | ?             |

 