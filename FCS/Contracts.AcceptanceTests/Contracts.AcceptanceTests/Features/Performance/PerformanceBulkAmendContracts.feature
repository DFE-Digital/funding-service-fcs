Feature: PerformanceBulkAmendContracts
   Load files with lots of update Data

#5000 new contracts and 5000 Amemendments to new contracts should be uploaded in 15 hours 
#100 contracts to be processed in 540 seconds

#@PerformanceDaily
#@PerformanceWeekly
#@ReportPerformance
Scenario: P005a Feature_BulkLoad_Amendments_Test_Load 10 Amend contracts in CRM in 54 seconds
    Given The file 'MAIN AY 1516 02062015130000 BulkAmendPerformance.xlsx' exists at 'DataFiles\Performance' with the following UKPRNs
    | UKPRN    |
    | 50032000 |
    | 50032001 |
    | 50032002 |
    | 50032003 |
    | 50032004 |
    | 50032005 |
    | 50032006 |
    | 50032007 |
    | 50032008 |
    | 50032009 |

    And CRM has an 'active' organisation for each UKPRN 
    And the contract data is now removed for ukprn beginning with '500320'

    And the following data exists in the CRM Contract table
    | Contract No | Version | Provider | UKPRN    | Funding Type | Contract Status | Sub Status | Contract Value | Start Date | End Date   | Contract Owner | Contract Type         | Description | Hierarchy Type | Last Approved Version | Latest Version | Parent Contract | Period | Sub Version | Task Owner |
    | MAMD-7000   | 1       | NACRO    | 50032000 | Mainstream   | Approved        | Approved   | 1200           | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Master         | Yes                   | Yes            |                 |        | 0           | FCS2 Test |
    | AMD-7000    | 1       | NACRO    | 50032000 | Mainstream   | Approved        | Approved   | 1200           | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Contract       | Yes                   | Yes            | MAMD-7000       |        | 0           | FCS2 Test |
    | MAMD-7001   | 1       | NACRO    | 50032001 | Mainstream   | Approved        | Approved	| 2400           | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Master         | Yes                   | Yes            |                 |        | 0           | FCS2 Test |
    | AMD-7001    | 1       | NACRO    | 50032001 | Mainstream   | Approved        | Approved	| 2400           | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Contract       | Yes                   | Yes            | MAMD-7001       |        | 0           | FCS2 Test |
    | MAMD-7002   | 1       | NACRO    | 50032002 | Mainstream   | Approved        | Approved   | 1200           | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Master         | Yes                   | Yes            |                 |        | 0           | FCS2 Test |
    | AMD-7002    | 1       | NACRO    | 50032002 | Mainstream   | Approved        | Approved   | 1200           | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Contract       | Yes                   | Yes            | MAMD-7002       |        | 0           | FCS2 Test |
    | MAMD-7003   | 1       | NACRO    | 50032003 | Mainstream   | Approved        | Approved	| 2400           | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Master         | Yes                   | Yes            |                 |        | 0           | FCS2 Test |
    | AMD-7003    | 1       | NACRO    | 50032003 | Mainstream   | Approved        | Approved	| 2400           | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Contract       | Yes                   | Yes            | MAMD-7003       |        | 0           | FCS2 Test |
    | MAMD-7004   | 1       | NACRO    | 50032004 | Mainstream   | Approved        | Approved   | 1200           | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Master         | Yes                   | Yes            |                 |        | 0           | FCS2 Test |
    | AMD-7004    | 1       | NACRO    | 50032004 | Mainstream   | Approved        | Approved   | 1200           | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Contract       | Yes                   | Yes            | MAMD-7004       |        | 0           | FCS2 Test |
    | MAMD-7005   | 1       | NACRO    | 50032005 | Mainstream   | Approved        | Approved	| 2400           | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Master         | Yes                   | Yes            |                 |        | 0           | FCS2 Test |
    | AMD-7005    | 1       | NACRO    | 50032005 | Mainstream   | Approved        | Approved   | 2400           | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Contract       | Yes                   | Yes            | MAMD-7005       |        | 0           | FCS2 Test |
    | MAMD-7006   | 1       | NACRO    | 50032006 | Mainstream   | Approved        | Approved   | 1200           | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Master         | Yes                   | Yes            |                 |        | 0           | FCS2 Test |
    | AMD-7006    | 1       | NACRO    | 50032006 | Mainstream   | Approved        | Approved   | 1200           | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Contract       | Yes                   | Yes            | MAMD-7006       |        | 0           | FCS2 Test |
    | MAMD-7007   | 1       | NACRO    | 50032007 | Mainstream   | Approved        | Approved	| 2400           | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Master         | Yes                   | Yes            |                 |        | 0           | FCS2 Test |
    | AMD-7007    | 1       | NACRO    | 50032007 | Mainstream   | Approved        | Approved   | 2400           | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Contract       | Yes                   | Yes            | MAMD-7007       |        | 0           | FCS2 Test |
    | MAMD-7008   | 1       | NACRO    | 50032008 | Mainstream   | Approved        | Approved   | 1200           | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Master         | Yes                   | Yes            |                 |        | 0           | FCS2 Test |
    | AMD-7008    | 1       | NACRO    | 50032008 | Mainstream   | Approved        | Approved   | 1200           | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Contract       | Yes                   | Yes            | MAMD-7008       |        | 0           | FCS2 Test |
    | MAMD-7009   | 1       | NACRO    | 50032009 | Mainstream   | Approved        | Approved	| 2400           | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Master         | Yes                   | Yes            |                 |        | 0           | FCS2 Test |
    | AMD-7009    | 1       | NACRO    | 50032009 | Mainstream   | Approved        | Approved	| 2400           | 01/08/2015 | 31/07/2016 | FCS2 Test     | Contract for Services | Desc1       | Contract       | Yes                   | Yes            | MAMD-7009       |        | 0           | FCS2 Test |

    And the following data exists in the CRM Allocations table
    | Contract Allocation Ref | Allocation Status | Contract | Contract Allocation Value (£) | Start Date | End Date   | Funding Stream | Funding Stream Period | Hierarchy type      | Period |
    | ALLO-AMD00              | Approved          | AMD-7000 | 1200                          | 01/08/2015 | 31/07/2016 | 16-18 APPS     | 16-18APPS1516         | Contract Allocation | AY1516 |
    | ALLO-AMD01              | Approved          | AMD-7001 | 2400                          | 01/08/2015 | 31/07/2016 | 16-18 APPS     | 16-18APPS1516         | Contract Allocation | AY1516 |
    | ALLO-AMD02              | Approved          | AMD-7002 | 1200                          | 01/08/2015 | 31/07/2016 | 16-18 APPS     | 16-18APPS1516         | Contract Allocation | AY1516 |
    | ALLO-AMD03              | Approved          | AMD-7003 | 2400                          | 01/08/2015 | 31/07/2016 | 16-18 APPS     | 16-18APPS1516         | Contract Allocation | AY1516 |
    | ALLO-AMD04              | Approved          | AMD-7004 | 1200                          | 01/08/2015 | 31/07/2016 | 16-18 APPS     | 16-18APPS1516         | Contract Allocation | AY1516 |
    | ALLO-AMD05              | Approved          | AMD-7005 | 2400                          | 01/08/2015 | 31/07/2016 | 16-18 APPS     | 16-18APPS1516         | Contract Allocation | AY1516 |
    | ALLO-AMD06              | Approved          | AMD-7006 | 1200                          | 01/08/2015 | 31/07/2016 | 16-18 APPS     | 16-18APPS1516         | Contract Allocation | AY1516 |
    | ALLO-AMD07              | Approved          | AMD-7007 | 2400                          | 01/08/2015 | 31/07/2016 | 16-18 APPS     | 16-18APPS1516         | Contract Allocation | AY1516 |
    | ALLO-AMD08              | Approved          | AMD-7008 | 1200                          | 01/08/2015 | 31/07/2016 | 16-18 APPS     | 16-18APPS1516         | Contract Allocation | AY1516 |
    | ALLO-AMD09              | Approved          | AMD-7009 | 2400                          | 01/08/2015 | 31/07/2016 | 16-18 APPS     | 16-18APPS1516         | Contract Allocation | AY1516 |

    And the following data exists in the CRM Deliverable table
    | Deliverable                          | Contract | Contract Allocation | Deliverable Code | Funding Stream Period Deliverable    | Owner      | Planned Value (£) | Planned Volume | Actual Value (£) | Actual Volume |
    | 16-18 Apprenticeships Total Funding  | AMD-7000 | ALLO-AMD00          | 2                | 16-18 Apprenticeships Total Funding  | FCS2 Test | 1200              | <Blank>        | <Blank>          | <Blank>       |
    | 16-18 Apprenticeships Total Funding  | AMD-7001 | ALLO-AMD01          | 2                | 16-18 Apprenticeships Total Funding  | FCS2 Test | 2400              | <Blank>        | <Blank>          | <Blank>       |
    | 16-18 Apprenticeships Total Funding  | AMD-7002 | ALLO-AMD02          | 2                | 16-18 Apprenticeships Total Funding  | FCS2 Test | 1200              | <Blank>        | <Blank>          | <Blank>       |
    | 16-18 Apprenticeships Total Funding  | AMD-7003 | ALLO-AMD03          | 2                | 16-18 Apprenticeships Total Funding  | FCS2 Test | 2400              | <Blank>        | <Blank>          | <Blank>       |
    | 16-18 Apprenticeships Total Funding  | AMD-7004 | ALLO-AMD04          | 2                | 16-18 Apprenticeships Total Funding  | FCS2 Test | 1200              | <Blank>        | <Blank>          | <Blank>       |
    | 16-18 Apprenticeships Total Funding  | AMD-7005 | ALLO-AMD05          | 2                | 16-18 Apprenticeships Total Funding  | FCS2 Test | 2400              | <Blank>        | <Blank>          | <Blank>       |
    | 16-18 Apprenticeships Total Funding  | AMD-7006 | ALLO-AMD06          | 2                | 16-18 Apprenticeships Total Funding  | FCS2 Test | 1200              | <Blank>        | <Blank>          | <Blank>       |
    | 16-18 Apprenticeships Total Funding  | AMD-7007 | ALLO-AMD07          | 2                | 16-18 Apprenticeships Total Funding  | FCS2 Test | 2400              | <Blank>        | <Blank>          | <Blank>       |
    | 16-18 Apprenticeships Total Funding  | AMD-7008 | ALLO-AMD08          | 2                | 16-18 Apprenticeships Total Funding  | FCS2 Test | 1200              | <Blank>        | <Blank>          | <Blank>       |
    | 16-18 Apprenticeships Total Funding  | AMD-7009 | ALLO-AMD09          | 2                | 16-18 Apprenticeships Total Funding  | FCS2 Test | 2400              | <Blank>        | <Blank>          | <Blank>       |

    And the following data exists in the CRM Deliverable Period table
    | Deliverable                          | Contract Allocation | Period | Planned Value | Planned Volume | Display Order | Period Type | Period Number | Year |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD00          | Aug-15 | 100           |                | 201508        | CM          | 8             | 2015 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD00          | Sep-15 | 100           |                | 201509        | CM          | 9             | 2015 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD00          | Oct-15 | 100           |                | 201510        | CM          | 10            | 2015 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD00          | Nov-15 | 100           |                | 201511        | CM          | 11            | 2015 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD00          | Dec-15 | 100           |                | 201512        | CM          | 12            | 2015 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD00          | Jan-16 | 100           |                | 201601        | CM          | 1             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD00          | Feb-16 | 100           |                | 201602        | CM          | 2             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD00          | Mar-16 | 100           |                | 201603        | CM          | 3             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD00          | Apr-16 | 100           |                | 201604        | CM          | 4             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD00          | May-16 | 100           |                | 201605        | CM          | 5             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD00          | Jun-16 | 100           |                | 201606        | CM          | 6             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD00          | Jul-16 | 100           |                | 201607        | CM          | 7             | 2016 |

    And the following data exists in the CRM Deliverable Period table
    | Deliverable                          | Contract Allocation | Period | Planned Value | Planned Volume | Display Order | Period Type | Period Number | Year |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD01          | Aug-15 | 200           |                | 201508        | CM          | 8             | 2015 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD01          | Sep-15 | 200           |                | 201509        | CM          | 9             | 2015 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD01          | Oct-15 | 200           |                | 201510        | CM          | 10            | 2015 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD01          | Nov-15 | 200           |                | 201511        | CM          | 11            | 2015 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD01          | Dec-15 | 200           |                | 201512        | CM          | 12            | 2015 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD01          | Jan-16 | 200           |                | 201601        | CM          | 1             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD01          | Feb-16 | 200           |                | 201602        | CM          | 2             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD01          | Mar-16 | 200           |                | 201603        | CM          | 3             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD01          | Apr-16 | 200           |                | 201604        | CM          | 4             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD01          | May-16 | 200           |                | 201605        | CM          | 5             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD01          | Jun-16 | 200           |                | 201606        | CM          | 6             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD01          | Jul-16 | 200           |                | 201607        | CM          | 7             | 2016 |

    And the following data exists in the CRM Deliverable Period table
    | Deliverable                          | Contract Allocation | Period | Planned Value | Planned Volume | Display Order | Period Type | Period Number | Year |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD02          | Aug-15 | 100           |                | 201508        | CM          | 8             | 2015 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD02          | Sep-15 | 100           |                | 201509        | CM          | 9             | 2015 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD02          | Oct-15 | 100           |                | 201510        | CM          | 10            | 2015 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD02          | Nov-15 | 100           |                | 201511        | CM          | 11            | 2015 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD02          | Dec-15 | 100           |                | 201512        | CM          | 12            | 2015 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD02          | Jan-16 | 100           |                | 201601        | CM          | 1             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD02          | Feb-16 | 100           |                | 201602        | CM          | 2             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD02          | Mar-16 | 100           |                | 201603        | CM          | 3             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD02          | Apr-16 | 100           |                | 201604        | CM          | 4             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD02          | May-16 | 100           |                | 201605        | CM          | 5             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD02          | Jun-16 | 100           |                | 201606        | CM          | 6             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD02          | Jul-16 | 100           |                | 201607        | CM          | 7             | 2016 |

    And the following data exists in the CRM Deliverable Period table
    | Deliverable                          | Contract Allocation | Period | Planned Value | Planned Volume | Display Order | Period Type | Period Number | Year |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD03          | Aug-15 | 200           |                | 201508        | CM          | 8             | 2015 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD03          | Sep-15 | 200           |                | 201509        | CM          | 9             | 2015 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD03          | Oct-15 | 200           |                | 201510        | CM          | 10            | 2015 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD03          | Nov-15 | 200           |                | 201511        | CM          | 11            | 2015 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD03          | Dec-15 | 200           |                | 201512        | CM          | 12            | 2015 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD03          | Jan-16 | 200           |                | 201601        | CM          | 1             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD03          | Feb-16 | 200           |                | 201602        | CM          | 2             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD03          | Mar-16 | 200           |                | 201603        | CM          | 3             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD03          | Apr-16 | 200           |                | 201604        | CM          | 4             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD03          | May-16 | 200           |                | 201605        | CM          | 5             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD03          | Jun-16 | 200           |                | 201606        | CM          | 6             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD03          | Jul-16 | 200           |                | 201607        | CM          | 7             | 2016 |

    And the following data exists in the CRM Deliverable Period table
    | Deliverable                          | Contract Allocation | Period | Planned Value | Planned Volume | Display Order | Period Type | Period Number | Year |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD04          | Aug-15 | 100           |                | 201508        | CM          | 8             | 2015 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD04          | Sep-15 | 100           |                | 201509        | CM          | 9             | 2015 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD04          | Oct-15 | 100           |                | 201510        | CM          | 10            | 2015 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD04          | Nov-15 | 100           |                | 201511        | CM          | 11            | 2015 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD04          | Dec-15 | 100           |                | 201512        | CM          | 12            | 2015 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD04          | Jan-16 | 100           |                | 201601        | CM          | 1             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD04          | Feb-16 | 100           |                | 201602        | CM          | 2             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD04          | Mar-16 | 100           |                | 201603        | CM          | 3             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD04          | Apr-16 | 100           |                | 201604        | CM          | 4             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD04          | May-16 | 100           |                | 201605        | CM          | 5             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD04          | Jun-16 | 100           |                | 201606        | CM          | 6             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD04          | Jul-16 | 100           |                | 201607        | CM          | 7             | 2016 |
   
    And the following data exists in the CRM Deliverable Period table
    | Deliverable                          | Contract Allocation | Period | Planned Value | Planned Volume | Display Order | Period Type | Period Number | Year |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD05          | Aug-15 | 200           |                | 201508        | CM          | 8             | 2015 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD05          | Sep-15 | 200           |                | 201509        | CM          | 9             | 2015 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD05          | Oct-15 | 200           |                | 201510        | CM          | 10            | 2015 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD05          | Nov-15 | 200           |                | 201511        | CM          | 11            | 2015 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD05          | Dec-15 | 200           |                | 201512        | CM          | 12            | 2015 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD05          | Jan-16 | 200           |                | 201601        | CM          | 1             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD05          | Feb-16 | 200           |                | 201602        | CM          | 2             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD05          | Mar-16 | 200           |                | 201603        | CM          | 3             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD05          | Apr-16 | 200           |                | 201604        | CM          | 4             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD05          | May-16 | 200           |                | 201605        | CM          | 5             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD05          | Jun-16 | 200           |                | 201606        | CM          | 6             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD05          | Jul-16 | 200           |                | 201607        | CM          | 7             | 2016 |

    And the following data exists in the CRM Deliverable Period table
    | Deliverable                          | Contract Allocation | Period | Planned Value | Planned Volume | Display Order | Period Type | Period Number | Year |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD06          | Aug-15 | 100           |                | 201508        | CM          | 8             | 2015 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD06          | Sep-15 | 100           |                | 201509        | CM          | 9             | 2015 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD06          | Oct-15 | 100           |                | 201510        | CM          | 10            | 2015 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD06          | Nov-15 | 100           |                | 201511        | CM          | 11            | 2015 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD06          | Dec-15 | 100           |                | 201512        | CM          | 12            | 2015 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD06          | Jan-16 | 100           |                | 201601        | CM          | 1             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD06          | Feb-16 | 100           |                | 201602        | CM          | 2             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD06          | Mar-16 | 100           |                | 201603        | CM          | 3             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD06          | Apr-16 | 100           |                | 201604        | CM          | 4             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD06          | May-16 | 100           |                | 201605        | CM          | 5             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD06          | Jun-16 | 100           |                | 201606        | CM          | 6             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD06          | Jul-16 | 100           |                | 201607        | CM          | 7             | 2016 |

    And the following data exists in the CRM Deliverable Period table
    | Deliverable                          | Contract Allocation | Period | Planned Value | Planned Volume | Display Order | Period Type | Period Number | Year |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD07          | Aug-15 | 200           |                | 201508        | CM          | 8             | 2015 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD07          | Sep-15 | 200           |                | 201509        | CM          | 9             | 2015 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD07          | Oct-15 | 200           |                | 201510        | CM          | 10            | 2015 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD07          | Nov-15 | 200           |                | 201511        | CM          | 11            | 2015 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD07          | Dec-15 | 200           |                | 201512        | CM          | 12            | 2015 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD07          | Jan-16 | 200           |                | 201601        | CM          | 1             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD07          | Feb-16 | 200           |                | 201602        | CM          | 2             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD07          | Mar-16 | 200           |                | 201603        | CM          | 3             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD07          | Apr-16 | 200           |                | 201604        | CM          | 4             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD07          | May-16 | 200           |                | 201605        | CM          | 5             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD07          | Jun-16 | 200           |                | 201606        | CM          | 6             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD07          | Jul-16 | 200           |                | 201607        | CM          | 7             | 2016 |

    And the following data exists in the CRM Deliverable Period table
    | Deliverable                          | Contract Allocation | Period | Planned Value | Planned Volume | Display Order | Period Type | Period Number | Year |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD08          | Aug-15 | 100           |                | 201508        | CM          | 8             | 2015 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD08          | Sep-15 | 100           |                | 201509        | CM          | 9             | 2015 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD08          | Oct-15 | 100           |                | 201510        | CM          | 10            | 2015 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD08          | Nov-15 | 100           |                | 201511        | CM          | 11            | 2015 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD08          | Dec-15 | 100           |                | 201512        | CM          | 12            | 2015 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD08          | Jan-16 | 100           |                | 201601        | CM          | 1             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD08          | Feb-16 | 100           |                | 201602        | CM          | 2             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD08          | Mar-16 | 100           |                | 201603        | CM          | 3             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD08          | Apr-16 | 100           |                | 201604        | CM          | 4             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD08          | May-16 | 100           |                | 201605        | CM          | 5             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD08          | Jun-16 | 100           |                | 201606        | CM          | 6             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD08          | Jul-16 | 100           |                | 201607        | CM          | 7             | 2016 |

    And  the following data exists in the CRM Deliverable Period table
    | Deliverable                          | Contract Allocation | Period | Planned Value | Planned Volume | Display Order | Period Type | Period Number | Year |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD09          | Aug-15 | 200           |                | 201508        | CM          | 8             | 2015 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD09          | Sep-15 | 200           |                | 201509        | CM          | 9             | 2015 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD09          | Oct-15 | 200           |                | 201510        | CM          | 10            | 2015 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD09          | Nov-15 | 200           |                | 201511        | CM          | 11            | 2015 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD09          | Dec-15 | 200           |                | 201512        | CM          | 12            | 2015 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD09          | Jan-16 | 200           |                | 201601        | CM          | 1             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD09          | Feb-16 | 200           |                | 201602        | CM          | 2             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD09          | Mar-16 | 200           |                | 201603        | CM          | 3             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD09          | Apr-16 | 200           |                | 201604        | CM          | 4             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD09          | May-16 | 200           |                | 201605        | CM          | 5             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD09          | Jun-16 | 200           |                | 201606        | CM          | 6             | 2016 |
    | 16-18 Apprenticeships Total Funding  | ALLO-AMD09          | Jul-16 | 200           |                | 201607        | CM          | 7             | 2016 |

    When the file is copied from the source location to the 'Input'
    Then a file 'MAIN AY 1516 02062015130000 BulkAmendPerformance.xlsx.Syntax Report.txt' is created with success message indicating the processing of the spreadsheet in location 'Reports'
   #And  a results report excel spreadsheet is generated in the storage less than 600 seconds for amendments
    And  a file 'MAIN AY 1516 02062015130000 BulkAmendPerformance.xlsx.Results Report.xlsx' is created in location 'Reports' in less than 56 seconds
    And  the contract data is now removed

   