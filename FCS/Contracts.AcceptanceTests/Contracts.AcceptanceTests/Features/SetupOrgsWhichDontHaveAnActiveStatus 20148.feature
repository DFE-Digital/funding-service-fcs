Feature: SetupOrgsWhichDontHaveAnActiveStatus 20148

@AcceptanceTest @Withdrawn20260521
Scenario: A309 Create provider data in Organisation.Organisation and CRM for Orgs with assorted inactive statuses
    # Add data to dbo.Organisations
    Given the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name                       | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018302 | 118302 | Deleted Co Ltd             | 0              | Deleted               | Yes           | AA018302      | ?             | 111 Hagley Road        | Edgbaston              | ?                      | ?                      | Birmingham             | West Midlands          | B16 8LB   |
    | 10018303 | 118303 | Dissolved Co Ltd           | 0              | Dissolved             | Yes           | AA018303      | ?             | 11 Kingsmead Square    | Bath                   | Avon                   | ?                      | ?                      | ?                      | BA1 2AB   |
	| 10018304 | 118304 | Inactive Co Ltd            | 0              | Inactive              | Yes           | AA018304      | ?             | 71 Beckenham Lane      | Shortlands             | ?                      | ?                      | Bromley                | Kent                   | BR2 0JB   |
	| 10018305 | 118305 | InLiquidation Co Ltd       | 0              | In Liquidation        | Yes           | AA018305      | ?             | 67 High Street         | ?                      | ?                      | ?                      | Hemel Hempstead        | Hertfordshire          | HP1 3AF   |
	| 10018306 | 118306 | LockedRestructure Co Ltd   | 0              | Locked Restructure    | Yes           | AA018306      | ?             | 1 Wellington Square    | Ayr                    | ?                      | ?                      | ?                      | ?                      | KA7 1EN   |
	| 10018307 | 118307 | InAdministration Co Ltd    | 0              | In Administration     | Yes           | AA018307      | ?             | 51 Blackmore           | ?                      | ?                      | ?                      | Letchworth             | Hertfordshire          | SG6 2SZ   |
	| 10018308 | 118308 | ProviderUnderChange Co Ltd | 0              | Provider Under Change | Yes           | AA018308      | ?             | 12 Aintree Road        | Perivale               | ?                      | ?                      | Greenford              | Middlesex              | UB6 7LA   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10018302 |
	| 10018303 |
	| 10018304 |
	| 10018305 |
	| 10018306 |
	| 10018307 |
	| 10018308 |

   