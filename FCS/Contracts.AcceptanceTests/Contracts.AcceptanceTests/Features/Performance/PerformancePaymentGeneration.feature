Feature: PerformancePaymentGeneration

    Testing for Nonfunctional requirements impacting payment generation

#@PerformanceDaily
#@PerformanceWeekly
#@ReportPerformance
Scenario: P009 Ensure payment generation is successful for 18000 lines in 15 minutes
    Given that '18000' Subnominal Aggregation exists in the data store (cloned from the record below)
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Funding Stream Period Name    | Calendar Year/Period | Funding Stream Code | Funding Stream Name   | Payment Type | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 40404001 | ORG0004001 | 16AP-01           | 1234501         | 16-18APPS1516              | 16-18 Apprenticeships 2015-16 | 201506               | 16-18 APPS          | 16-18 Apprenticeships | PROFILE      | CM             | False       | 20.00           |
   
    And   the below configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | Status     |
    | 16-18APPS1516              | 201506               | 03/07/2015 09:15     | NotStarted |
    
    And   the below configuration exists in the Account Codes table
    | Ukprn    | Funding Stream Period Code | Coda Code | Control Code | Effective Start Date | Effective End Date |
    | 40404001 | 16-18APPS1516              | CODA501   | 8113000      | 01/06/2015           | 31/07/2015         |
   #| 40404001 | 16-18 APPS                 | CODA501   | 8113000      | 01/06/2015           | 31/07/2015         |
   
    When  the Payment Generation Batch run is started
    Then  a timer is started
    And   Payment file 'AP1620150503A.pay' is created in PTS drop location
    And   Payment file 'AP1620150503A.nat' is created in PTS drop location

    And   the following data exists in the Summary file
    | Payment File Name | Number of Payment Instructions | Value of Payment Instruction | Error File Name   | Number of Payment Error | Value of Payment Error |
    | AP1620150503A.pay | 1                              | 20.00                        | AP1620150503A.err | 17999                   | 359980.00              |

   #And   there is an entry in the Payment Timetable
   #| Funding Stream Period Code | Calendar Year/Period | Status    |
   #| 16-18APPS1516              | 201506               | Completed |

    And   there is an entry in the Payment History Table
    | Funding Stream Period Code | Period | Description                                   |
    | 16-18APPS1516              | 201506 | Payment timetable status changed to Completed |

    And the timer should be less than 900 seconds
 
#@PerformanceDaily
#@PerformanceWeekly
#@ReportPerformance
Scenario: P010 Ensure payment generation is successful for 8 streams with 4000 lines each in 15 minutes
    Given that '4000' Subnominal Aggregation exists in the data store (cloned from the record below)
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Funding Stream Period Name    | Calendar Year/Period | Funding Stream Code | Funding Stream Name   | Payment Type | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 40404001 | ORG0004001 | 16AP-01           | 1234501         | 16-18APPS1516              | 16-18 Apprenticeships 2015-16 | 201506               | 16-18 APPS          | 16-18 Apprenticeships | PROFILE      | CM             | False       | 20              |

    And   that '4000' Subnominal Aggregation exists in the data store (cloned from the record below)
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Funding Stream Period Name | Calendar Year/Period | Funding Stream Code | Funding Stream Name | Payment Type | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 40424001 | ORG0024001 | CLCL-01           | 5555555         | CL1516                     | Community Learning 2015-16 | 201506               | CL                  | Community Learning  | PROFILE      | CM             | False       | 25000.00        |

    And   that '4000' Subnominal Aggregation exists in the data store (cloned from the record below)
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Funding Stream Period Name            | Calendar Year/Period | Funding Stream Code | Funding Stream Name           | Payment Type | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 40444001 | ORG0044001 | DLDL-01           | 7777777         | DLS1516                    | Discretionary Learner Support 2015-16 | 201506               | DLS                 | Discretionary Learner Support | PROFILE      | CM             | False       | 15000.00        |

    And   that '4000' Subnominal Aggregation exists in the data store (cloned from the record below)
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Funding Stream Period Name            | Calendar Year/Period | Funding Stream Code | Funding Stream Name           | Payment Type | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 40464001 | ORG0064001 | ASC1-01           | 8888888         | ASC1516                    | Apprenticeships Total Funding 2015-16 | 201506               | ASC                 | Apprenticeships Total Funding | PROFILE      | CM             | False       | 15000.00        |

    And   that '4000' Subnominal Aggregation exists in the data store (cloned from the record below)
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Funding Stream Period Name            | Calendar Year/Period | Funding Stream Code | Funding Stream Name           | Payment Type | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 40484001 | ORG0084001 | ASTO-01           | 1111111         | ASTO1516                   | Apprenticeships Total Funding 2015-16 | 201506               | ASTO                | Apprenticeships Total Funding | PROFILE      | CM             | False       | 15000.00        |

    And   that '4000' Subnominal Aggregation exists in the data store (cloned from the record below)
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Funding Stream Period Name                      | Calendar Year/Period | Funding Stream Code | Funding Stream Name                     | Payment Type | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 40504001 | ORG0104001 | ALLC-01           | 2222222         | ALLC1516                   | Advanced Learning Loans Bursary funding 2015-16 | 201506               | 24+ ALLBC           | Advanced Learning Loans Bursary funding | PROFILE      | CM             | False       | 15000.00        |

    And   that '4000' Subnominal Aggregation exists in the data store (cloned from the record below)
    | UKPRN    | Org ID     | Allocation Number | Subnominal Code | Funding Stream Period Code | Funding Stream Period Name                      | Calendar Year/Period | Funding Stream Code | Funding Stream Name                     | Payment Type | PeriodTypeCode | Posted Flag | AggregatedValue |
    | 40524001 | ORG0124001 | ALLB-01           | 3333333         | ALLB1516                   | Advanced Learning Loans Bursary funding 2015-16 | 201506               | 24+ ALLB            | Advanced Learning Loans Bursary funding | PROFILE      | CM             | False       | 15000.00        |
    
    And   the below configuration exists in the Payment Timetable
    | Funding Stream Period Code | Calendar Year/Period | Census End Date/Time | Status     |
    | 16-18APPS1516              | 201506               | 03/07/2015 09:15     | NotStarted |
    | CL1516                     | 201506               | 03/07/2015 09:15     | NotStarted |
    | DLS1516                    | 201506               | 03/07/2015 09:15     | NotStarted |
    | ASC1516                    | 201506               | 03/07/2015 09:15     | NotStarted |
    | ASTO1516                   | 201506               | 03/07/2015 09:15     | NotStarted |
    | ALLC1516                   | 201506               | 03/07/2015 09:15     | NotStarted |
    | ALLB1516                   | 201506               | 03/07/2015 09:15     | NotStarted |

    And   the below configuration exists in the Account Codes table
    | Ukprn    | Funding Stream Period Code | Coda Code | Control Code | Effective Start Date | Effective End Date |
    | 40404001 | 16-18APPS1516       | CODA501   | 8113000      | 01/06/2015           | 31/07/2015         |
    | 40424001 | CL1516              | CODA601   | 8113000      | 01/06/2015           | 31/07/2015         |
    | 40444001 | DLS1516             | CODA701   | 8113000      | 01/06/2015           | 31/07/2015         |
    | 40464001 | ASC1516             | CODA801   | 8113000      | 01/06/2015           | 31/07/2015         |
    | 40484001 | ASTO1516            | CODA901   | 8113000      | 01/06/2015           | 31/07/2015         |
    | 40504001 | ALLC1516            | CODA101   | 8113000      | 01/06/2015           | 31/07/2015         |
    | 40524001 | ALLB1516            | CODA201   | 8113000      | 01/06/2015           | 31/07/2015         |
    
    When  the Payment Generation Batch run is started
    Then  a timer is started
    And   Payment file 'AP1620150503A.pay' is created in PTS drop location
    And   Payment file 'AP1620150503A.nat' is created in PTS drop location

    And   the following data exists in the Summary file
    | Payment File Name | Number of Payment Instructions | Value of Payment Instruction | Error File Name   | Number of Payment Error | Value of Payment Error |
    | AP1620150503A.pay | 1                              | 20.00                        | AP1620150503A.err | 3999                    | 69980.00               |

    And   there is an entry in the Payment History Table
    | Funding Stream Period Code | Period | Description                                   |
    | 16-18APPS1516              | 201506 | Payment timetable status changed to Completed |
    | CL1516                     | 201506 | Payment timetable status changed to Completed |
    | DLS1516                    | 201506 | Payment timetable status changed to Completed |
    | ASC1516                    | 201506 | Payment timetable status changed to Completed |
    | ASTO1516                   | 201506 | Payment timetable status changed to Completed |
    | ALLC1516                   | 201506 | Payment timetable status changed to Completed |
    | ALLB1516                   | 201506 | Payment timetable status changed to Completed |
  
    And   the timer should be less than 900 seconds


