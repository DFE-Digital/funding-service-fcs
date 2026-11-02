Feature: OrganisationServiceExceptions 18223

@AcceptanceTest @Complete
Scenario: A336 Process an INITIATED Levy event for a provider unknown to PIMS then add the provider to PIMS before creating the contract in CRM
    Given there is no Contract, Task or Workflow data for UKPRN '10017336'
    And   caseload advisor 'FCS2 Test' is assigned to provider 'NACRO' with UKPRN '10017336' and OrgId 'ORG0017336' and has 'FCS1 Test' as a manager
    And   the PaaS MonthEndIsRunning indicator is set to 'False'
    And   there is no Levy event data in the DAS agreement stub
    And   there are no DAS engagement events stored in FCS
    And   the override date is reset

    # Stage 1: There isn't a provider in PIMS so park the event

    And   there is no data in the Organisation stub for UKPRN '10017336'

    And   the following Levy event data is available in the DAS agreement stub
    | Id     | Event     | CreatedOn                | ProviderId | ContractType      |
    | 42167  | CREATED   | 2016-12-05T16:19:15.1088 | 10017336   | ProviderAgreement | 
    | 42168  | INITIATED | 2016-12-05T16:19:15.1167 | 10017336   | ProviderAgreement |  
    | 42169  | DELETED   | 2016-12-05T16:19:15.1203 | 10017336   | ProviderAgreement | 

    When  the Levy event data is pulled from the DAS agreement stub
    Then  there is unprocessed PIMS-related event data in the Engagement Events table for UKPRN '10017336'
    And   there are no contracts in CRM for UKPRN '10017336'

    # Stage 2: A valid provider now exists in PIMS. Process event and create contract 

    Given the following data is in the Organisation stub
    | UKPRN    | OrganisationStatus |
    | 10017336 | Active             |

    And   there is no Levy event data in the DAS agreement stub
    When  the Levy event data is pulled from the DAS agreement stub
    Then  there is one contract in CRM for UKPRN '10017336'
    And   there is no unprocessed PIMS-related event data in the Engagement Events table for UKPRN '10017336'
   
@AcceptanceTest @Complete
Scenario: A337 Handle multiple INITIATED events for a provider unknown to PIMS then add the provider to PIMS before creating the Levy contract in CRM
    Given there is no Contract, Task or Workflow data for UKPRN '10017337'
    And   caseload advisor 'FCS2 Test' is assigned to provider 'NACRO' with UKPRN '10017337' and OrgId 'ORG0017337' and has 'FCS1 Test' as a manager
    And   the PaaS MonthEndIsRunning indicator is set to 'False'
    And   there is no Levy event data in the DAS agreement stub
    And   there are no DAS engagement events stored in FCS
    And   the override date is reset

    # Stage 1: There isn't a valid provider in PIMS so park the events

    And   there is no data in the Organisation stub for UKPRN '10017337'

    And   the following Levy event data is available in the DAS agreement stub
    | Id     | Event     | CreatedOn                | ProviderId | ContractType      |
    | 42173  | INITIATED | 2016-12-05T16:19:17.1088 | 10017337   | ProviderAgreement | 
    | 42174  | INITIATED | 2016-12-05T16:19:17.1167 | 10017337   | ProviderAgreement | 
    | 42175  | INITIATED | 2016-12-05T16:19:17.1203 | 10017337   | ProviderAgreement | 

    When  the Levy event data is pulled from the DAS agreement stub
    Then  there is unprocessed PIMS-related event data in the Engagement Events table for UKPRN '10017337'
    And   there are no contracts in CRM for UKPRN '10017337'

    # Stage 2: A valid provider now exists in PIMS. Process event and create contract 

    Given the following data is in the Organisation stub
    | UKPRN    | OrganisationStatus |
    | 10017337 | Active             |

    When  the Levy event data is pulled from the DAS agreement stub
    Then  there is one contract in CRM for UKPRN '10017337'
    And   there is no unprocessed PIMS-related event data in the Engagement Events table for UKPRN '10017337'

@AcceptanceTest @Complete
Scenario: A338 Process an INITIATED Levy event into CRM for a provider in liquidation plus one for an active provider
    Given there is no Contract, Task or Workflow data for UKPRN '88999994'
    And   there is no Contract, Task or Workflow data for UKPRN '10017338'
    And   caseload advisor 'FCS2 Test' is assigned to provider 'NACRO' with UKPRN '88999994' and OrgId 'ORG8999994' and has 'FCS1 Test' as a manager
    And   caseload advisor 'FCS2 Test' is assigned to provider 'NACRO' with UKPRN '10017338' and OrgId 'ORG0017338' and has 'FCS1 Test' as a manager
    And   the PaaS MonthEndIsRunning indicator is set to 'False'
    And   there is no Levy event data in the DAS agreement stub
    And   there are no DAS engagement events stored in FCS
    And   the override date is reset

    # Provider in PIMS is in liquidation. This is NOT a reason to park a Levy event.

    And   the following data is in the Organisation stub
    | UKPRN    | OrganisationStatus |
    | 88999994 | In Liquidation     |
    | 10017338 | Active             |

    And   the following Levy event data is available in the DAS agreement stub
    | Id     | Event     | CreatedOn                | ProviderId | ContractType      |
    | 42179  | INITIATED | 2016-12-05T16:19:17.1088 | 88999994   | ProviderAgreement | 
    | 42180  | INITIATED | 2016-12-05T16:19:17.1167 | 88999994   | ProviderAgreement | 
    | 42181  | INITIATED | 2016-12-05T16:19:17.1203 | 10017338   | ProviderAgreement |  

    When  the Levy event data is pulled from the DAS agreement stub
    Then  there is one contract in CRM for UKPRN '88999994'
    And   there is one contract in CRM for UKPRN '10017338'
    And   there is no unprocessed PIMS-related event data in the Engagement Events table for UKPRN '88999994'
    And   there is no unprocessed PIMS-related event data in the Engagement Events table for UKPRN '10017338'

@AcceptanceTest @Complete
Scenario: A339 Process INITIATED Levy events into CRM for providers which are deleted, inactive and dissolved
    # Using UKPRNs from J034
    Given there is no Contract, Task or Workflow data for UKPRN '10018992'
    And   there is no Contract, Task or Workflow data for UKPRN '10018993'
    And   there is no Contract, Task or Workflow data for UKPRN '10018994'

    And   caseload advisor 'FCS2 Test' is assigned to provider '10018992 Co Ltd' with UKPRN '10018992' and OrgId 'ORG0018992' and has 'FCS1 Test' as a manager
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018993 Co Ltd' with UKPRN '10018993' and OrgId 'ORG0018993' and has 'FCS1 Test' as a manager
    And   caseload advisor 'FCS2 Test' is assigned to provider '10018994 Co Ltd' with UKPRN '10018993' and OrgId 'ORG0018994' and has 'FCS1 Test' as a manager

    And   the PaaS MonthEndIsRunning indicator is set to 'False'
    And   there is no Levy event data in the DAS agreement stub
    And   there are no DAS engagement events stored in FCS
    And   the override date is reset

    # Providers in PIMS that are deleted, inactive or dissolved will still generate Levy contracts.

    Given there is no Organisation data for UKPRN '10018992'
    And   there is no Organisation data for UKPRN '10018993'
    And   there is no Organisation data for UKPRN '10018994'

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018992 | 118992 | 10018992 Co Ltd | 0              | Deleted               | Yes           | AA118992      | 118992        | 11 Kingsmead Square    | Bath                   | Avon                   | ?                      | ?                      | ?                      | BA1 2AB   |
    | 10018993 | 118993 | 10018993 Co Ltd | 0              | Dissolved             | Yes           | AA118993      | 118993        | 71 Beckenham Lane      | Shortlands             | ?                      | ?                      | Bromley                | Kent                   | BR2 0JB   |
    | 10018994 | 118994 | 10018994 Co Ltd | 0              | Inactive              | Yes           | AA118994      | 118994        | 67 High Street         | ?                      | ?                      | ?                      | Hemel Hempstead        | Hertfordshire          | HP1 3AF   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10018992 |
    | 10018993 |
    | 10018994 |

    And   the following Levy event data is available in the DAS agreement stub
    | Id     | Event     | CreatedOn                | ProviderId | ContractType      | 
    | 42182  | INITIATED | 2016-12-05T16:19:17.2088 | 10018992   | ProviderAgreement |  
    | 42183  | INITIATED | 2016-12-05T16:19:17.3367 | 10018992   | ProviderAgreement |  
    | 42184  | INITIATED | 2016-12-05T16:19:17.8243 | 10018992   | ProviderAgreement |  
    | 42185  | INITIATED | 2016-12-05T16:19:17.2088 | 10018993   | ProviderAgreement |  
    | 42186  | INITIATED | 2016-12-05T16:19:17.3367 | 10018993   | ProviderAgreement |  
    | 42187  | INITIATED | 2016-12-05T16:19:17.8243 | 10018993   | ProviderAgreement |  
    | 42188  | INITIATED | 2016-12-05T16:19:17.2088 | 10018994   | ProviderAgreement |  
    | 42189  | INITIATED | 2016-12-05T16:19:17.3367 | 10018994   | ProviderAgreement |  
    | 42190  | INITIATED | 2016-12-05T16:19:17.8243 | 10018994   | ProviderAgreement |  

    When  the Levy event data is pulled from the DAS agreement stub

    Then  there is one contract in CRM for UKPRN '10018992'
    And   there is one contract in CRM for UKPRN '10018993'
    And   there is one contract in CRM for UKPRN '10018994'
     
    And   there is no unprocessed PIMS-related event data in the Engagement Events table for UKPRN '10018992'
    And   there is no unprocessed PIMS-related event data in the Engagement Events table for UKPRN '10018993'
    And   there is no unprocessed PIMS-related event data in the Engagement Events table for UKPRN '10018994'

    #Tidy Up
    And   the override date is reset
      