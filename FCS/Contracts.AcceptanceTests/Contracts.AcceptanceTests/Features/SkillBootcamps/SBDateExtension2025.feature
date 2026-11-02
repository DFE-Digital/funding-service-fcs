Feature: SBDateExtension2025



@AcceptanceTest @Complete
Scenario: AK038 Bulk load a Skills Bootcamp (SB2022) contract for 22/23 and check docs. Add actuals. Payment Batch. Check financials
    Given there is no Contract, Task or Workflow data for UKPRN '10010038' 
    And   there are no notifications in CRM of type 'Approval Received' for UKPRN '10010038' 
 
    # Clear down ContractManagement.FundingAllocationRelease table
    Given there is no data in the ContractRequest.FundingAllocationRelease table 
 
    # Clear down ADP and CM feeds 
    And   the Allocation Delivery Monitoring Service atom feed is empty 
    And   the Contract Management atom feed is empty 
 
    # Cleardown actuals audit data 
    And   there is no data on MonitoringDeliverables.AllocationDeliverablePeriodActualAudit for UKPRN '10010038' 

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

    # Clear down all subnominal data from PaaS for an FSP
    And   there is no Subnominal data in PaaS for the following FSPs
    | FSP               |
    | SB2022            |
    | SB-PAA2022        |

    # Clear down subnominal data from CRM SubnominalAggregation for specified subnominal codes (J162)
    #And   there is no Subnominal data in CRM for the following subnominal codes
    #| SubnominalCode |
    #| 101139         |



    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10010038' 
    And   there is no caseload advisor for UKPRN '10010038' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10010038 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10010038' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10010038 Co Ltd' with UKPRN '10010038' and OrgId 'ORG0010038' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10010038 | 110038 | 10010038 Co Ltd | 0              | Active                | Yes           | AA010038      | ?             | 54 Maple Road          | 18 Osprey Court        | Surbiton               | ?                      | ?                      | Surrey                 | KT6 4BQ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10010038 |





    # Change the date
    Given the override date is '01/08/2022'

    # Bulk file (UoP = W3L1) [Note: Deliverable 3: UnitCost * Volume <> Total Value. Changed UnitCost from £273.23 to £3.73]
    And   there are no files prefixed '10010038' in the Sharepoint 'SB-2022-Input-Appendices' folder
    And   there are no files prefixed 'SB SB 2022 28052025164141 v3_AK038' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'SB SB 2022 28052025164141 v3_AK038' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'SB SB 2022 28052025164141 v3_AK038' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'SB SB 2022 28052025164141 v3_AK038' in the Sharepoint 'Reports' folder
    And   spreadsheet 'SB SB 2022 28052025164141 v3_AK038.xlsx' exists in the Datafiles folder and UKPRN '10010038' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
   #When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10010038' for FundingType 'SB' and period '2022'

    # Check the contents of the Appendices (SoF, TaC, Sch1, Sch2, Sch3) (No FA)
    Then  the file named '10010038_[ContractNo]_v1.pdf' in Sharepoint location 'SB-2022-Input-Appendices' contains the following lines in order
    """
    SUMMARY OF FUNDING
    Organisation Name: 10010038 Co Ltd UKPRN: 10010038
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
    And 10010038 Co Ltd
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
    10010038 Co Ltd THE SECRETARY OF STATE FOR
    54 Maple Road EDUCATION
    18 Osprey Court DEPARTMENT FOR EDUCATION
    Surbiton 20 GREAT SMITH STREET
    AND
    Surrey LONDON
    KT6 4BQ SW1P 3BT
    Company No: AA010038
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
    And   Sharepoint file '10010038_[ContractNo]_v1.pdf' in 'SB-2022-Input-Appendices' is copied to 'Datafiles/Downloads' as 'AK038.pdf'





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
    | 10010038 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2022        | 30/09/2023      | ?             |
    | 10010038 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2022        | 30/09/2023      | ?             |

    # Check the deliverable count in CRM includes all the monitoring deliverables (12 deliverables * 14 mths)

    # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_SB]   | 101139           | Sep-23 | Reconciliation |

    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
    Then  the Legal Contract CM feed contains the following '12' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef  | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                                      | DeliverableDescription   | 
    | 10010038 | [ContractNo]   | 1               | [AllocRef_SB]  | 1               | 0                     | 317241.60    | 984           | 322.40   | Advanced Manufacturing - Advanced Engineering and Materials Testing                  | ?                        |
    | 10010038 | [ContractNo]   | 1               | [AllocRef_SB]  | 3               | 0                     | 239895.94    | 878           | 3.23     | Cloud - Cloud                                                                        | ?                        |
    | 10010038 | [ContractNo]   | 1               | [AllocRef_SB]  | 6               | 0                     | 343384.86    | 1031          | 333.06   | Cloud - Cloud computing (AWS Certified Cloud Practitioner)                           | ?                        |
    | 10010038 | [ContractNo]   | 1               | [AllocRef_SB]  | 14              | 0                     | 407034.04    | 1036          | 392.89   | Computer Aided Design - Building Information Modelling (BIM) Level 4                 | ?                        |
    | 10010038 | [ContractNo]   | 1               | [AllocRef_SB]  | 22              | 0                     | 370530.16    | 1078          | 343.72   | Construction Management - Introduction to Construction Site Management               | ?                        |
    | 10010038 | [ContractNo]   | 1               | [AllocRef_SB]  | 31              | 0                     | 376108.60    | 932           | 403.55   | Construction Trades - Commercial Drylining Skills Boot Camp, Unemployed Pathway      | ?                        |
    | 10010038 | [ContractNo]   | 1               | [AllocRef_SB]  | 72              | 0                     | 433240.69    | 937           | 462.37   | Data - Data Analyst                                                                  | ?                        |
    | 10010038 | [ContractNo]   | 1               | [AllocRef_SB]  | 94              | 0                     | 119992.00    | 1060          | 113.20   | DevOps - DevOps                                                                      | ?                        |
    | 10010038 | [ContractNo]   | 1               | [AllocRef_SB]  | 129             | 0                     | 463533.46    | 982           | 472.03   | Games - Extended Reality                                                             | ?                        |
    | 10010038 | [ContractNo]   | 1               | [AllocRef_SB]  | 196             | 0                     | 126937.20    | 1027          | 123.60   | Software Engineering - Coding Skills Bootcamp                                        | ?                        |
    | 10010038 | [ContractNo]   | 1               | [AllocRef_SB]  | 212             | 0                     | 189299.76    | 1032          | 183.43   | Technical Bespoke - Care (Senior Care Workers, Nursing Auxiliaries/Assistants)       | ?                        |
    | 10010038 | [ContractNo]   | 1               | [AllocRef_SB]  | 237             | 0                     | 98072.00     | 736           | 133.25   | Welding - Welding and Coding Skills Bootcamp                                         | ?                        |


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




        # Extension of SB contract to Jul 2025

    # Change the date
    Given the override date is '15/03/2025'

    # Bulk file (UoP = W3L1)
    And   there are no files prefixed '10010038' in the Sharepoint 'SB-2022-Input-Appendices' folder
    And   there are no files prefixed 'SB SB 2022 30052025164141 v3_AK038_a' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'SB SB 2022 30052025164141 v3_AK038_a' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'SB SB 2022 30052025164141 v3_AK038_a' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'SB SB 2022 30052025164141 v3_AK038_a' in the Sharepoint 'Reports' folder
    And   spreadsheet 'SB SB 2022 30052025164141 v3_AK038_a.xlsx' exists in the Datafiles folder and UKPRN '10010038' is present in cell 'A2' of the Contract tab
   #When  the file is copied to the Sharepoint 'Input' folder 
    When  the file is copied to the Sharepoint Input folder and all parameter values in the spreadsheet have been updated to actual values
    Then  a syntax report showing file success should exist in the Sharepoint Reports folder
    And   the syntax report includes the phrase 'Success'
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report


    # Retrieve parameters
    When  I retrieve the latest contract details from CRM for provider '10010038' for FundingType 'SB' and period '2022'

#    # Check the contents of the Appendices (SoF, TaC, Sch1, Sch2, Sch3)
#    Then  the file named '10010038_[ContractNo]_v4.pdf' in Sharepoint location 'SB-2022-Input-Appendices' contains the following lines in order
#    """
#    SUMMARY OF FUNDING
#    Organisation Name: 10010038 Co Ltd UKPRN: 10010038
#    Master Contract Number: [MasterContractNo] Start Date: 01/08/2022 End Date: 30/09/2024
#    Allocation
#    Contract Ref Cost per Learner Number of Total Funding
#    Learners
#    (if fully-funded)
#    Skills Bootcamps £4,203,360.00
#    of which Data Analyst [AllocRef_SB]-72 £120.00 208 £24,960.00
#    of which Digital Marketing [AllocRef_SB]-115 £140.00 1,560 £218,400.00
#    of which Software Development [AllocRef_SB]-189 £3,450.00 260 £897,000.00
#    of which Bay Electech - Electronic Skills Programme 2 [AllocRef_SB]-238 £1,000.00 2,600 £307,000.00
#    of which Trade Skills Development Centre [AllocRef_SB]-239 £2,000.00 598 £1,196,000.00
#    of which Plant Operator Skills Bootcamp 2 [AllocRef_SB]-240 £150.00 1,040 £156,000.00
#    of which OTP Operative [AllocRef_SB]-242 £150.00 1,040 £156,000.00
#    of which New Entrant - Possession Management [AllocRef_SB]-243 £150.00 1,040 £156,000.00
#    of which Project Controls [AllocRef_SB]-244 £150.00 1,040 £156,000.00
#    of which Cloud with Cyber [AllocRef_SB]-245 £150.00 1,040 £156,000.00
#    of which Renewable Energy Electrical Installer [AllocRef_SB]-246 £150.00 1,040 £156,000.00
#    of which Creative Computing [AllocRef_SB]-247 £150.00 1,040 £156,000.00
#    of which Leadership & Management [AllocRef_SB]-248 £150.00 1,040 £156,000.00
#    of which Plastering inc Internal Thermal Insulation [AllocRef_SB]-249 £150.00 1,040 £156,000.00
#    of which Brick inc External Thermal Insulation [AllocRef_SB]-250 £150.00 1,040 £156,000.00
#    Total Funding for this contract: £4,203,360.00
#    Summary of Funding – Page 1
#
#    Agreement Type Contract for Services
#    Funding Period 1 August 2022 to 30 September 2024
#    """
#
#    # There should not be a Funding Agreement
#    And   the pdf file does not contain the following text
#    """
#    Funding Agreement
#    """

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10010038_[ContractNo]_v2.pdf' in 'SB-2022-Input-Appendices' is copied to 'Datafiles/Downloads' as 'AK038b.pdf'


    # Update the contract from 'Awaiting Documentation' to 'Published to Provider'
    Given the contract sub-status is updated to 'Published to Provider' on the latest version of contract '[ContractNo]'

    # Month end is not running
    And   the PaaS MonthEndIsRunning indicator is set to 'False'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '2'

    # Check that the contract is now approved
    Then  the latest version of contract '[ContractNo]' has a substatus of 'Approved'


# # Check the CONTRACT version, status and dates in CRM.
#    And   the following contract values are present in CRM
#    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
#    | 10010038 | [ContractNo]       | 2                     | 0                        | Approved         | Approved                  | True          | True                | 01/08/2022        | 31/07/2025      | ?             |
#    | 10010038 | [ContractNo]       | 1                     | 0                        | Replaced         | Approved                  | False         | False               | 01/08/2022        | 31/03/2023      | ?             |
#    | 10010038 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/08/2022        | 30/09/2023      | ?             |
#





#        # Check that the CRM subnominals have been created before moving on
    And   CRM subnominals have been created for the following allocations
    | AllocationRef   | Subnominal Code  | Period | Payment Type   |
    | [AllocRef_SB]   | 101139           | APR-25 | Reconciliation |
    | [AllocRef_SBA]  | 101139           | APR-25 | Reconciliation |
#
#    # Check deliverable data in the ContractManagement Legal feed (APPROVEDCONTRACT)
       Then  the Legal Contract CM feed contains the following '14' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef  | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                                                                      | DeliverableDescription   | 
    | 10010038 | [ContractNo]   | 2               | [AllocRef_SB]  | 1               | 0                     | 501,654.40    | 1,556          | 322.40   | Advanced Manufacturing - Advanced Engineering and Materials Testing                  | ?                        |
    | 10010038 | [ContractNo]   | 2               | [AllocRef_SB]  | 3               | 0                     | 570,504.24    | 2,088          | 3.23     | Cloud - Cloud                                                                        | ?                        |
    | 10010038 | [ContractNo]   | 2               | [AllocRef_SB]  | 6               | 0                     | 1,259,299.86  | 3,781          | 333.06   | Cloud - Cloud computing (AWS Certified Cloud Practitioner)                           | ?                        |
    | 10010038 | [ContractNo]   | 2               | [AllocRef_SB]  | 14              | 0                     | 441,608.36    | 1,124          | 392.89   | Computer Aided Design - Building Information Modelling (BIM) Level 4                 | ?                        |
    | 10010038 | [ContractNo]   | 2               | [AllocRef_SB]  | 22              | 0                     | 922,544.48    | 2,684          | 343.72   | Construction Management - Introduction to Construction Site Management               | ?                        |
    | 10010038 | [ContractNo]   | 2               | [AllocRef_SB]  | 31              | 0                     | 1,290,552.90  | 3,198          | 403.55   | Construction Trades - Commercial Drylining Skills Boot Camp, Unemployed Pathway      | ?                        |
    | 10010038 | [ContractNo]   | 2               | [AllocRef_SB]  | 72              | 0                     | 657,027.77    | 1,421          | 462.37   | Data - Data Analyst                                                                  | ?                        |
    | 10010038 | [ContractNo]   | 2               | [AllocRef_SB]  | 94              | 0                     | 249,492.80    | 2,204          | 113.20   | DevOps - DevOps                                                                      | ?                        |
    | 10010038 | [ContractNo]   | 2               | [AllocRef_SB]  | 129             | 0                     | 1,304,690.92  | 2,764          | 472.03   | Games - Extended Reality                                                             | ?                        |
    | 10010038 | [ContractNo]   | 2               | [AllocRef_SB]  | 196             | 0                     | 534,817.20    | 4,327          | 123.60   | Software Engineering - Coding Skills Bootcamp                                        | ?                        |
    | 10010038 | [ContractNo]   | 2               | [AllocRef_SB]  | 212             | 0                     | 310,363.56    | 1,692          | 183.43   | Technical Bespoke - Care (Senior Care Workers, Nursing Auxiliaries/Assistants)       | ?                        |
    | 10010038 | [ContractNo]   | 2               | [AllocRef_SB]  | 237             | 0                     | 388,290.50    | 2,914          | 133.25   | Welding - Welding and Coding Skills Bootcamp                                         | ?                        |
    | 10010038 | [ContractNo]   | 2               | [AllocRef_SBA] | 18              | 0                     | 34567.00      | 180            | 4122.00  | Apprenticeship Paths - Analysing Data (leading to Data Technician)                   | ?                        |
    | 10010038 | [ContractNo]   | 2               | [AllocRef_SBA] | 19              | 0                     | 2356.00       | 120            | 234.00   | Apprenticeship Paths - Pathway to Apprenticeship			                          | ?                        |


#    # Check the PLANNED VALUES in CRM on the latest approved contract
    And   the Planned Values are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-24   | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   | Apr-25   | May-25   | Jun-25   | Jul-25   | 
    | [ContractNo]   | [AllocRef_SB]      | 1               | 100588.8  | 8382.40  | 8382.40  | 8382.40  | 8382.40  | 8382.40  | 8382.40  | 8382.40  | 8382.40  | 8382.40  | 8382.40  | 8382.40  | 8382.40  |  
    | [ContractNo]   | [AllocRef_SB]      | 3               | 180331.8  | 15027.65 | 15027.65 | 15027.65 | 15027.65 | 15027.65 | 15027.65 | 15027.65 | 15027.65 | 15027.65 | 15027.65 | 15027.65 | 15027.65 |  
    | [ContractNo]   | [AllocRef_SB]      | 6               | 499590    | 41632.50 | 41632.50 | 41632.50 | 41632.50 | 41632.50 | 41632.50 | 41632.50 | 41632.50 | 41632.50 | 41632.50 | 41632.50 | 41632.50 |  
    | [ContractNo]   | [AllocRef_SB]      | 14              | 18858.72  | 1571.56  | 1571.56  | 1571.56  | 1571.56  | 1571.56  | 1571.56  | 1571.56  | 1571.56  | 1571.56  | 1571.56  | 1571.56  | 1571.56  |  
    | [ContractNo]   | [AllocRef_SB]      | 22              | 301098.72 | 25091.56 | 25091.56 | 25091.56 | 25091.56 | 25091.56 | 25091.56 | 25091.56 | 25091.56 | 25091.56 | 25091.56 | 25091.56 | 25091.56 |  
    | [ContractNo]   | [AllocRef_SB]      | 31              | 498787.8  | 41565.65 | 41565.65 | 41565.65 | 41565.65 | 41565.65 | 41565.65 | 41565.65 | 41565.65 | 41565.65 | 41565.65 | 41565.65 | 41565.65 |  
    | [ContractNo]   | [AllocRef_SB]      | 72              | 122065.68 | 10172.14 | 10172.14 | 10172.14 | 10172.14 | 10172.14 | 10172.14 | 10172.14 | 10172.14 | 10172.14 | 10172.14 | 10172.14 | 10172.14 |  
    | [ContractNo]   | [AllocRef_SB]      | 94              | 70636.8   | 5886.40  | 5886.40  | 5886.40  | 5886.40  | 5886.40  | 5886.40  | 5886.40  | 5886.40  | 5886.40  | 5886.40  | 5886.40  | 5886.40  |  
    | [ContractNo]   | [AllocRef_SB]      | 129             | 458813.16 | 38234.43 | 38234.43 | 38234.43 | 38234.43 | 38234.43 | 38234.43 | 38234.43 | 38234.43 | 38234.43 | 38234.43 | 38234.43 | 38234.43 |  
    | [ContractNo]   | [AllocRef_SB]      | 196             | 222480    |18540.00  | 18540.00 | 18540.00 | 18540.00 | 18540.00 | 18540.00 | 18540.00 | 18540.00 | 18540.00 | 18540.00 | 18540.00 | 18540.00 |  
    | [ContractNo]   | [AllocRef_SB]      | 212             | 66034.8   | 5502.90  | 5502.90  | 5502.90  | 5502.90  | 5502.90  | 5502.90  | 5502.90  | 5502.90  | 5502.90  | 5502.90  | 5502.90  | 5502.90  |  
    | [ContractNo]   | [AllocRef_SB]      | 237             | 158301    | 13191.75 | 13191.75 | 13191.75 | 13191.75 | 13191.75 | 13191.75 | 13191.75 | 13191.75 | 13191.75 | 13191.75 | 13191.75 | 13191.75 |  
    | [ContractNo]   | [AllocRef_SBA]     | 18              | 34567.00  | 34567.00 | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |  
    | [ContractNo]   | [AllocRef_SBA]     | 19              | 2356.00   |  2356.00 |0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     | 0.00     |  

    # Check the PLANNED VOLUMES in CRM on the latest approved contract
    And   the Planned Volumes are calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-24   | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   | Apr-25   | May-25   | Jun-25   | Jul-25   | 
    | [ContractNo]   | [AllocRef_SB]      | 1               | 984       | 26       | 26       | 26       | 106      | 26       | 86       | 26       | 26       | 26       | 26       | 26       | 26      | 
    | [ContractNo]   | [AllocRef_SB]      | 3               | 878       | 55       | 55       | 55       | 81       | 55       | 116      | 55       | 55       | 55       | 55       | 55       | 55      | 
    | [ContractNo]   | [AllocRef_SB]      | 6               | 1031      | 125      | 125      | 125      | 55       | 125      | 35       | 125      | 125      | 125      | 125      | 125      | 125      | 
    | [ContractNo]   | [AllocRef_SB]      | 14              | 1036      | 4        | 4        | 4        | 29       | 4        |  64      | 4        | 4        | 4        | 4        | 4        | 4      | 
    | [ContractNo]   | [AllocRef_SB]      | 22              | 1078      | 73       | 73       | 73       | 4        | 73       | 94       | 73       | 73       | 73       | 73       | 73       | 73      | 
    | [ContractNo]   | [AllocRef_SB]      | 31              | 932       | 103      | 103      | 103      | 128      | 103      | 13       | 103      | 103      | 103      | 103      | 103      | 103      | 
    | [ContractNo]   | [AllocRef_SB]      | 72              | 937       | 22       | 22       | 22       | 102      | 22       | 43       | 22       | 22       | 22       | 22       | 22       | 22      | 
    | [ContractNo]   | [AllocRef_SB]      | 94              | 1060      | 52       | 52       | 52       | 77       | 52       | 112      | 52       | 52       | 52       | 52       | 52       | 52      | 
    | [ContractNo]   | [AllocRef_SB]      | 129             | 982       | 81       | 81       | 81       | 51       | 81       | 141      | 81       | 81       | 81       | 81       | 81       | 81      | 
    | [ContractNo]   | [AllocRef_SB]      | 196             | 1027      | 150      | 150      | 150      | 25       | 150      | 61       | 150      | 150      | 150      | 150      | 150      | 150      | 
    | [ContractNo]   | [AllocRef_SB]      | 212             | 1032      | 30       | 30       | 30       | 150      | 30       | 90       | 30       | 30       | 30       | 30       | 30       | 30      | 
    | [ContractNo]   | [AllocRef_SB]      | 237             | 736       | 99       | 99       | 99       | 84       | 99       | 9        | 99       | 99       | 99       | 99       | 99       | 99      | 
    | [ContractNo]   | [AllocRef_SBA]     | 18              | 180       | 0        | 0        | 0        | 0        | 0        |  0       | 0        | 0        | 0        | 0        | 0        | 0       | 
    | [ContractNo]   | [AllocRef_SBA]     | 19              | 120       | 0        |0         | 0        | 0        | 0        | 0        |  0       | 0        | 0        | 0        | 0        | 0        |




    
    # The following step won't work until we are full updated to schema v 11.05

    # Test CRM details against same in ContractManagement feed (30447)
    And   the details in CRM for version '2' of contract '[ContractNo]' agree with the most recent entry for this contract in the ContractManagement feed




   Given the following document creation details exist in the ContractManagement.CreatedContract table
   | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
   | [ContractNo]   | 2                     | 0                        | 2025-05-28 09:12:35.000 |

         # Add actuals to the contract for SB2022(PoA) 

 # Change the date
 Given the override date is '04/05/2025'

 # Delete the MonitoringDeliverables.HeldReportedActualGroup data for the OrgId
 And   there are no rows on HeldReportedActualGroup for OrgId 'ORG0010038'

 # Clear down the stub
 And   there are no entries in the DCFS stub table

 # Month end is not running
 And   the PaaS MonthEndIsRunning indicator is set to 'False'

 # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals
 And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

 # Pull actuals from DC for Oct 2022
 And   the following closed collections are available in DCFS 
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode    | DeliverableCode | ActualVolume | ActualValue |
    | SB        | SB02                  | ORG0010038     | CM             | 202504 | SB2022              | [AllocRef_SB]           | W3L1       | 1              | 0            | 547.00      |
    | SB        | SB02                  | ORG0010038     | CM             | 202504 | SB2022              | [AllocRef_SB]           | W3L1       | 3              | 0            | 552.00      |
    | SB        | SB02                  | ORG0010038     | CM             | 202504 | SB2022              | [AllocRef_SB]           | W3L1       | 6              | 0            | 652.00      |
    | SB        | SB02                  | ORG0010038     | CM             | 202504 | SB2022              | [AllocRef_SB]           | W3L1       | 14             | 0            | 752.00      |
    | SB        | SB02                  | ORG0010038     | CM             | 202504 | SB2022              | [AllocRef_SB]           | W3L1       | 22             | 0            | 852.00      |
    | SB        | SB02                  | ORG0010038     | CM             | 202504 | SB2022              | [AllocRef_SB]           | W3L1       | 31             | 0            | 952.00      |
    | SB        | SB02                  | ORG0010038     | CM             | 202504 | SB2022              | [AllocRef_SB]           | W3L1       | 72             | 0            | 1052.00     |
    | SB        | SB02                  | ORG0010038     | CM             | 202504 | SB2022              | [AllocRef_SB]           | W3L1       | 94             | 0            | 1152.00     |
    | SB        | SB02                  | ORG0010038     | CM             | 202504 | SB2022              | [AllocRef_SB]           | W3L1       | 129            | 0            | 1252.00     |
    | SB        | SB02                  | ORG0010038     | CM             | 202504 | SB2022              | [AllocRef_SB]           | W3L1       | 196            | 0            | 1352.00     |
    | SB        | SB02                  | ORG0010038     | CM             | 202504 | SB2022              | [AllocRef_SB]           | W3L1       | 212            | 0            | 1452.00     |
    | SB        | SB02                  | ORG0010038     | CM             | 202504 | SB2022              | [AllocRef_SB]           | W3L1       | 237            | 0            | 1552.00     |
    | SB        | SB02                  | ORG0010038     | CM             | 202504 | SB2022              | [AllocRef_SBA]          | W3L6       | 18             | 0            | 1000.00     |
    | SB        | SB02                  | ORG0010038     | CM             | 202504 | SB2022              | [AllocRef_SBA]          | W3L6       | 19             | 0            | 2000.00     |
    #
#    | SB        | SB02                  | ORG0010038     | CM             | 202505 | SB2022              | [AllocRef_SB]           | W3L1       | 1              | 0            | 547.00      |
#    | SB        | SB02                  | ORG0010038     | CM             | 202505 | SB2022              | [AllocRef_SB]           | W3L1       | 3              | 0            | 552.00      |
#    | SB        | SB02                  | ORG0010038     | CM             | 202505 | SB2022              | [AllocRef_SB]           | W3L1       | 6              | 0            | 652.00      |
#    | SB        | SB02                  | ORG0010038     | CM             | 202505 | SB2022              | [AllocRef_SB]           | W3L1       | 14             | 0            | 752.00      |
#    | SB        | SB02                  | ORG0010038     | CM             | 202505 | SB2022              | [AllocRef_SB]           | W3L1       | 22             | 0            | 852.00      |
#    | SB        | SB02                  | ORG0010038     | CM             | 202505 | SB2022              | [AllocRef_SB]           | W3L1       | 31             | 0            | 952.00      |
#    | SB        | SB02                  | ORG0010038     | CM             | 202505 | SB2022              | [AllocRef_SB]           | W3L1       | 72             | 0            | 1052.00     |
#    | SB        | SB02                  | ORG0010038     | CM             | 202505 | SB2022              | [AllocRef_SB]           | W3L1       | 94             | 0            | 1152.00     |
#    | SB        | SB02                  | ORG0010038     | CM             | 202505 | SB2022              | [AllocRef_SB]           | W3L1       | 129            | 0            | 1252.00     |
#    | SB        | SB02                  | ORG0010038     | CM             | 202505 | SB2022              | [AllocRef_SB]           | W3L1       | 196            | 0            | 1352.00     |
#    | SB        | SB02                  | ORG0010038     | CM             | 202505 | SB2022              | [AllocRef_SB]           | W3L1       | 212            | 0            | 1452.00     |
#    | SB        | SB02                  | ORG0010038     | CM             | 202505 | SB2022              | [AllocRef_SB]           | W3L1       | 237            | 0            | 1552.00     |
##
#    | SB        | SB02                  | ORG0010038     | CM             | 202506 | SB2022              | [AllocRef_SB]           | W3L1       | 1              | 0            | 547.00      |
#    | SB        | SB02                  | ORG0010038     | CM             | 202506 | SB2022              | [AllocRef_SB]           | W3L1       | 3              | 0            | 552.00      |
#    | SB        | SB02                  | ORG0010038     | CM             | 202506 | SB2022              | [AllocRef_SB]           | W3L1       | 6              | 0            | 652.00      |
#    | SB        | SB02                  | ORG0010038     | CM             | 202506 | SB2022              | [AllocRef_SB]           | W3L1       | 14             | 0            | 752.00      |
#    | SB        | SB02                  | ORG0010038     | CM             | 202506 | SB2022              | [AllocRef_SB]           | W3L1       | 22             | 0            | 852.00      |
#    | SB        | SB02                  | ORG0010038     | CM             | 202506 | SB2022              | [AllocRef_SB]           | W3L1       | 31             | 0            | 952.00      |
#    | SB        | SB02                  | ORG0010038     | CM             | 202506 | SB2022              | [AllocRef_SB]           | W3L1       | 72             | 0            | 1052.00     |
#    | SB        | SB02                  | ORG0010038     | CM             | 202506 | SB2022              | [AllocRef_SB]           | W3L1       | 94             | 0            | 1152.00     |
#    | SB        | SB02                  | ORG0010038     | CM             | 202506 | SB2022              | [AllocRef_SB]           | W3L1       | 129            | 0            | 1252.00     |
#    | SB        | SB02                  | ORG0010038     | CM             | 202506 | SB2022              | [AllocRef_SB]           | W3L1       | 196            | 0            | 1352.00     |
#    | SB        | SB02                  | ORG0010038     | CM             | 202506 | SB2022              | [AllocRef_SB]           | W3L1       | 212            | 0            | 1452.00     |
#    | SB        | SB02                  | ORG0010038     | CM             | 202506 | SB2022              | [AllocRef_SB]           | W3L1       | 237            | 0            | 1552.00     |
##
#    | SB        | SB02                  | ORG0010038     | CM             | 202507 | SB2022              | [AllocRef_SB]           | W3L1       | 1              | 0            | 547.00      |
#    | SB        | SB02                  | ORG0010038     | CM             | 202507 | SB2022              | [AllocRef_SB]           | W3L1       | 3              | 0            | 552.00      |
#    | SB        | SB02                  | ORG0010038     | CM             | 202507 | SB2022              | [AllocRef_SB]           | W3L1       | 6              | 0            | 652.00      |
#    | SB        | SB02                  | ORG0010038     | CM             | 202507 | SB2022              | [AllocRef_SB]           | W3L1       | 14             | 0            | 752.00      |
#    | SB        | SB02                  | ORG0010038     | CM             | 202507 | SB2022              | [AllocRef_SB]           | W3L1       | 22             | 0            | 852.00      |
#    | SB        | SB02                  | ORG0010038     | CM             | 202507 | SB2022              | [AllocRef_SB]           | W3L1       | 31             | 0            | 952.00      |
#    | SB        | SB02                  | ORG0010038     | CM             | 202507 | SB2022              | [AllocRef_SB]           | W3L1       | 72             | 0            | 1052.00     |
#    | SB        | SB02                  | ORG0010038     | CM             | 202507 | SB2022              | [AllocRef_SB]           | W3L1       | 94             | 0            | 1152.00     |
#    | SB        | SB02                  | ORG0010038     | CM             | 202507 | SB2022              | [AllocRef_SB]           | W3L1       | 129            | 0            | 1252.00     |
#    | SB        | SB02                  | ORG0010038     | CM             | 202507 | SB2022              | [AllocRef_SB]           | W3L1       | 196            | 0            | 1352.00     |
#    | SB        | SB02                  | ORG0010038     | CM             | 202507 | SB2022              | [AllocRef_SB]           | W3L1       | 212            | 0            | 1452.00     |
#    | SB        | SB02                  | ORG0010038     | CM             | 202507 | SB2022              | [AllocRef_SB]           | W3L1       | 237            | 0            | 1552.00     |


 # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
#When  the FCT system polls the DCFS DEDS service
 When  the FCT system polls the SLD service
 
 Then wait '30' seconds

  # Check the ACTUAL VALUES in CRM on the latest approved contract
 Then  the Actuals Value Data is as follows
 | ContractNumber | AllocationRef      | DeliverableCode | Total     | Aug-24  | Sep-24   | Oct-24   | Nov-24   | Dec-24   | Jan-25   | Feb-25   | Mar-25   | Apr-25   | May-25   | Jun-25   | Jul-25   | 
 | [ContractNo]   | [AllocRef_SB]      | 1               | 547.00    | ?       | ?        | ?        | ?        | ?        | ?        | ?        | ?        |547.00    |?         |?         |?         |  
 | [ContractNo]   | [AllocRef_SB]      | 3               | 552.00    | ?       | ?        | ?        | ?        | ?        | ?        | ?        | ?        |552.00    |?         |?         |?         |  
 | [ContractNo]   | [AllocRef_SB]      | 6               | 652.00    | ?       | ?        | ?        | ?        | ?        | ?        | ?        | ?        |652.00    |?         |?         |?         |  
 | [ContractNo]   | [AllocRef_SB]      | 14              | 752.00    | ?       | ?        | ?        | ?        | ?        | ?        | ?        | ?        |752.00    |?         |?         |?         |  
 | [ContractNo]   | [AllocRef_SB]      | 22              | 852.00    | ?       | ?        | ?        | ?        | ?        | ?        | ?        | ?        |852.00    |?         |?         |?         |  
 | [ContractNo]   | [AllocRef_SB]      | 31              | 952.00    | ?       | ?        | ?        | ?        | ?        | ?        | ?        | ?        |952.00    |?         |?         |?         |  
 | [ContractNo]   | [AllocRef_SB]      | 72              | 1052.00   | ?       | ?        | ?        | ?        | ?        | ?        | ?        | ?        |1052.00   |?         |?         |?         |  
 | [ContractNo]   | [AllocRef_SB]      | 94              | 1152.00   | ?       | ?        | ?        | ?        | ?        | ?        | ?        | ?        |1152.00   |?         |?         |?         |  
 | [ContractNo]   | [AllocRef_SB]      | 129             | 1252.00   | ?       | ?        | ?        | ?        | ?        | ?        | ?        | ?        |1252.00   |?         |?         |?         |  
 | [ContractNo]   | [AllocRef_SB]      | 196             | 1352.00   | ?       | ?        | ?        | ?        | ?        | ?        | ?        | ?        |1352.00   |?         |?         |?         |  
 | [ContractNo]   | [AllocRef_SB]      | 212             | 1452.00   | ?       | ?        | ?        | ?        | ?        | ?        | ?        | ?        |1452.00   |?         |?         |?         |  
 | [ContractNo]   | [AllocRef_SB]      | 237             | 1552.00  | ?       | ?        | ?        | ?        | ?        | ?        | ?        | ?         |1552.00   |?         |?         |?         |  
 | [ContractNo]   | [AllocRef_SBA]     | 18              | 1000.00  | ?       | ?        | ?        | ?        | ?        | ?        | ?        | ?         |1000.00   |?         |?         |?         |  
 | [ContractNo]   | [AllocRef_SBA]     | 19              | 2000.00  | ?       | ?        | ?        | ?        | ?        | ?        | ?        | ?         |2000.00   |?         |?         |?         |  


 # Payment Batch for SB2023(PoA)

   # Change the date
   Given the override date is '09/05/2025 22:05'

   # Month end is not running
   And   the PaaS MonthEndIsRunning indicator is set to 'False'

   # Delete a specific row from the PaymentGeneration.PaymentBatchFeedItem (19014)
   And   there is no data in the Payment feed for FundingStreamPeriod 'SB2022' AccountingPaymentPeriod '202501' CensusEndDate '09/05/2025' and LinkCodeSuffix 'A'

   # This bit checks that there is something in PaymentGeneration.SubnominalAggregation. In essence, a 'wait' before proceeding with the batch
   And   the following allocation periods are present in the subnominal aggregation PaaS table
   | ContractAllocationNumber | Period |
   | [AllocRef_SB]            | 202504 |
   | [AllocRef_SBA]            | 202504 |

   # PaymentGeneration.PaymentTimetable (This steps starts off by setting everything to 'DoNotRun')
   And   the following configuration exists in the Payment Timetable
   | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | LinkCodeSuffix | Status     |
   | SB2022               		 | 202504               |                      | A              | NotStarted |

   When  the Payment Generation Batch run is started

   # PaymentGeneration.PaymentTimetable
   Then  there is an entry in the Payment Timetable
   | Funding Stream Period Code | Calendar Year/Period | Status    |
   | SB2022                 	 | 202504               | Completed |

   # Decrypt the targetted PaymentGeneration.PaymentBatchFeedItem data to the Datafiles/Downloads folder (19014)
   And   the Payment feed xml for FundingStreamPeriod 'SB2022' PaymentPeriod '202501' CensusEndDate '09/05/2025' and LinkCodeSuffix 'A' is decrypted and saved to 'DataFiles/Downloads' as 'Ak038.xml'


   Given there are no files prefixed '2024-05 Payments.xlsx' in the Sharepoint 'Consolidated Payment Summary' folder
  When  a Consolidated Payment Summary Report is created in Sharepoint for '10/05/2025'
   # Check the above report manually




    # Run the CDA report for the four 2021 AEBP FSPs
    Given the override date is '11/05/2025'
    Given there is no CDA report named 'CDA Latest Version AK038.csv'
    And   the following ADF Pipeline run
    And   the following CDA report is run
    | FundingStreamPeriod   | Version         | Suffix |
    | SB2022                | Latest Version  | AK038   |
 
    Then  a report named 'CDA Latest Version AK038.csv' is created