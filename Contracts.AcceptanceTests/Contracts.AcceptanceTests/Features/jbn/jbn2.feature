Feature: jbn2

@AcceptanceTest @InProgress
Scenario: J052 Check ADP feed event header 
    Then  the Allocation Delivery feed includes the following event information
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | CategoryTerm                     | CategoryLabel                        | Title                                                                               |
    | 10017852 | NCS-852        | 1               | 0                  | ContractAllocationActualsUpdated | Contract Allocation Actuals Updated  | Actuals for Allocation NCSC-852 of Contract NCS-852: 1.0 have been updated          |

@AcceptanceTest @InProgress
Scenario: J053 Check ADP feed for the absence of a Category 4 row 
    # Check that certain ActualsUpdated rows are absent from the AllocationDelivery.AllocationDeliveryEntry table  
    Then  the AllocationDelivery.AllocationDeliveryEntry table does not contain an ItemType '4' event for version '1' of contract number 'MAIN-854' and allocation number 'AECL-854'

@AcceptanceTest @InProgress
Scenario: J054 Check that there are no messages in the system
    When  there are no messages left in the system

@AcceptanceTest @InProgress
Scenario: J055 Manager issues request through UI to Update termination details
    # Issue an 'Update termination details' request via the CRM UI (23812)
    When  CRM user 'CRM Integration' updates contract termination details for Contract 'NLAP-853' Version '3' SubVersion '0' with the following options
    | ContractTerminationDate | TerminationReason  | TerminationComments          |
    | 28/09/2018              | Notice from Agency | Updated Termination Comments |

    And   with the following updated allocation termination options
    | AllocationNumber | AllocationStopNewStartsDate | AllocationTerminationDate |
    | ANLP-853         | 28/09/2018                  | 28/09/2018                |
    | YNLP-853         | 28/09/2018                  | 28/09/2018                |

    # Use either the CRM UI (slow) or the SDK (fast) to amend the termination details
    And   the user completes the termination amendment request via UI
#   And   the user completes the termination amendment request via SDK

@AcceptanceTest @InProgress
Scenario: J056 Add address to FCT Org Service
    # Current step (This is used in almost every GWT prior to contract creation)
    # Put data in the PaaS Organisation table (dbo.Organisations)
    Given the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name                                    | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1       | AddressLine2 | AddressLine3 | AddressLine4 | Town       | County       | Postcode |
    | 80000534 | 110534 | TESTFIELD COLLEGE                       | 0              | Active | Yes           | ?             | ?             | Barnfield Avenue   | ?            | ?            | ?            | Luton      | ?            | LU2 7BF  |
    | 80008816 | 118816 | NORTHERN SCHOOL OF CONTEMPORARY TESTING | 0              | Active | Yes           | ?             | ?             | 98 Chapeltown Road | ?            | ?            | ?            | Leeds      | ?            | LS7 4BH  |
    
@AcceptanceTest @InProgress
Scenario: J056x Add address data to FCT Org Service for Dave B
    Given the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name                                                                      | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1         | AddressLine2     | AddressLine3   | AddressLine4                 | Town            | County        | Postcode |
    | 80019914 | 019914 | TEST COLLEGE OF HUMAN RESOURCE DEVELOPMENT AND MANAGEMENT STUDIES LIMITED | 0              | Active | Yes           | ?             | ?             | 34 Mawney Road       | ?                | ?              | ?                            | Romford         | ?             | RM7 7HD  |
    | 80008935 | 008935 | TESTING CURVE GROUP LIMITED                                               | 0              | Active | Yes           | ?             | ?             | Unit 51-53           | Innovation House | Longfield Road | South Church Enterprise Park | Bishop Auckland | COUNTY DURHAM | DL14 6XB |
    | 80004285 | 004285 | TESTWAY COUNCIL                                                           | 0              | Active | Yes           | ?             | ?             | Gun Wharf            | Dock Road        | ?              | ?                            | Chatham         | ?             | ME4 4TR  |
    | 80044729 | 044729 | TESTENTUM TRAINING AND CONSULTANCY LTD                                    | 0              | Active | Yes           | 8763828       | ?             | 36 Bridge Street     | ?                | ?              | ?                            | Christchurch    | DORSET        | BH23 1EB |
    | 80066107 | 066107 | TESTTHOUSE LEARNING TRUST                                                 | 0              | Active | Yes           | 10819176      | ?             | Mill Lane            | ?                | ?              | ?                            | Gosport         | ?             | PO12 4QA |
    | 80066120 | 066120 | TEST VALLEY COLLABORATIVE TRUST                                           | 0              | Active | Yes           | 10743632      | ?             | Church Walk          | ?                | ?              | ?                            | Guisborough     | ?             | TS14 6BU |
    | 80065834 | 065834 | RICHARD TAUNTON SIXTH FORM COLLEGE                                        | 0              | Active | Yes           | ?             | ?             | 30 Oswald Road       | ?                | ?              | ?                            | St Albans       | Hertfordshire | AL1 3AQ  |
    | 80065941 | 065941 | PRIOR PURSGLOVE AND STOCKTON SIXTH FORM COLLEGE                           | 0              | Active | Yes           | ?             | ?             | 9 Clarendon Villas   | Widcombe Hill    | Bath           | ?                            | ?               | ?             | BA2 6AG  |
    | 80065835 | 065835 | ST VINCENT COLLEGE                                                        | 0              | Active | Yes           | ?             | ?             | 2 Meeting House Lane | Balsall Common   | Warwickshire   | ?                            | ?               | ?             | CV7 7BG  |

@AcceptanceTest @InProgress
Scenario: J057x Add address data CRM Organisation table for Dave B
    Given the following Organisations exist in CRM
    | UKPRN    | UPIN   | Name                                                                      | Status | CompanyNumber | CharityNumber | AddressLine1         | AddressLine2     | AddressLine3   | AddressLine4                 | Town            | County        | Postcode |
    | 80019914 | 019914 | TEST COLLEGE OF HUMAN RESOURCE DEVELOPMENT AND MANAGEMENT STUDIES LIMITED | Active | ?             | ?             | 34 Mawney Road       | ?                | ?              | ?                            | Romford         | ?             | RM7 7HD  |
    | 80008935 | 008935 | TESTING CURVE GROUP LIMITED                                               | Active | ?             | ?             | Unit 51-53           | Innovation House | Longfield Road | South Church Enterprise Park | Bishop Auckland | COUNTY DURHAM | DL14 6XB |
    | 80004285 | 004285 | TESTWAY COUNCIL                                                           | Active | ?             | ?             | Gun Wharf            | Dock Road        | ?              | ?                            | Chatham         | ?             | ME4 4TR  |
    | 80044729 | 044729 | TESTENTUM TRAINING AND CONSULTANCY LTD                                    | Active | 8763828       | ?             | 36 Bridge Street     | ?                | ?              | ?                            | Christchurch    | DORSET        | BH23 1EB |
    | 80066107 | 066107 | TESTTHOUSE LEARNING TRUST                                                 | Active | 10819176      | ?             | Mill Lane            | ?                | ?              | ?                            | Gosport         | ?             | PO12 4QA |
    | 80066120 | 066120 | TEST VALLEY COLLABORATIVE TRUST                                           | Active | 10743632      | ?             | Church Walk          | ?                | ?              | ?                            | Guisborough     | ?             | TS14 6BU |
    | 80065834 | 065834 | RICHARD TAUNTON SIXTH FORM COLLEGE                                        | Active | ?             | ?             | 30 Oswald Road       | ?                | ?              | ?                            | St Albans       | Hertfordshire | AL1 3AQ  |
    | 80065941 | 065941 | PRIOR PURSGLOVE AND STOCKTON SIXTH FORM COLLEGE                           | Active | ?             | ?             | 9 Clarendon Villas   | Widcombe Hill    | Bath           | ?                            | ?               | ?             | BA2 6AG  |
    | 80065835 | 065835 | ST VINCENT COLLEGE                                                        | Active | ?             | ?             | 2 Meeting House Lane | Balsall Common   | Warwickshire   | ?                            | ?               | ?             | CV7 7BG  |

@AcceptanceTest @InProgress
Scenario: J057 Add address to CRM Organisation table
    # Current step extended with optional address columns
    # Put data in the CRM Organisation table J057
    Given the following Organisations exist in CRM
    | UKPRN    | UPIN   | Name            | Status | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017001 | 117001 | 10017001 Co Ltd | Active | AA017001      | 17001         | ?                      | ?                      | 1 Gurney Lane          | Cringleford            | Norwich                | Norfolk                | NR4 7SB   |
    | 10017002 | 117002 | 10017002 Co Ltd | Active | AA017002      | 17002         | 12 Runnymede Gardens   | Chigley                | Camberwick Green       | Trumpton               | ?                      | ?                      | TR1 2AB   |
    | 10017003 | 117003 | 10017003 Co Ltd | Active | AA017003      | 17003         | 2 Church Gates         | ?                      | The Wilderness         | ?                      | Berkhamsted            | Hertfordshire          | HP4 2UB   |
    | 10017004 | 117004 | 10017004 Co Ltd | Active | AA017004      | 17004         | 10 St. Mary at Hill    | London                 | ?                      | ?                      | ?                      | ?                      | EC3R 8EE  |
    | 10017005 | 117005 | 10017005 Co Ltd | Active | AA017005      | 17005         | 20 West Wallaby St     | Abbots Green           | Abbotsford             | Paleover Hundred       | Stone Battersby        | West Yorkshire         | LS29 9EG  |
    | 10017006 | 117006 | 10017006 Co Ltd | Active | AA017006      | 17006         | ?                      | 20 Bothwell Road       | ?                      | ?                      | Hamilton               | South Lanarkshire      | ML3 0AY   |
    | 10017108 | 117108 | 10017108 Co Ltd | Active | AA017108      | 17108         | 230 Wharfdale Road     | Winnersh Triangle      | ?                      | Gardley                | Wokingham              | Berkshire              | RG41 5TP  |
    | 10017237 | 117237 | 10017237 Co Ltd | Active | AA017237      | 17237         | 7 Watermill House      | Restmor Way            | Wallington             | ?                      | ?                      | Surrey                 | SM6 7AH   |
    | 10017256 | 117256 | 10017256 Co Ltd | Active | AA017256      | 17256         | 6 Eghams Court         | Boston Drive           | ?                      | ?                      | Bourne End             | Buckinghamshire        | SL8 5YS   |
    | 10017257 | 117257 | 10017257 Co Ltd | Active | AA017257      | 17257         | 7a Deans Court         | Bicester               | ?                      | ?                      | Oxon                   | Oxfordshire            | OX6 7XZ   |
    | 10017258 | 117258 | 10017258 Co Ltd | Active | AA017258      | 17258         | 54 Maple Road          | 18 Osprey Court        | Surbiton               | ?                      | ?                      | Surrey                 | KT6 4BQ   |
    | 10017278 | 117278 | 10017278 Co Ltd | Active | AA017278      | 17278         | 2440 The Quardrant     | Aztec West             | Almondsbury            | Bristol                | ?                      | ?                      | BS32 4AQ  |
    | 10017279 | 117279 | 10017279 Co Ltd | Active | AA017279      | 17279         | 5 Charterhouse Bldgs   | 2nd Floor              | Gosswell Rd            | Inkling                | London                 | ?                      | EC1M 7AN  |
    | 10017280 | 117280 | 10017280 Co Ltd | Active | AA017280      | 17280         | 5 Alton House          | Gatehouse Way          | ?                      | ?                      | Alyesbury              | Buckinghamshire        | HP19 8HN  |
    | 10017294 | 117294 | 10017294 Co Ltd | Active | AA017294      | 17294         | 1301 Stratford Road    | Hall Green             | ?                      | ?                      | Birmingham             | West Midlands          | B28 9HH   |
    | 10017318 | 117318 | 10017318 Co Ltd | Active | AA017318      | 17318         | 100 Harley Street      | London                 | ?                      | ?                      | ?                      | ?                      | W1N 1AF   |
    | 10017350 | 117350 | 10017350 Co Ltd | Active | AA017350      | 17350         | 1 Straw Close          | Caterham               | ?                      | ?                      | ?                      | Surrey                 | CR3 5FZ   |
    | 10017377 | 117377 | 10017377 Co Ltd | Active | AA017377      | 17377         | 33 London Road         | Blackwater             | Camberley              | Surrey                 | ?                      | ?                      | GU17 0AB  |
    | 10017398 | 117398 | 10017398 Co Ltd | Active | AA017398      | 17398         | 5 Jupiter House        | Calleva Park           | ?                      | ?                      | Aldermaston            | Berkshire              | RG7 8NN   |
    | 10017399 | 117399 | 10017399 Co Ltd | Active | AA017399      | 17399         | 210 Wharfdale Road     | Winnersh Triangle      | Gardley                | ?                      | Wokingham              | Berkshire              | RG41 5TP  |
    | 10017439 | 117439 | 10017439 Co Ltd | Active | AA017439      | 17439         | 10 Witcham Close       | Lower Early            | ?                      | ?                      | Reading                | Berkshire              | RG6 4H6   |
    | 10017441 | 117441 | 10017441 Co Ltd | Active | AA017441      | 17441         | 12 Witcham Gardens     | Lower Early            | ?                      | ?                      | Reading                | Berkshire              | RG6 4H6   |
    | 10017442 | 117442 | 10017442 Co Ltd | Active | AA017442      | 17442         | 96 West Yard           | Camden Lock Place      | Chalk Farm Road        | London                 | ?                      | ?                      | NW1 8AF   |
    | 10017450 | 117450 | 10017450 Co Ltd | Active | AA017450      | 17450         | 5 Alton House          | Gatehouse Way          | ?                      | ?                      | Alyesbury              | Buckinghamshire        | HP19 8HN  |
    | 10017451 | 117451 | 10017451 Co Ltd | Active | AA017451      | 17451         | 2 Westbourne House     | Wheatlands Estate      | ?                      | ?                      | Heston                 | Middlesex              | TW5 0SA   |
    | 10017498 | 117498 | 10017498 Co Ltd | Active | AA017498      | 17498         | 33 London Road         | Blackwater             | Camberley              | Surrey                 | ?                      | ?                      | GU17 0AB  |
    | 10017500 | 117500 | 10017500 Co Ltd | Active | AA017500      | 17500         | 8 Percival Terrace     | Marine Parade          | ?                      | ?                      | Brighton               | East Sussex            | BN2 1FP   |
    | 10017528 | 117528 | 10017528 Co Ltd | Active | AA017528      | 17528         | 4 Barnhaven Close      | Wyke Road              | ?                      | ?                      | Weymouth               | Dorset                 | DT4 9QJ   |
    | 10017533 | 117533 | 10017533 Co Ltd | Active | AA017533      | 17533         | 4 White Oak Square     | London Road            | ?                      | ?                      | Swanley                | Kent                   | BR8 7AG   |
    | 10017536 | 117536 | 10017536 Co Ltd | Active | AA017536      | 17536         | 52 Park Street         | Camberley              | Surrey                 | ?                      | ?                      | ?                      | GU15 3PT  |
    | 10017537 | 117537 | 10017537 Co Ltd | Active | AA017537      | 17537         | 49 Lyon Meade          | Stanmore               | London                 | ?                      | ?                      | ?                      | HA7 1HZ   |
    | 10017540 | 117540 | 10017540 Co Ltd | Active | AA017540      | 17540         | 7 Lovers Walk          | Preston Park           | ?                      | ?                      | Brighton               | East Sussex            | BN1 6AH   |
    | 10017543 | 117543 | 10017543 Co Ltd | Active | AA017543      | 17543         | Greymar House          | 23 Keytes Lane West    | Barford Green          | Barford                | Warwick                | Warwickshire           | CV35 8EP  |
    | 10017544 | 117544 | 10017544 Co Ltd | Active | AA017544      | 17544         | 12 Aintree Road        | Perivale               | ?                      | ?                      | Greenford              | Middlesex              | UB6 7LA   |
    | 10017566 | 117566 | 10017566 Co Ltd | Active | AA017566      | 17566         | 10 Wilshire House      | Woolmead               | Farnham                | ?                      | ?                      | Surrey                 | GU9 7TT   |
    | 10017572 | 117572 | 10017572 Co Ltd | Active | AA017572      | 17572         | 11 Gainsborough Close  | Woodley                | ?                      | ?                      | Reading                | Berkshire              | RG5 4HD   |
    | 10017572 | 117572 | 10017572 Co Ltd | Active | AA017572      | 17572         | PO Box 572             | ?                      | ?                      | ?                      | ?                      | ?                      | SAN TA1   |
    | 10017614 | 117614 | 10017614 Co Ltd | Active | AA017614      | 17614         | 372a Palatine Road     | Northenden             | ?                      | ?                      | Manchester             | Greater Manchester     | M22 4FZ   |
    | 10017615 | 117615 | 10017615 Co Ltd | Active | AA017615      | 17615         | 8 Percival Terrace     | Marine Parade          | ?                      | ?                      | Brighton               | East Sussex            | BN2 1FP   |
    | 10017628 | 117628 | 10017628 Co Ltd | Active | AA017628      | 17628         | 4 White Oak Square     | London Road            | ?                      | Swanley                | ?                      | Kent                   | BR8 7AG   |
    | 10017689 | 117689 | 10017689 Co Ltd | Active | AA017689      | 17689         | 15 Princeton Mews      | 167-169 London Road    | Kingston upon Thames   | ?                      | ?                      | Surrey                 | KT2 6PT   |
    | 10017734 | 117734 | 10017734 Co Ltd | Active | AA017734      | 17734         | 58 Murray Place        | Stirling               | ?                      | ?                      | ?                      | ?                      | FK8 2BP   |
    | 10017735 | 117735 | 10017735 Co Ltd | Active | AA017735      | 17735         | 3 Southwark Street     | The Borough            | London Bridge          | London                 | ?                      | ?                      | SE1 1RQ   |
    | 10017785 | 117785 | 10017785 Co Ltd | Active | AA017785      | 17785         | 5 Jupiter House        | Calleva Park           | ?                      | ?                      | Aldermaston            | Berkshire              | RG7 8NN   |
    | 10017786 | 117786 | 10017786 Co Ltd | Active | AA017786      | 17786         | 9 Quarter Gate         | South Woodham Ferrers  | ?                      | ?                      | Chelmsford             | Essex                  | CM3 5GT   |
    | 10017786 | 117786 | 10017786 Co Ltd | Active | AA017786      | 17786         | 11 Gainsborough Close  | Woodley                | ?                      | ?                      | Reading                | Berkshire              | RG5 4HD   |
    | 10017787 | 117787 | 10017787 Co Ltd | Active | AA017787      | 17787         | 19 Eleanors Cross      | High Street North      | ?                      | ?                      | Dunstable              | Bedfordshire           | LU6 1SU   |
    | 10017792 | 117792 | 10017792 Co Ltd | Active | AA017792      | 17792         | 39 Halstead Road       | Earls Colne            | ?                      | ?                      | Colchester             | Essex                  | CO6 2NL   |
    | 10017806 | 117806 | 10017806 Co Ltd | Active | AA017806      | 17806         | 230 Wharfdale Road     | Winnersh Triangle      | ?                      | Gardley                | Wokingham              | Berkshire              | RG41 5TP  |
    | 10017828 | 117828 | 10017828 Co Ltd | Active | AA017828      | 17828         | 4 St John's Court      | Moulsham Street        | ?                      | ?                      | Chelmsford             | Essex                  | CM2 0JD   |
    | 10017846 | 117846 | 10017846 Co Ltd | Active | AA017846      | 17846         | 4b Arden Court         | Arden Road             | Little Southley        | ?                      | Alcester               | Warwickshire           | B49 6HN   |

@AcceptanceTest @InProgress
Scenario: J057a
    # Put data in the CRM Organisation table J057
    Given the following Organisations exist in CRM
    | UKPRN    | UPIN   | Name            | Status | CompanyNumber | CharityNumber | AddressLine1                             | AddressLine2                               | AddressLine3                              | AddressLine4                               | Town                               | County                               | Postcode |
    | 10017585 | 117585 | 10017585 Co Ltd | Active | AA017585      | 17585         | This is the first line of a long address | This is the second line of a long address  | This is the third line of a long address  | This is the fourth line of a long address  | This is the TOWN in a long address | This is the COUNTY in a long address | Postcode |

@AcceptanceTest @InProgress
Scenario: J058 Add address to UKRLP stub
    Given there is no data in the UKRLP stub for the following Organisations
    | UKPRN    |
    | 10018112 |

    # Current step extended with optional address columns
    Given the following active Organisations exist in the UKRLP stub 
    | UKPRN    | UPIN   | Name            | CompanyNumber | CharityNumber | AddressLine1 | AddressLine2 | AddressLine3 | AddressLine4 | Town       | County       | Postcode |
    | 10018112 | 118112 | 10018112 Co Ltd | PQ018112      | 18112         | 74           | Warwick Road | ?            | ?            | Kenilworth | Warwickshire | CV8 1HL  |

@AcceptanceTest @InProgress
Scenario: J059 Has the PaaS Organisation table been updated
    # Current step extended with optional address columns
    # Check that the PaaS Organisation table (dbo.Organisations) has been updated
    Then  the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | Name            | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1 | AddressLine2 | AddressLine3 | AddressLine4         | Town       | County       | Postcode |
    | 10017480 | MegaCorp Ltd    | Active | Yes           | ABC123        | CHAR123       | 74           | Warwick Road | The Grange   | Chipping Chippington | Kenilworth | Warwickshire | CV8 1HL  |

@AcceptanceTest @InProgress
Scenario: J060 Has the CRM Organisation table been updated
    # Current step extended with optional address columns
    # Check that CRM has been updated
    Then  the CRM Organisation table contains the following values
    | UKPRN    | UPIN   | Name            | Status | CompanyNumber | CharityNumber | AddressLine1 | AddressLine2 | AddressLine3 | AddressLine4 | Town       | County       | Postcode |
    | 10018112 | 118112 | MegaCorp Co Ltd | Active | AA018112      | 18112         | 74           | Warwick Road | ?            | ?            | Kenilworth | Warwickshire | CV8 1HL  |
                    
@AcceptanceTest @InProgress
Scenario: J061 Check for the absence of a notification
    # Check that CRM has been updated and a notification has not been generated

    Then  '[MasterContractNo]' is the MasterContractNumber of the latest Levy contract held by UKPRN '10009988'
    And   '[ContractNo]' is the ContractNumber of the latest Levy contract held by UKPRN '10009988'
    And   '[AllocRef]' is the ContractAllocationNumber of the latest Levy contract held by UKPRN '10009988'

   # Check that a 'Provider Details Updated' notification has not been created for the following provider
   # Note: Parameter 1 is simply a string which is searched for in the Notification Name
    Then  a notification has not been created with '10009988' in the Notification Name and with a Notification Type of 'Provider Details Updated'

@AcceptanceTest @InProgress
Scenario: J062 CFS stub processing basics
    # Clear down the CFS stub
    Given there is no data in the CFS stub

    # Clear down the feed control/audit table in PaaS
    Given there is no data in the AllocationNotifications table for the following UKPRNs
    | UKPRN    |
    | 10017123 |
    | 10017456 |
    | 10017789 |
        
    # Clear down CRM Allocations data
    Given there is no data in the Allocations, AllocationPeriods or AllocationHistory tables in CRM for the following UKPRNs
    | UKPRN    |
    | 10017123 |
    | 10017456 |
    | 10017789 |

    # Populate the CFS stub
    Given the following Provider, Allocation and Profile details are either assumed or available in the CFS stub
    | ContractingUKPRN | AllocationRef | DeliveryUKPRN | ContractRequired | LegalName        | FundingStreamPeriodCode | DeliverableCode | FundingType | FundingPeriod | MajorVersion | MinorVersion | StartDate  | EndDate    | Status    | TotalValue | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | 
    | 10017123         | 12301-ALLF005 | ?             | Y                | 10017123 Co Ltd  | ALLF1819                | 5               | LOANS       | AY1819        | 1            | 1            | 01/08/2018 | 31/07/2019 | Published | 22724.00   | 1843.00  | 1186.00  | 2174.00  | 2910.00  | 1685.00  | 1660.00  | 751.00   | 3479.00  | 1715.00  | 3305.00  | 499.00   | 1517.00  | 
    | 10017456         | 45601-ALLF005 | ?             | Y                | 10017456 Co Ltd  | ALLF1819                | 5               | LOANS       | AY1819        | 1            | 1            | 01/08/2018 | 31/07/2019 | Published | 23838.00   | 1769.00  | 638.00   | 3049.00  | 3217.00  | 978.00   | 3010.00  | 3335.00  | 623.00   | 1359.00  | 2851.00  | 109.00   | 2900.00  |
    | 10017789         | 78901-ALLF005 | ?             | Y                | 10017789 Co Ltd  | ALLF1819                | 5               | LOANS       | AY1819        | 1            | 1            | 01/08/2018 | 31/07/2019 | Published | 13549.00   | 627.00   | 825.00   | 232.00   | 2011.00  | 3093.00  | 2565.00  | 1433.00  | 144.00   | 311.00   | 1774.00  | 104.00   | 430.00   |
    



    # Process the stub data into CRM
    
    # Read control\header data from stub
    When  the feed-reading process is started

    # Has the stub control data arrived in ContractRequest.AllocationNotification
    When  the header data for the following UKPRNs is present in the AllocationNotification table
    | UKPRN    |
    | 10017123 |
    | 10017456 |
    | 10017789 |

    # Stub data is processed into CRM  
    When  the CFS stub data is processed into CRM




    # Check Allocations in CRM
    Then   the following Allocations details are present in CRM
    | ContractingUKPRN | AllocationRef | ContractingProvider | DeliverableCode | DeliverableName                 | TotalValue | StartDate  | EndDate    | Status      | SubStatus | FundingStreamPeriodCode | FundingType | FundingPeriod | Owner             | MajorVersion | MinorVersion | DeliveryUKPRN | DeliveryProvider |
    | 10017123         | 12301-ALLF005 | 10017123 Co Ltd     | 5               | Advanced Learner Loans Facility | 22724.00   | 01/08/2018 | 31/07/2019 | Pre-Release | In Review | ALLF1819                | LOANS       | AY1819        | CRM Integration   | 1            | 1            | ?             | ?                |
    | 10017456         | 45601-ALLF005 | 10017456 Co Ltd     | 5               | Advanced Learner Loans Facility | 23838.00   | 01/08/2018 | 31/07/2019 | Pre-Release | In Review | ALLF1819                | LOANS       | AY1819        | CRM Integration   | 1            | 1            | ?             | ?                |
    | 10017789         | 78901-ALLF005 | 10017789 Co Ltd     | 5               | Advanced Learner Loans Facility | 13549.00   | 01/08/2018 | 31/07/2019 | Pre-Release | In Review | ALLF1819                | LOANS       | AY1819        | CRM Integration   | 1            | 1            | ?             | ?                |

    # Check the row count in the CRM Allocations table
    Then  there is '1' row in the Allocations table in CRM for UKPRN '10017123'
    Then  there is '1' row in the Allocations table in CRM for UKPRN '10017456'
    Then  there is '1' row in the Allocations table in CRM for UKPRN '10017789'

    # Check AllocationPeriods in CRM
    Then   the following AllocationPeriods details are present in CRM
    | ContractingUKPRN | AllocationRef | Total     | Aug-18   | Sep-18   | Oct-18   | Nov-18   | Dec-18   | Jan-19   | Feb-19   | Mar-19   | Apr-19   | May-19   | Jun-19   | Jul-19   | Owner            |
    | 10017123         | 12301-ALLF005 | 22724.00  | 1843.00  | 1186.00  | 2174.00  | 2910.00  | 1685.00  | 1660.00  | 751.00   | 3479.00  | 1715.00  | 3305.00  | 499.00   | 1517.00  | CRM Integration  |
    | 10017456         | 45601-ALLF005 | 23838.00  | 1769.00  | 638.00   | 3049.00  | 3217.00  | 978.00   | 3010.00  | 3335.00  | 623.00   | 1359.00  | 2851.00  | 109.00   | 2900.00  | CRM Integration  |
    | 10017789         | 78901-ALLF005 | 13549.00  | 627.00   | 825.00   | 232.00   | 2011.00  | 3093.00  | 2565.00  | 1433.00  | 144.00   | 311.00   | 1774.00  | 104.00   | 430.00   | CRM Integration  |

    # Check the row count in the CRM AllocationPeriods table
    Then  there are '12' rows in the AllocationPeriods table in CRM for UKPRN '10017123'
    Then  there are '12' rows in the AllocationPeriods table in CRM for UKPRN '10017456'
    Then  there are '12' rows in the AllocationPeriods table in CRM for UKPRN '10017789'
    
    # Check AllocationHistory in CRM
    Then  the following AllocationHistory details are present in CRM    
    | ContractingUKPRN | AllocationRef | Action               | NewStatus      | NewSubStatus  | PreviousStatus  | PreviousSubStatus | CompletedBy      |
    | 10017123         | 12301-ALLF005 | Record Imported      | Pre-Release    | In Review     | ?               | ?                 | CRM Integration  |
    | 10017456         | 45601-ALLF005 | Record Imported      | Pre-Release    | In Review     | ?               | ?                 | CRM Integration  |
    | 10017789         | 78901-ALLF005 | Record Imported      | Pre-Release    | In Review     | ?               | ?                 | CRM Integration  |
  
    # Check the row count in the CRM AllocationHistory table
    Then  there is '1' row in the AllocationHistory table in CRM for UKPRN '10017123'
    Then  there is '1' row in the AllocationHistory table in CRM for UKPRN '10017456'
    Then  there is '1' row in the AllocationHistory table in CRM for UKPRN '10017789'

 @AcceptanceTest @InProgress
 Scenario: J064 Add an Organisation
    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    Given the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode |
    | 10017112 | 101112 | 10017112 Co Ltd | 0              | Active                | Yes           | AA017112      | ?             | 14 Meadway Court       | Rutherford Close       | ?                      | ?                      | Stevenage              | Hertfordshire          | SG1 2EF  |


    # Put the same Provider data in the CRM Organisation table J057
    And   the following Organisations exist in CRM
    | OrgId      | UKPRN    | UPIN   | Name            | Status                | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode |
    | ORG0017112 | 10017112 | 101112 | 10017112 Co Ltd | Active                | AA017112      | ?             | 14 Meadway Court       | Rutherford Close       | ?                      | ?                      | Stevenage              | Hertfordshire          | SG1 2EF  |

@AcceptanceTest @InProgress
Scenario: J065 Add or Update a Caseload
    # Assuming there is no caseload in CRM, when a bulk upload occurs to create a new contract a caseload is created with an 'Unassigned' advisor
    # The second step below updates the caseload with the advisor name which needs to be one that is known to CRM - so 'Fred Bloggs' wouldn't work
    # If bulk processing isn't involved and there isn't a caseload then one is created but the provider Legal Name is null - even if the first step 
    #   is run before the caseload assignment

#    # Put Provider data in the CRM Organisation table J057 (OrgId doesn't get used)
#    Given the following Organisations exist in CRM
#    | OrgId      | UKPRN    | UPIN   | Name            | Status                | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode |
#    | ORG0017298 | 10017298 | 101298 | 10017298 Co Ltd | Active                | AA017298      | ?             | 14 Meadway Court       | Rutherford Close       | ?                      | ?                      | Stevenage              | Hertfordshire          | SG1 2EF  |

    Given caseload advisor 'FCS2 Test' is assigned to UKPRN '10022239'

@AcceptanceTest @InProgress
Scenario: J065x Set up a provider in PaaS. Copy details to CRM and set up a Caseload Advisor (This leaves the Provider Legal Name as null on the Caseload in CRM)
    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    Given the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status      | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10022236 | 122236 | 10022236 Co Ltd | 0              | Active      | Yes           | AA022236      | ?             | 91 Rupert Road         | West Derby Village     | ?                      | ?                      | Liverpool              | Merseyside             | L36 9TD   |

    # Put the same Provider data in the CRM Organisation table (Comment this out if contract being created by Bulk import)
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10022236 |

    And   caseload advisor 'Paul Lai' is assigned to UKPRN '10022236'

@AcceptanceTest @InProgress
Scenario: J065y Set up a provider in PaaS. Copy details to CRM and set up a Caseload Advisor with a Provider Legal Name
    Given caseload advisor 'Paul Lai' is assigned to provider 'Toybox Co Ltd' with UKPRN '10022239' and OrgId 'ORG0022239' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (dbo.Organisations) J056
    Given the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status      | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10022239 | 122239 | 10022239 Co Ltd | 0              | Active      | Yes           | AA022239      | ?             | 91 Rupert Road         | West Derby Village     | ?                      | ?                      | Liverpool              | Merseyside             | L36 9TD   |

    # Put the same Provider data in the CRM Organisation table (Comment this out if contract being created by Bulk import)
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10022239 |

 #  And   caseload advisor 'Paul Lai' is assigned to provider '10022238 Co Ltd' with UKPRN '10022238' and OrgId 'ORG0022238' and has 'FCS1 Test' as a manager 

@AcceptanceTest @InProgress
Scenario: J066 Release Allocations
    Given all cfs allocations are ready to be released
    # Release Allocations (and create contracts) for the following Funding Type and Period and run WF?? (25230)    
    When  FundingTypePeriod 'Advanced Learner Loans - AY1819' is selected from the Release Allocations for Contracting dropdown and the appropriate CRM workflow is triggered
     
@AcceptanceTest @InProgress
Scenario: J067 Blob storage of Sharepoint data. Cleardown and check steps
    # Clear down the blob document archive and the associated ArchiveDocument control table
    Given there is no data in the document archive or the associated control table

    # Check the contents of document control blob storage and the associated ArchiveDocument control table
    Then  there is '1' file prefixed '10017777_MAIN-777_v1' in the document archive and the associated control table
    And   there are '0' files prefixed '10017777' in the document archive and the associated control table
    And   there are '3' files prefixed '10017777' in the document archive and the associated control table

@AcceptanceTest @InProgress
Scenario: J068 Save a Sharepoint pdf
    # Copy\Save a named Sharepoint file to a named folder\filename
    Then  Sharepoint file '10017251_EDSK-251_v3.pdf' in 'EDSK-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017251_EDSK-251_v3.pdf'
    Then  Sharepoint file '10017251_[ContractNo]_v3.pdf' in 'EDSK-1920-Input-Appendices' is copied to 'Datafiles/Downloads' as '10017251_[ContractNo]_v3_1.pdf'

@AcceptanceTest @InProgress
Scenario: ACH101 Create a large number of contracts that are related to FCRs
    Given there is no data in the DEDS stub or PAAS tables for the following claim type and period
    | ClaimTypeName | Period | 
    | Final         | 1819   |
    And there is FundingClaim table or Stub is empty
    And there are no contracts or Orgs for this FSP 'AEBC1819'
    And we have created '10' contracts for AEBC1819 starting at this '0004636' orgId and ukprn starts with '80010001' and contract starts '1001'
    And we have created funding claims in the stub for each contract we have just created
    When  data is retrieved from the DEDS stub and is consumed

@AcceptanceTest @InProgress
Scenario: J069 Set the status and substatus of one or more Funding Claim Reconciliations
    Given the following Funding Claim Reconciliations have a status of 'Draft' and a substatus of 'Recalculating'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017554 | 1819          | Year End         | AEBC1819            | 5                  |
    | 10017554 | 1819          | Year End         | AEB-LS1819          | 5                  |
    | 10017554 | 1819          | Year End         | ALLBC1819           | 5                  |

@AcceptanceTest @InProgress
Scenario: J069a Set the status and substatus of a Funding Claim Reconciliation to Recalculating (Held)
    # Simulate a calculation in progress by setting the FCR to Draft\Recalculating (Held)
    Given the following Funding Claim Reconciliations have a status of 'Draft' and a substatus of 'Recalculating (Held)'
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017556 | 1819          | Year End         | AEBC1819            | 5                  |

@AcceptanceTest @InProgress
Scenario: J070 Launch WF26 in CRM to trigger a hold request against an FCR
    # Trigger WF26 in CRM to put an FCR on hold 
    When  a hold request is triggered in CRM for the following unpublished Funding Claim Reconciliations
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017554 | 1819          | Year End         | AEBC1819            | 5                  |

@AcceptanceTest @InProgress
Scenario: J071 Launch WF27 in CRM to trigger the release of a held FCR
    # Trigger WF27 in CRM to release a held FCR
    When  a release request is triggered in CRM for the following held Funding Claim Reconciliations
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber |
    | 10017554 | 1819          | Year End         | AEBC1819            | 5                  |       

@AcceptanceTest @InProgress
Scenario: J072 New Claim Adjustment Reason
    # Set the Claim Adjustment Reason on the FCR Allocation in CRM
    When  the reconciliation values on the CRM funding claim allocations are amended as follows
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | ClaimVersionNumber | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason |
    | 10017111 | 1819          | Year End         | AEB-LS1819          | 3                  | AEBL-111      | 17572.00     | 20209.12     | 0.00                        | 0.00                | 20209.12         | -209.12         | Ineligible Data       |

    # Check the Claim Adjustment Reason on the FCR Allocation in CRM
    Then  allocation data is present in the CRM funding claim reconciliation tables as follows 
    | UKPRN    | FundingPeriod | FundingClaimType | AllocationGroupCode | AllocationRef | PlannedValue | ClaimedValue | ProposedReconciliationValue | ReconciliationValue | CappedClaimValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue | 3%ofPlannedValue |
    | 10017111 | 1819          | Year End         | AEB-LS1819          | AEBL-111      | 17572.00     | 20209.12     | 0.00                        | 0.00                | 20209.12         | -209.12         | Ineligible Data       | 20000.00                 | 527.16           |

@AcceptanceTest @InProgress
Scenario: J073 New Claim Adjustment fields on Atom feed
    # Check the content of the type 0 events in the PerformanceManagement.AtomFeedItem table
    Then  the PerformanceManagement.AtomFeed contains the following item type 0 events and values
    | UKPRN    | AllocationNumber | Period | ClaimTypeName | AllocationGroupName                                         | PlannedValue | ClaimedValue | ProposedReconciliationValue | FinalReconciliationValue | CappedClaimedValue | ClaimAdjustment | ClaimAdjustmentReason | AdjustedCappedClaimValue |
    | 10027518 | AEBL-5552        | 1819   | Year End      | Adult Education Budget - Learner Support 18/19              | 16279.00     | 15038.89     | -1040.11                    | -1368.80                 | 15038.89           | 200.00          | Other                 | 15238.89                 | 
    | 10027518 | AEC-5552         | 1819   | Year End      | Adult Education Budget (College) 18/19                      | 49215.00     | 55020.41     | 1476.45                     | 65.16                    | 52434.96           | -500.00         | Claim Error           | 51934.96                 | 
    | 10027518 | ALLC-5552        | 1819   | Year End      | Advanced Learner Loans Bursary (College) 18/19              | 19348.00     | 18204.46     | -1143.54                    | -1076.44                 | 18204.46           | ?               | ?                     | 18204.46                 | 

@AcceptanceTest @InProgress
Scenario: J075 Extend current single and bulk Levy amendment steps to include a new parameter
    # Parameters
	#   AmendmentType:            Set to Notification or Variation
	#   AddNonLevy2019Allocation: Yes or No   Note: No longer relevant as all Levy contracts now have a NonLevy allocation, so set to No
	#   AllowUnderTermination:    Yes or No   Note: Only relevant to Bulk process. Yes= Include contracts that are Approved\Under Termination
	#                                                                               No= Exclude them 
    # Bulk Amendment
    When  a request is issued to amend the following Levy contract via Bulk
    | UKPRN    | MasterContractNumber | ContractNumber | Version | Status   | SubStatus         | AmendmentType | AddNonLevy2019Allocation | AllowUnderTermination |
    | 10017301 | [MasterContractNo]   | [ContractNo]   | 1       | Approved | Under Termination | Variation     | No                       | Yes                   |

    # Singleton Amendment
    When  a request is issued to amend the following Levy contract via Single
    | UKPRN    | MasterContractNumber | ContractNumber | Version | Status   | SubStatus         | AmendmentType | AddNonLevy2019Allocation |
    | 10017301 | [MasterContractNo]   | [ContractNo]   | 1       | Approved | Approved          | Notification  | Yes                      | 

@AcceptanceTest @InProgress
Scenario: J076 Expand check of Levy contract details to use parameters
    # Add MasterContractNo, ContractNo and AllocRef_LEVY (or AllocRef_NLA) 
    Then  the draft contract header details for the new Levy contract are as follows 
    | UKPRN    | LegalName            | FundingType | MasterContractNumber | ContractNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | PeriodTypeCode | Period | CRMIntent    | OrgId      | 
    | 10017125 | 10017125 Co Ltd      | LEVY        | [MasterContractNo]   | [ContractNo]   | 01/05/2017        | ?               | 0.00          | Provider Agreement    | LEVY           | 1799   | New          | ORG0017125 | 
 
    And   the draft Levy contract allocations details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | FundingStreamPeriodCode | ContractNumber | AllocationRef   | AllocationStartDate | AllocationEndDate | AllocationValue | CRMIntent    | PeriodTypeCode | Period | 
    | 10017125 | LEVY              | LEVY1799                | [ContractNo]   | [AllocRef_LEVY] | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   | 
    | 10017125 | LEVY              | LEVY1799                | [ContractNo]   | [AllocRef_NLA]  | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   | 

    And   the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef   | DeliverableCode | ParentDeliverableCode | Total    | May-17   | DeliverableDescription               |
    | 10017125 | LEVY              | [AllocRef_LEVY] | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships     | 
    | 10017125 | LEVY              | [AllocRef_LEVY] | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships     | 
    #
    | 10017125 | LEVY              | [AllocRef_NLA]  | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships | 
    | 10017125 | LEVY              | [AllocRef_NLA]  | 7               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships | 
                    
@AcceptanceTest @InProgress
Scenario: J077 Change subnominal codes in PaaS
    # PaymentGeneration.SubnominalAggregation.  Amend subnominal codes to those from an earlier verion of config. 
    Given the subnominal codes on the following PaaS SubnominalAggregation rows have been amended 
    | UKPRN    | FundingStreamPeriodCode | AllocationNumber | Period | PaymentType    | SubnominalCode | AmendSubnominalTo |
    | 10017123 | 16-18NLAP2018           | YNLP-123         | 201908 | PROFILE        | 2240151        | 2240150           |
    | 10017123 | 16-18NLAP2018           | YNLP-123         | 201908 | CAPPING        | 2240161        | 2240160           |
    | 10017123 | ANLAP2018               | ANLP-123         | 201908 | RECONCILIATION | 2340151        | 2340150           |
    | 10017123 | ANLAP2018               | ANLP-123         | 201908 | PROFILE        | 2340161        | 2340160           |

@AcceptanceTest @InProgress
Scenario: J078 Change subnominal details in CRM
    # 'Subnominal Aggregations' table.  Amend subnominal codes to those from an earlier verion of config. 
    Given the subnominal information in the SubnominalAggregateKey, Code and SubnominalCode on the following CRM Subnominal Aggregations rows have been amended 
    | UKPRN    | FundingStreamPeriodCode | Period | PaymentType    | SubnominalAggregateKey  | Code    | SubnominalCode | AmendSubnominalTo |
    | 10017123 | 16-18NLAP2018           | Aug-19 | PROFILE        | 2240151_YNLP-123_Aug-19 | 2240151 | 2240151        | 2240150           |
    | 10017123 | 16-18NLAP2018           | Aug-19 | CAPPING        | 2240161_YNLP-123_Aug-19 | 2240161 | 2240161        | 2240160           |
    | 10017123 | ANLAP2018               | Aug-19 | RECONCILIATION | 2340151_ANLP-123_Aug-19 | 2340151 | 2340151        | 2340150           |
    | 10017123 | ANLAP2018               | Aug-19 | PROFILE        | 2340161_ANLP-123_Aug-19 | 2340161 | 2340161        | 2340160           |

@AcceptanceTest @InProgress
Scenario: J079 Issue a request in CRM to REVERT a contract, ie to reset the substatus to Awaiting Documentation
    # Document Manager requests a Contract sub-status reversion - WF39. (Can be done by Document Managers, Contract Managers and Lead Managers) 
    When  CRM user 'FCS2 Test' chooses to revert the state of version '1' subversion '0' of contract 'AEBP-177' to Awaiting Documentation
    When  CRM user 'FCS2 Test' chooses to revert the state of version '1' subversion '0' of contract '[ContractNo]' to Awaiting Documentation

@AcceptanceTest @InProgress
Scenario: J080 Delete Tasks for a contract
    # Delete certain CRM Tasks for a contract, dictated by State and Status
    Given there are no Tasks in CRM for version '1' of contract 'AEBP-177' with a State of 'Cancelled' and a Status of 'Cancelled'
    Given there are no Tasks in CRM for version '1' of contract '[ContractNo]' with a State of 'Completed' and a Status of 'Completed'

@AcceptanceTest @InProgress
Scenario: J081 Run the duplicate contracts in CRM monitoring job
    # Check for duplicate contracts in CRM (see Operations.DuplicateContract) 
    When  the Duplicate Contract monitoring job is run 

@AcceptanceTest @InProgress
Scenario: J082 Clear down the Operations.DuplicateContract table
    # Remove all data from the Operations.DuplicateContract table
    Given there is no data in the Operations.DuplicateContract table

@AcceptanceTest @InProgress
Scenario: J083 No duplicate contracts in CRM
    # System should not detect any duplicate contracts
    Then  there are no duplicate contracts in CRM

@AcceptanceTest @InProgress
Scenario: J084 Duplicate contracts found in CRM
    # System should detect two duplicate contracts 
    Then  there are '2' duplicate contracts in CRM as follows
    | ContractNumber | ContractVersionNumber | ContractSubVersion |
    | AEBP-110       | 1                     | 0                  |
    | NCS-110        | 1                     | 0                  |

    # System should detect one duplicate contract
    Then  there is '1' duplicate contract in CRM as follows
    | ContractNumber | ContractVersionNumber | ContractSubVersion |
    | AEBP-110       | 1                     | 0                  |

@AcceptanceTest @InProgress
Scenario: J085 Duplicate contracts exist in replicated CRM database
    # Give the replicated database time to catch up
    Then  there are '2' duplicate contracts in the replicated CRM database as follows
    | ContractNumber | ContractVersionNumber | ContractSubVersion |
    | AEBP-110       | 1                     | 0                  |
    | NCS-110        | 1                     | 0                  |

    # Give the replicated database time to catch up
    Then  there is '1' duplicate contract in the replicated CRM database as follows
    | ContractNumber | ContractVersionNumber | ContractSubVersion |
    | AEBP-110       | 1                     | 0                  |

@AcceptanceTest @InProgress
Scenario: J086 No duplicate contracts in the replicated CRM database
    # System should not detect any duplicate contracts
    Then  there are no duplicate contracts in the replicated CRM database

@AcceptanceTest @InProgress
Scenario: J087 Assign a Caseload Advisor to a Provider
    # This create as caseload advisor record in CRM but the provider legal name is blank
	# Doesn't work when pointed at MainOAT
    Given caseload advisor 'FCS2 TEST' is assigned to UKPRN '10049431'

@AcceptanceTest @InProgress
Scenario: J088 Publish to Provider
    # This has a dependency on the page object. Use J089 instead
    Given the latest version of contract 'AEBP-1260' is in a state of 'Published to Provider'

@AcceptanceTest @InProgress
Scenario: J089 Publish to Provider
#    Given the contract sub-status is updated to 'Awaiting Documentation' for contract 'xxx-0000'
#    Given the contract sub-status is updated to 'Document Merge In Progress' for contract 'xxx-0000'
#    Given the contract sub-status is updated to 'In Review' for contract 'xxx-0000'
#    Given the contract sub-status is updated to 'Awaiting Internal Approval' for contract 'xxx-0000'
#    Given the contract sub-status is updated to 'Internally Approved' for contract 'xxx-0000'
#    Given the contract sub-status is updated to 'Document transfer In Progress' for contract 'xxx-0000'
#    Given the contract sub-status is updated to 'Published to Provider' for contract 'xxx-0000'

    Given the contract sub-status is updated to 'Published to Provider' on the latest version of contract 'NCS-596'

@AcceptanceTest @InProgress
Scenario: J090 Launch WF28 in CRM to issue a contract deletion
    # Trigger WF28 in CRM to issue a delete request against v2 of the contract
   #When  a request is initiated in CRM to delete the following contracts           # <<< This line does the same as the next line, but bypasses the CRM validation
    When  User 'FCS2 Test' chooses to issue CRM workflow 'WF28' for the following contracts
    | UKPRN    | ContractNumber | ContractVersionNumber | ContractSubVersion |
    | 10017319 | LOANS-319      | 2                     | 0                  |

@AcceptanceTest @InProgress
Scenario: J091 Check subnominal details on a CRM deliverable period
    # Check the Subnominals and Amounts on the deliverable in CRM
	Then  contract version '1' subversion '0' of contract '[ContractNo]' has Deliverable Period details which include the following
    | UKPRN    | ContractNumber | AllocationRef   | DeliverableCode | Name   | ProfilePaymentAmount | ProfileSubnominal | ActualValue | ReconciliationPaymentAmount | ReconciliationSubnominal | CappedPaymentAmount | CappingSubnominal |
    | 10017807 | MAIN-807       | 16AP-807        | 1               | Aug-19 | 12500.00             | 2240005           | 0           | 0                           | ?                        | 0                   | ?                 |
    | 10017807 | MAIN-807       | 16AP-807        | 2               | Sep-19 | 0                    | ?                 | 123.00      | 567.00                      | 2240100                  | 25.00               | 2240100           |
    | 10017807 | [ContractNo]   | [AllocRef_16AP] | 2               | Oct-19 | 0                    | ?                 | 1000.00     | 750.24                      | 2240100                  | 0                   | 2240100           |
    | 10017807 | [ContractNo]   | [AllocRef_16AP] | 2               | Nov-19 | 0                    | ?                 | 999.99      | 2000.00                     | 2240100                  | 222.22              | 2240100           |

@AcceptanceTest @InProgress
Scenario: J092 Issue a non-financial amendment
    # Issue a non-financial NOTIFICATION amendment on v1 to create v2
   When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'EDSK-4294' for a non-financial VARIATION contract amendment
   # When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'EDSK-4294' for a non-financial NOTIFICATION contract amendment

@AcceptanceTest @InProgress
Scenario: J093 Inject a Levy INITIATED event to create a Levy contract with both LEVY1799 and NONLEVY2019 allocations
    # Inject data into the stub to create both allocations (J093)
    Given the following Levy event data is available in the DAS agreement stub
    | Id    | Event     | CreatedOn                | ProviderId | EmployerAccountId | 
    | 42088 | INITIATED | 2017-09-15T18:03:12.2088 | 10017088   | 28088             | 

@AcceptanceTest @InProgress
Scenario: J094 Inject a Levy INITIATED event to create a Levy contract with just a LEVY1799 allocation
    # Inject data into the stub to create just a LEVY1799 allocation (J094)
    Given the following event data in the DAS agreement stub is used to create a Levy contract with just a LEVY1799 contract allocation
    | Id    | Event     | CreatedOn                | ProviderId | EmployerAccountId | 
    | 2153  | INITIATED | 2019-11-22T09:51:44.2153 | 10017875   | 28153             | 

@AcceptanceTest @InProgress
Scenario: J095 Exorcise NLAP NewStarts parameter data for a specified UKPRN
    # Remove all trace of NLAP config values for NewStarts for a specific UKPRN (DocumentsDomain.NLAPFundingConfig) (28766)
    Given there is no NLAP NewStarts profile data in config for UKPRN '10017123'

@AcceptanceTest @InProgress
Scenario: J096 Populate NLAP NewStarts profile values
    # Set the provider config values for NLAP NewStarts for a specific UKPRN (DocumentsDomain.NLAPFundingConfig) (28766)
    Given the following NLAP NewStarts profile values exist in config
	| UKPRN    | 16-18NewStarts2021 | AdultNewStarts2021 | 16-18NewStartsEstimatedFutureFunding | AdultNewStartsEstimatedFutureFunding |
    | 10017123 | 19450.00           | 30211.00           | 750.00                               | 1020.00                              |

	# Old version
#   | UKPRN    | 16-18NewStarts2021 | AdultNewStarts2021 | 16-18TotalEstimatedNewStarts | AdultTotalEstimatedNewStarts | 16-18TotalEstimatedFunding | AdultTotalEstimatedFunding |
#   | 10017123 | 11250.00           | 34250.00           | 11750.00                     | 35675.00                     | 375625.00                  | 224101.00                  |

@AcceptanceTest @InProgress
Scenario: J097 Create a New Task
    # Create a new Task
    Given the following Tasks are created against version '1' of contract 'APPLEVY-15057' for UKPRN '10017088'
    | Task                                       | Description                    | Regarding      | Owner                     | Assigned Team            | State           | Status           |
    | Confirm Termination Initiation Approval    | 10017088 - 10017088 Co Ltd     | APPLEVY-15057  | FCS5 Test                 | Contract Managers Team   | Open            | Not Started      |

@AcceptanceTest @InProgress
Scenario: J098 Pull actuals from SLD interface (rather than DCFS DEDs)
    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

@AcceptanceTest @InProgress
Scenario: J099 Wait for Subnominal Aggs to be created in CRM
    # Check that the CRM subnominals have been created before moving on
    Then  CRM subnominals have been created for the following allocations
    | AllocationRef | Subnominal Code | Period | Payment Type   |
    | AEBR-123      | 2355800         | Jul-20 | Reconciliation |
    | AEBR-123      | 2355816         | Jul-20 | Capping        |
    | AEAL-123      | 2372165         | Jul-20 | Profile        |

@AcceptanceTest @InProgress
Scenario: J100 Clear down Summarised Actuals and Closed Collections in PaaS
    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals 
    Given there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS
  
@AcceptanceTest @InProgress
Scenario: J101 Clear down Deliverable Payments from PaaS
    # Note: Can't handle [AllocRef_xxxx]
    # Clear down PaymentSchedule.DeliverablePayment data for an allocation
    Given there are no entries in the DeliverablePayment table in PaaS for the following contract allocations
    | AllocationRef |
    | AEBR-123      |
    | AEBR-123      |

@AcceptanceTest @InProgress
Scenario: J102 Set Capping configuration rules in PolicyCache.PolicyFundingStreamPeriod
#    # Update Capping policy in config table PolicyCache.PolicyFundingStreamPeriod. Note: This is only effective if the worker role is bounced, something that the step doesn't do!
#
# Select right(FundingStreamPeriod,4) as Period, FundingStreamPeriod
#      ,(Select Case when ShouldCapPayments = '0' then 'No'
#                    when ShouldCapPayments = '1' then 'Yes'
#                    else 'Not applicable'
#               end) as CapPayments
#
#      ,(Select Case when PaymentMethod = '0' then '0= Paid Externally'
#                    when PaymentMethod = '1' then '1= Pay On Actuals'
#                    when PaymentMethod = '2' then '2= Pay On Profile'
#                    when PaymentMethod = '3' then '3= Pay On Instruction'
#                    when PaymentMethod = '4' then '4= Not Calculated or Paid'
#                    else '?= Not applicable'
#               end) as MethodOfPayment
#
#      ,(Select Case when PaymentCappingLevel = '0' then '0= Deliverable Group'
#                    when PaymentCappingLevel = '1' then '1= Contract Allocation'
#                    when PaymentCappingLevel = '2' then '2= Deliverable Line'
#                    else '?= Not applicable'
#               end) as CappingLevel
#
#      ,(Select Case when PaymentCappingPeriod = '0' then '0= Financial Year'
#                    when PaymentCappingPeriod = '1' then '1= Academic Year'
#                    when PaymentCappingPeriod = '2' then '2= Contract Allocation Duration'
#                    when PaymentCappingPeriod = '3' then '3= Academic And Financial Year'
#                    else '?= Not applicable'
#               end) as CappingPeriod
#
# from PolicyCache.PolicyFundingStreamPeriod

@AcceptanceTest @InProgress
Scenario: J103 Non-Financial amendment
    # Issue a non-financial amendment
   #When  a request is raised by advisor 'FCS8 Test' against version '2' subversion '0' of contract 'NONLG-1005' for a non-financial VARIATION contract amendment
    When  a request is raised by advisor 'FCS8 Test' against version '1' subversion '0' of contract 'NONLG-811' for a non-financial NOTIFICATION contract amendment

@AcceptanceTest @InProgress
Scenario: J104 Set document creation history details in ContractManagement.CreatedContract
    # This step INSERTS a row to the ContractManagement.CreatedContract table or, if it is there already, UPDATES it (J104)
    #  It the row is missing it doesn't wait for it to appear; it jumps right in and creates one. This results in red in 
    #    logs if the code code subsequently tries to insert a row.
    # Only use this step when there is no danger of a row being created by the code code, ie only after a contract INJECTION.
    # Don't use this step to UPDATE a row. Use J106 instead

    # Insert row with the following details (J104)
    Given the following document creation details exist in the ContractManagement.CreatedContract table
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | EDSK-066       | 1                     | 0                        | 2020-03-12 18:12:35.000 |

@AcceptanceTest @InProgress
Scenario: J105 Remove specific document creation details from ContractManagement.CreatedContract
    # Delete specific rows from the ContractManagement.CreatedContract table
	Given there are no document creation details in the ContractManagement.CreatedContract table for the following contracts
	| ContractNumber | ContractVersionNumber | ContractSubVersionNumber | 
	| EDSK-511       | 2                     | 0                        | 

@AcceptanceTest @InProgress
Scenario: J106 Set details in ContractManagement.CreatedContract. If necessary, wait for row to appear
    # This step waits for a row to be present on the ContractManagement.CreatedContract table then UPDATES it. 
    #  It does not insert a row into the table. If the row isn't there after waiting for 45 secs, the step fails. 
    # This is a GIVEN step which is used to UPDATE the CreatedDate timestamp. THEN step removed

    # Wait for row to arrive then update the CreatedDate (J106)
    #   Note: Documents are created using the system date. The following step 'corrects' this
    Given the following document creation details are present in the ContractManagement.CreatedContract table 
    | ContractNumber | ContractVersionNumber | ContractSubVersionNumber | CreatedDate             |
    | ABCD-888       | 4                     | 1                        | 2020-04-23 09:00:05.000 |

@AcceptanceTest @InProgress
Scenario: J107 Set the timestamp for each of the 2021 EDSK document templates
    # Associate a creation timestamp with a document template 
    #   Note: this step is an Upsert so DON'T change the DocumentTemplateNames

    # Set the 'base' timestamp for all the EDSK document templates (DocumentsDomain.UploadedDocumentTemplate) (J107)
    Given the following document templates have Upload timestamps as indicated
    | DocumentTemplateName                            | UploadTimestamp         |
    | EDSK2021_TAC_CFS_ITP_2020-08-01.docx            | 2020-06-18 12:00:00.000 |
    | EDSK2021_TAC_COFG_COLLEGE_2020-08-01.docx       | 2020-06-18 12:00:00.000 |
    | EDSK2021_TAC_COFG_EMPLOYER_2020-08-01.docx      | 2020-06-18 12:00:00.000 |
    | EDSK2021_TAC_COFG_HEI_2020-08-01.docx           | 2020-06-18 12:00:00.000 |
    | EDSK2021_TAC_COFG_LA_2020-08-01.docx            | 2020-06-18 12:00:00.000 |
    | EDSK2021_TAC_COFG_NMSS_2020-08-01.docx          | 2020-06-18 12:00:00.000 |
    | EDSK2021_TAC_COFG_SPI_2020-08-01.docx           | 2020-06-18 12:00:00.000 |
    | EDSK2021_TAC_COFG_TRUST_2020-08-01.docx         | 2020-06-18 12:00:00.000 |
    # 8
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
    # 14
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
    # 10
    | EDSK2021_S3ON_CFS_ITP_2020-08-01.docx           | 2020-06-18 12:00:00.000 |
    | EDSK2021_S3ON_COFG_COLLEGE_2020-08-01.docx      | 2020-06-18 12:00:00.000 |
    | EDSK2021_S3ON_COFG_EMPLOYER_2020-08-01.docx     | 2020-06-18 12:00:00.000 |
    | EDSK2021_S3ON_COFG_LA_TRUST_HEI_2020-08-01.docx | 2020-06-18 12:00:00.000 |
    | EDSK2021_S3ON_COFG_NMSS_2020-08-01.docx         | 2020-06-18 12:00:00.000 |
    | EDSK2021_S3ON_COFG_SPI_2020-08-01.docx          | 2020-06-18 12:00:00.000 |
    # 6
    | FA_EDSK2021_2020-08-01.docx                     | 2020-06-18 12:00:00.000 |
    # 1

@AcceptanceTest @InProgress
Scenario: J108 Log
    Given I retrieve the latest contract details from CRM for provider '10017101' for FundingType 'AEB' and period '1819'
    Given message 'Master Contract is [MasterContractNo] and Contract is [ContractNo]' is written to the Output window

    Given the override date is '12/11/2010'

@AcceptanceTest @InProgress
Scenario: J109 Retrieve a document from Sharepoint and check its contents
    # Retrieve parameters
    Given I retrieve the latest contract details from CRM for provider '10002314' for FundingType 'EDSK' and period '2021'

    # Check that all 6 documents have been produced in the right order, viz
    #   'Summary of Funding', then 'Main Terms and Conditions' (TAC) then Schedule 1, then Schedule 2, then 'Funding Agreement', then 'Schedule 3'
    Then  the file named '10002314_EDSK-4294_v3.pdf' in Sharepoint location 'EDSK-2021-Input-Appendices' contains the following lines in order
    """
    blah
    """

@AcceptanceTest @InProgress
Scenario: J110 Publish and approve a contract
    # Update the contract substatus to 'Published to Provider'
    And   the latest version of contract 'EDSK-4294' is in a state of 'Published to Provider'

    # Inject an SFS approval message 
    When  a contract approval message is received from SFS for version '4' actual MasterContractNumber 'ESFA-45434' and actual ContractNumber 'EDSK-4294'

   #When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1' 

@AcceptanceTest @InProgress
Scenario: J111 Issue a non-financial amendment
   #When  a request is raised by advisor 'FCS2 Test' against version '0' subversion '0' of contract 'EDSK-4294' for a non-financial VARIATION contract amendment
    When  a request is raised by advisor 'FCS2 Test' against version '2' subversion '1' of contract 'EDSK-4294' for a non-financial NOTIFICATION contract amendment

@AcceptanceTest @InProgress
Scenario: J112 Withdraw a published contract
    # Doesn't work when pointed at DevOAT
    When  the next action performed on the latest version of contract 'APPLEVY-5419' is 'Withdraw On Behalf Of Provider' with reason 'Test for story 29771' by 'FCS1 Test'

@AcceptanceTest @InProgress
Scenario: J113 Check Deliverable details in the CM feed
    # Check deliverable data in the ContractManagement Legal feed
    Then  the Legal Contract CM feed contains the following '2' deliverables
    | UKPRN    | ContractNumber | ContractVersion | AllocationRef | DeliverableCode | ParentDeliverableCode | PlannedValue | PlannedVolume | UnitCost | DeliverableName                  | DeliverableDescription        | 
    | 10017301 | APPLEVY-301    | 1               | LEVY-301      | 1               | 0                     | 0            | 0             | 0        | Total 16-18 Levy Apprenticeships | ?                             |
    | 10017301 | APPLEVY-301    | 1               | LEVY-301      | 7               | 0                     | 0            | 0             | 0        | Total Adult Levy Apprenticeships | ?                             |

@AcceptanceTest @InProgress
Scenario: J114 Set default timestamps on all EDSK2021 document templates
    # Associate a timestamp with a document template (DocumentsDomain.UploadedDocumentTemplate) (J107)
    Given the following document templates have Upload timestamps as indicated
    | DocumentTemplateName                            | UploadTimestamp         |
    | EDSK2021_TAC_CFS_ITP_2020-08-01.docx            | 2020-06-18 12:00:00.000 |
    | EDSK2021_TAC_COFG_COLLEGE_2020-08-01.docx       | 2020-06-18 12:00:00.000 |
    | EDSK2021_TAC_COFG_EMPLOYER_2020-08-01.docx      | 2020-06-18 12:00:00.000 |
    | EDSK2021_TAC_COFG_HEI_2020-08-01.docx           | 2020-06-18 12:00:00.000 |
    | EDSK2021_TAC_COFG_LA_2020-08-01.docx            | 2020-06-18 12:00:00.000 |
    | EDSK2021_TAC_COFG_NMSS_2020-08-01.docx          | 2020-06-18 12:00:00.000 |
    | EDSK2021_TAC_COFG_SPI_2020-08-01.docx           | 2020-06-18 12:00:00.000 |
    | EDSK2021_TAC_COFG_TRUST_2020-08-01.docx         | 2020-06-18 12:00:00.000 |
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
    | EDSK2021_S1_LOANS_CFS_2020-08-01.docx           | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_LOANS_COFG.docx                     | 2020-06-18 12:00:00.000 |
    | EDSK2021_S1_LOANS_COFG_2020-08-01.docx          | 2020-06-18 12:00:00.000 |
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
    | EDSK2021_S3ON_CFS_ITP_2020-08-01.docx           | 2020-06-18 12:00:00.000 |
    | EDSK2021_S3ON_COFG_COLLEGE_2020-08-01.docx      | 2020-06-18 12:00:00.000 |
    | EDSK2021_S3ON_COFG_EMPLOYER_2020-08-01.docx     | 2020-06-18 12:00:00.000 |
    | EDSK2021_S3ON_COFG_LA_TRUST_HEI_2020-08-01.docx | 2020-06-18 12:00:00.000 |
    | EDSK2021_S3ON_COFG_NMSS_2020-08-01.docx         | 2020-06-18 12:00:00.000 |
    | EDSK2021_S3ON_COFG_SPI_2020-08-01.docx          | 2020-06-18 12:00:00.000 |
    | FA_EDSK2021_2020-08-01.docx                     | 2020-06-18 12:00:00.000 |

@AcceptanceTest @InProgress
Scenario: J115 Clear down Sector-base Work Academies config 
    # Remove all Sector-based Work Academies config values for a specific UKPRN (DocumentsDomain.ContractReferenceConfig) (30680)
    Given there are no Sector-based Work Academies profile values in config for UKPRN '10017123'

@AcceptanceTest @InProgress
Scenario: J116 Insert or update Sector-based Work Academies config
    # Upsert the provider config values for Sector-based Work Academies for a specific UKPRN and FSP (DocumentsDomain.ContractReferenceConfig) (30680)
    Given the following Sector-based Work Academies profile values exist in config
    | UKPRN    | FSPCode       | Aug20-Mar21 | Apr21-Jul21 |
    | 10017123 | AEB-AS2021    | 0.00        | 1250.00     |
    | 10017123 | AEBC-ASCL2021 | 5000.00     | 0.00        | 

@AcceptanceTest @InProgress
Scenario: J117 Set up 1920 Final Funding Claims
    # Cleardown DEDs/SLD and PaaS
    Given there is no data in the funding claim stub or PAAS tables for the following claim type and period
    | ClaimTypeName | Period |
    | Final         | 1920   |

    # Cleardown CRM
   #And   there is no data in the CRM funding claim reconciliation tables
    And   there is no data in the CRM funding claim reconciliation tables for the following UKPRNs
    | UKPRN    |
    | 10002118 |
    | 10003207 |
    | 10003593 |
    | 10003755 |
    | 10004686 |
    | 10005669 |
    | 10006173 |
    | 10006378 |
    | 10007594 |
    | 10007945 |
    | 10009439 |
    | 10021684 |
    | 10022358 |
    | 10024962 |
    | 10036143 |
    | 10038939 |

    # Cleardown FCR publications in PaaS
    And   there is no data in the PaymentSchedule.PublishedPayableFcrAllocation table for the following allocations
    | AllocationRef |
    | AEAL-1129     |
    | AEAL-1139     |
    | AEAL-1144     |
    | AEAL-1150     |
    | AEAL-1169     |
    | AEAL-1183     |
    | AEAL-1189     |
    | AEAL-1193     |
    | AECA-1002     |
    | AECA-1084     |
    | AECA-1089     |
    | AECA-1130     |
    | AECA-1146     |
    | AECA-1156     |
    | AECA-1183     |
    | AECA-1408     |
    | AECT-1001     |
    | AECT-1031     |
    | AECT-1033     |
    | AECT-1044     |
    | AECT-1049     |
    | AECT-1056     |
    | AECT-1062     |
    | AECT-1104     |
    | AETL-1180     |
    | AETL-1194     |
    | AETL-1200     |
    | AETL-1214     |
    | AETL-1221     |
    | AETL-1229     |
    | AETL-1255     |
    | AETL-1266     |
    | ALLC-4312     |
    | ALLC-4394     |
    | ALLC-4399     |
    | ALLC-4439     |
    | ALLC-4455     |
    | ALLC-4465     |
    | ALLC-4490     |
    | ALLC-4623     |




    # Set up claim data from DC for a 'Final'
    And   funding claim data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | HasBeenSigned |
    | ORG0000572     | 10002118 | 3                  | Final         | AY             | 1920   | False         |
    | ORG0000600     | 10003207 | 3                  | Final         | AY             | 1920   | False         |
    | ORG0000620     | 10003593 | 3                  | Final         | AY             | 1920   | False         |
    | ORG0000170     | 10003755 | 3                  | Final         | AY             | 1920   | False         |
    | ORG0000210     | 10004686 | 3                  | Final         | AY             | 1920   | False         |
    | ORG0000251     | 10005669 | 3                  | Final         | AY             | 1920   | False         |
    | ORG0000711     | 10006173 | 3                  | Final         | AY             | 1920   | False         |
    | ORG0000296     | 10006378 | 3                  | Final         | AY             | 1920   | False         |
    | ORG0000970     | 10007594 | 3                  | Final         | AY             | 1920   | False         |
    | ORG0000371     | 10007945 | 3                  | Final         | AY             | 1920   | False         |
    | ORG0000376     | 10009439 | 3                  | Final         | AY             | 1920   | False         |
    | ORG0000832     | 10021684 | 3                  | Final         | AY             | 1920   | False         |
    | ORG0000846     | 10022358 | 3                  | Final         | AY             | 1920   | False         |
    | ORG0000384     | 10024962 | 3                  | Final         | AY             | 1920   | False         |
    | ORG0000387     | 10036143 | 3                  | Final         | AY             | 1920   | False         |
    | ORG0003012     | 10038939 | 3                  | Final         | AY             | 1920   | False         |

    And   allocation data is present in the funding claim stub as follows 
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | FundingStreamPeriodCode | 
    | ORG0000572     | 10002118 | 3                  | Final         | AY             | 1920   | AETL-1180     | AEB-19TRLS1920          |
    | ORG0000572     | 10002118 | 3                  | Final         | AY             | 1920   | AEAL-1129     | AEB-ASLS1920            |
    | ORG0000600     | 10003207 | 3                  | Final         | AY             | 1920   | AETL-1194     | AEB-19TRLS1920          |
    | ORG0000600     | 10003207 | 3                  | Final         | AY             | 1920   | AEAL-1139     | AEB-ASLS1920            |
    | ORG0000620     | 10003593 | 3                  | Final         | AY             | 1920   | AETL-1214     | AEB-19TRLS1920          |
    | ORG0000620     | 10003593 | 3                  | Final         | AY             | 1920   | AEAL-1150     | AEB-ASLS1920            |
    | ORG0000170     | 10003755 | 3                  | Final         | AY             | 1920   | AECT-1031     | AEBC-19TRN1920          |
    | ORG0000170     | 10003755 | 3                  | Final         | AY             | 1920   | AECA-1084     | AEBC-ASCL1920           |
    | ORG0000170     | 10003755 | 3                  | Final         | AY             | 1920   | ALLC-4394     | ALLBC1920               |
    | ORG0000210     | 10004686 | 3                  | Final         | AY             | 1920   | AECT-1049     | AEBC-19TRN1920          |
    | ORG0000210     | 10004686 | 3                  | Final         | AY             | 1920   | AECA-1146     | AEBC-ASCL1920           |
    | ORG0000210     | 10004686 | 3                  | Final         | AY             | 1920   | ALLC-4455     | ALLBC1920               |
    | ORG0000251     | 10005669 | 3                  | Final         | AY             | 1920   | AECT-1001     | AEBC-19TRN1920          |
    | ORG0000251     | 10005669 | 3                  | Final         | AY             | 1920   | AECA-1002     | AEBC-ASCL1920           |
    | ORG0000251     | 10005669 | 3                  | Final         | AY             | 1920   | ALLC-4312     | ALLBC1920               |
    | ORG0000711     | 10006173 | 3                  | Final         | AY             | 1920   | AETL-1200     | AEB-19TRLS1920          |
    | ORG0000711     | 10006173 | 3                  | Final         | AY             | 1920   | AEAL-1144     | AEB-ASLS1920            |
    | ORG0000296     | 10006378 | 3                  | Final         | AY             | 1920   | AECT-1044     | AEBC-19TRN1920          |
    | ORG0000296     | 10006378 | 3                  | Final         | AY             | 1920   | AECA-1130     | AEBC-ASCL1920           |
    | ORG0000296     | 10006378 | 3                  | Final         | AY             | 1920   | ALLC-4439     | ALLBC1920               |
    | ORG0000970     | 10007594 | 3                  | Final         | AY             | 1920   | AETL-1221     | AEB-19TRLS1920          |
    | ORG0000970     | 10007594 | 3                  | Final         | AY             | 1920   | AEAL-1193     | AEB-ASLS1920            |
    | ORG0000371     | 10007945 | 3                  | Final         | AY             | 1920   | AECT-1056     | AEBC-19TRN1920          |
    | ORG0000371     | 10007945 | 3                  | Final         | AY             | 1920   | AECA-1156     | AEBC-ASCL1920           |
    | ORG0000371     | 10007945 | 3                  | Final         | AY             | 1920   | ALLC-4465     | ALLBC1920               |
    | ORG0000376     | 10009439 | 3                  | Final         | AY             | 1920   | AECT-1033     | AEBC-19TRN1920          |
    | ORG0000376     | 10009439 | 3                  | Final         | AY             | 1920   | AECA-1089     | AEBC-ASCL1920           |
    | ORG0000376     | 10009439 | 3                  | Final         | AY             | 1920   | ALLC-4399     | ALLBC1920               |
    | ORG0000832     | 10021684 | 3                  | Final         | AY             | 1920   | AETL-1229     | AEB-19TRLS1920          |
    | ORG0000832     | 10021684 | 3                  | Final         | AY             | 1920   | AEAL-1169     | AEB-ASLS1920            |
    | ORG0000846     | 10022358 | 3                  | Final         | AY             | 1920   | AETL-1266     | AEB-19TRLS1920          |
    | ORG0000846     | 10022358 | 3                  | Final         | AY             | 1920   | AEAL-1189     | AEB-ASLS1920            |
    | ORG0000384     | 10024962 | 3                  | Final         | AY             | 1920   | AECT-1104     | AEBC-19TRN1920          |
    | ORG0000384     | 10024962 | 3                  | Final         | AY             | 1920   | AECA-1408     | AEBC-ASCL1920           |
    | ORG0000384     | 10024962 | 3                  | Final         | AY             | 1920   | ALLC-4623     | ALLBC1920               |
    | ORG0000387     | 10036143 | 3                  | Final         | AY             | 1920   | AECT-1062     | AEBC-19TRN1920          |
    | ORG0000387     | 10036143 | 3                  | Final         | AY             | 1920   | AECA-1183     | AEBC-ASCL1920           |
    | ORG0000387     | 10036143 | 3                  | Final         | AY             | 1920   | ALLC-4490     | ALLBC1920               |
    | ORG0003012     | 10038939 | 3                  | Final         | AY             | 1920   | AETL-1255     | AEB-19TRLS1920          |
    | ORG0003012     | 10038939 | 3                  | Final         | AY             | 1920   | AEAL-1183     | AEB-ASLS1920            |

    And   deliverable data is present in the funding claim stub as follows
    | OrganisationId | UKPRN    | ClaimVersionNumber | ClaimTypeName | PeriodTypeCode | Period | AllocationRef | DeliverableCode | ActualValue | ForecastValue | AdjustmentValue | TotalValue |
    | ORG0000572     | 10002118 | 3                  | Final         | AY             | 1920   | AETL-1180     |  2              | 1771.00     | 0.00          | 0.00            | 1771.00    |
    | ORG0000572     | 10002118 | 3                  | Final         | AY             | 1920   | AETL-1180     |  3              | 1160.00     | 0.00          | 0.00            | 1160.00    |
    #                                                                                                                                  Planned Value £ 3471.00       Claimed Value £ 2931.00     
    | ORG0000572     | 10002118 | 3                  | Final         | AY             | 1920   | AEAL-1129     |  2              | 260.00      | 0.00          | 0.00            | 260.00     |
    | ORG0000572     | 10002118 | 3                  | Final         | AY             | 1920   | AEAL-1129     |  3              | 168.00      | 0.00          | 0.00            | 168.00     |
    | ORG0000572     | 10002118 | 3                  | Final         | AY             | 1920   | AEAL-1129     |  4              | 126.00      | 0.00          | 0.00            | 126.00     |
    | ORG0000572     | 10002118 | 3                  | Final         | AY             | 1920   | AEAL-1129     |  5              | 106.00      | 0.00          | 0.00            | 106.00     |
    #                                                                                                                                  Planned Value £ 517.00        Claimed Value £ 660.00      
    | ORG0000600     | 10003207 | 3                  | Final         | AY             | 1920   | AETL-1194     |  2              | 784.00      | 0.00          | 0.00            | 784.00     |
    | ORG0000600     | 10003207 | 3                  | Final         | AY             | 1920   | AETL-1194     |  3              | 564.00      | 0.00          | 0.00            | 564.00     |
    #                                                                                                                                  Planned Value £ 1649.00       Claimed Value £ 1348.00     
    | ORG0000600     | 10003207 | 3                  | Final         | AY             | 1920   | AEAL-1139     |  2              | 1931.00     | 0.00          | 0.00            | 1931.00    |
    | ORG0000600     | 10003207 | 3                  | Final         | AY             | 1920   | AEAL-1139     |  3              | 1274.00     | 0.00          | 0.00            | 1274.00    |
    | ORG0000600     | 10003207 | 3                  | Final         | AY             | 1920   | AEAL-1139     |  4              | 893.00      | 0.00          | 0.00            | 893.00     |
    | ORG0000600     | 10003207 | 3                  | Final         | AY             | 1920   | AEAL-1139     |  5              | 742.00      | 0.00          | 0.00            | 742.00     |
    #                                                                                                                                  Planned Value £ 3745.00       Claimed Value £ 4840.00     
    | ORG0000620     | 10003593 | 3                  | Final         | AY             | 1920   | AETL-1214     |  2              | 536.00      | 0.00          | 0.00            | 536.00     |
    | ORG0000620     | 10003593 | 3                  | Final         | AY             | 1920   | AETL-1214     |  3              | 355.00      | 0.00          | 0.00            | 355.00     |
    #                                                                                                                                  Planned Value £ 1036.00       Claimed Value £ 891.00      
    | ORG0000620     | 10003593 | 3                  | Final         | AY             | 1920   | AEAL-1150     |  2              | 2053.00     | 0.00          | 0.00            | 2053.00    |
    | ORG0000620     | 10003593 | 3                  | Final         | AY             | 1920   | AEAL-1150     |  3              | 1450.00     | 0.00          | 0.00            | 1450.00    |
    | ORG0000620     | 10003593 | 3                  | Final         | AY             | 1920   | AEAL-1150     |  4              | 1078.00     | 0.00          | 0.00            | 1078.00    |
    | ORG0000620     | 10003593 | 3                  | Final         | AY             | 1920   | AEAL-1150     |  5              | 794.00      | 0.00          | 0.00            | 794.00     |
    #                                                                                                                                  Planned Value £ 4159.00       Claimed Value £ 5375.00     
    | ORG0000170     | 10003755 | 3                  | Final         | AY             | 1920   | AECT-1031     |  2              | 34245.00    | 0.00          | 0.00            | 34245.00   |
    | ORG0000170     | 10003755 | 3                  | Final         | AY             | 1920   | AECT-1031     |  3              | 21550.00    | 0.00          | 0.00            | 21550.00   |
    | ORG0000170     | 10003755 | 3                  | Final         | AY             | 1920   | AECT-1031     |  4              | 16426.00    | 0.00          | 0.00            | 16426.00   |
    | ORG0000170     | 10003755 | 3                  | Final         | AY             | 1920   | AECT-1031     |  5              | 13458.00    | 0.00          | 0.00            | 13458.00   |
    #                                                                                                                                  Planned Value £ 65544.00      Claimed Value £ 85679.00    
    | ORG0000170     | 10003755 | 3                  | Final         | AY             | 1920   | AECA-1084     |  3              | 431185.00   | 0.00          | 0.00            | 431185.00  |
    | ORG0000170     | 10003755 | 3                  | Final         | AY             | 1920   | AECA-1084     |  4              | 341633.00   | 0.00          | 0.00            | 341633.00  |
    | ORG0000170     | 10003755 | 3                  | Final         | AY             | 1920   | AECA-1084     |  5              | 269955.00   | 0.00          | 0.00            | 269955.00  |
    | ORG0000170     | 10003755 | 3                  | Final         | AY             | 1920   | AECA-1084     |  6              | 221114.00   | 0.00          | 0.00            | 221114.00  |
    | ORG0000170     | 10003755 | 3                  | Final         | AY             | 1920   | AECA-1084     |  7              | 195803.00   | 0.00          | 0.00            | 195803.00  |
    | ORG0000170     | 10003755 | 3                  | Final         | AY             | 1920   | AECA-1084     |  8              | 171753.00   | 0.00          | 0.00            | 171753.00  |
    | ORG0000170     | 10003755 | 3                  | Final         | AY             | 1920   | AECA-1084     |  9              | 146892.00   | 0.00          | 0.00            | 146892.00  |
    #                                                                                                                                  Planned Value £ 1354014.00    Claimed Value £ 1778335.00  
    | ORG0000170     | 10003755 | 3                  | Final         | AY             | 1920   | ALLC-4394     |  2              | 465884.00   | 0.00          | 0.00            | 465884.00  |
    | ORG0000170     | 10003755 | 3                  | Final         | AY             | 1920   | ALLC-4394     |  3              | 328072.00   | 0.00          | 0.00            | 328072.00  |
    | ORG0000170     | 10003755 | 3                  | Final         | AY             | 1920   | ALLC-4394     |  4              | 245930.00   | 0.00          | 0.00            | 245930.00  |
    | ORG0000170     | 10003755 | 3                  | Final         | AY             | 1920   | ALLC-4394     |  5              | 192257.00   | 0.00          | 0.00            | 192257.00  |
    | ORG0000170     | 10003755 | 3                  | Final         | AY             | 1920   | ALLC-4394     |  6              | 166517.00   | 0.00          | 0.00            | 166517.00  |
    | ORG0000170     | 10003755 | 3                  | Final         | AY             | 1920   | ALLC-4394     |  7              | 141707.00   | 0.00          | 0.00            | 141707.00  |
    | ORG0000170     | 10003755 | 3                  | Final         | AY             | 1920   | ALLC-4394     |  8              | 115846.00   | 0.00          | 0.00            | 115846.00  |
    #                                                                                                                                  Planned Value £ 952793.00     Claimed Value £ 1656213.00  
    | ORG0000210     | 10004686 | 3                  | Final         | AY             | 1920   | AECT-1049     |  2              | 141731.00   | 0.00          | 0.00            | 141731.00  |
    | ORG0000210     | 10004686 | 3                  | Final         | AY             | 1920   | AECT-1049     |  3              | 97128.00    | 0.00          | 0.00            | 97128.00   |
    | ORG0000210     | 10004686 | 3                  | Final         | AY             | 1920   | AECT-1049     |  4              | 67729.00    | 0.00          | 0.00            | 67729.00   |
    | ORG0000210     | 10004686 | 3                  | Final         | AY             | 1920   | AECT-1049     |  5              | 55796.00    | 0.00          | 0.00            | 55796.00   |
    #                                                                                                                                  Planned Value £ 278039.00     Claimed Value £ 362384.00   
    | ORG0000210     | 10004686 | 3                  | Final         | AY             | 1920   | AECA-1146     |  3              | 503154.00   | 0.00          | 0.00            | 503154.00  |
    | ORG0000210     | 10004686 | 3                  | Final         | AY             | 1920   | AECA-1146     |  4              | 412447.00   | 0.00          | 0.00            | 412447.00  |
    | ORG0000210     | 10004686 | 3                  | Final         | AY             | 1920   | AECA-1146     |  5              | 319799.00   | 0.00          | 0.00            | 319799.00  |
    | ORG0000210     | 10004686 | 3                  | Final         | AY             | 1920   | AECA-1146     |  6              | 249202.00   | 0.00          | 0.00            | 249202.00  |
    | ORG0000210     | 10004686 | 3                  | Final         | AY             | 1920   | AECA-1146     |  7              | 226161.00   | 0.00          | 0.00            | 226161.00  |
    | ORG0000210     | 10004686 | 3                  | Final         | AY             | 1920   | AECA-1146     |  8              | 188558.00   | 0.00          | 0.00            | 188558.00  |
    | ORG0000210     | 10004686 | 3                  | Final         | AY             | 1920   | AECA-1146     |  9              | 167659.00   | 0.00          | 0.00            | 167659.00  |
    #                                                                                                                                  Planned Value £ 1571315.00    Claimed Value £ 2066980.00  
    | ORG0000210     | 10004686 | 3                  | Final         | AY             | 1920   | ALLC-4455     |  2              | 50898.00    | 0.00          | 0.00            | 50898.00   |
    | ORG0000210     | 10004686 | 3                  | Final         | AY             | 1920   | ALLC-4455     |  3              | 32237.00    | 0.00          | 0.00            | 32237.00   |
    | ORG0000210     | 10004686 | 3                  | Final         | AY             | 1920   | ALLC-4455     |  4              | 23588.00    | 0.00          | 0.00            | 23588.00   |
    | ORG0000210     | 10004686 | 3                  | Final         | AY             | 1920   | ALLC-4455     |  5              | 19364.00    | 0.00          | 0.00            | 19364.00   |
    | ORG0000210     | 10004686 | 3                  | Final         | AY             | 1920   | ALLC-4455     |  6              | 16279.00    | 0.00          | 0.00            | 16279.00   |
    | ORG0000210     | 10004686 | 3                  | Final         | AY             | 1920   | ALLC-4455     |  7              | 13839.00    | 0.00          | 0.00            | 13839.00   |
    | ORG0000210     | 10004686 | 3                  | Final         | AY             | 1920   | ALLC-4455     |  8              | 12909.00    | 0.00          | 0.00            | 12909.00   |
    #                                                                                                                                  Planned Value £ 98843.00      Claimed Value £ 169114.00   
    | ORG0000251     | 10005669 | 3                  | Final         | AY             | 1920   | AECT-1001     |  2              | 6456.00     | 0.00          | 0.00            | 6456.00    |
    | ORG0000251     | 10005669 | 3                  | Final         | AY             | 1920   | AECT-1001     |  3              | 4066.00     | 0.00          | 0.00            | 4066.00    |
    | ORG0000251     | 10005669 | 3                  | Final         | AY             | 1920   | AECT-1001     |  4              | 3012.00     | 0.00          | 0.00            | 3012.00    |
    | ORG0000251     | 10005669 | 3                  | Final         | AY             | 1920   | AECT-1001     |  5              | 2380.00     | 0.00          | 0.00            | 2380.00    |
    #                                                                                                                                  Planned Value £ 12322.00      Claimed Value £ 15914.00    
    | ORG0000251     | 10005669 | 3                  | Final         | AY             | 1920   | AECA-1002     |  3              | 47713.00    | 0.00          | 0.00            | 47713.00   |
    | ORG0000251     | 10005669 | 3                  | Final         | AY             | 1920   | AECA-1002     |  4              | 37576.00    | 0.00          | 0.00            | 37576.00   |
    | ORG0000251     | 10005669 | 3                  | Final         | AY             | 1920   | AECA-1002     |  5              | 29360.00    | 0.00          | 0.00            | 29360.00   |
    | ORG0000251     | 10005669 | 3                  | Final         | AY             | 1920   | AECA-1002     |  6              | 24473.00    | 0.00          | 0.00            | 24473.00   |
    | ORG0000251     | 10005669 | 3                  | Final         | AY             | 1920   | AECA-1002     |  7              | 21612.00    | 0.00          | 0.00            | 21612.00   |
    | ORG0000251     | 10005669 | 3                  | Final         | AY             | 1920   | AECA-1002     |  8              | 18194.00    | 0.00          | 0.00            | 18194.00   |
    | ORG0000251     | 10005669 | 3                  | Final         | AY             | 1920   | AECA-1002     |  9              | 16678.00    | 0.00          | 0.00            | 16678.00   |
    #                                                                                                                                  Planned Value £ 148134.00     Claimed Value £ 195606.00   
    | ORG0000251     | 10005669 | 3                  | Final         | AY             | 1920   | ALLC-4312     |  2              | 37600.00    | 0.00          | 0.00            | 37600.00   |
    | ORG0000251     | 10005669 | 3                  | Final         | AY             | 1920   | ALLC-4312     |  3              | 25011.00    | 0.00          | 0.00            | 25011.00   |
    | ORG0000251     | 10005669 | 3                  | Final         | AY             | 1920   | ALLC-4312     |  4              | 19528.00    | 0.00          | 0.00            | 19528.00   |
    | ORG0000251     | 10005669 | 3                  | Final         | AY             | 1920   | ALLC-4312     |  5              | 14843.00    | 0.00          | 0.00            | 14843.00   |
    | ORG0000251     | 10005669 | 3                  | Final         | AY             | 1920   | ALLC-4312     |  6              | 12856.00    | 0.00          | 0.00            | 12856.00   |
    | ORG0000251     | 10005669 | 3                  | Final         | AY             | 1920   | ALLC-4312     |  7              | 11515.00    | 0.00          | 0.00            | 11515.00   |
    | ORG0000251     | 10005669 | 3                  | Final         | AY             | 1920   | ALLC-4312     |  8              | 9452.00     | 0.00          | 0.00            | 9452.00    |
    #                                                                                                                                  Planned Value £ 77467.00      Claimed Value £ 130805.00   
    | ORG0000711     | 10006173 | 3                  | Final         | AY             | 1920   | AETL-1200     |  2              | 644.00      | 0.00          | 0.00            | 644.00     |
    | ORG0000711     | 10006173 | 3                  | Final         | AY             | 1920   | AETL-1200     |  3              | 412.00      | 0.00          | 0.00            | 412.00     |
    #                                                                                                                                  Planned Value £ 1254.00       Claimed Value £ 1056.00     
    | ORG0000711     | 10006173 | 3                  | Final         | AY             | 1920   | AEAL-1144     |  2              | 525.00      | 0.00          | 0.00            | 525.00     |
    | ORG0000711     | 10006173 | 3                  | Final         | AY             | 1920   | AEAL-1144     |  3              | 372.00      | 0.00          | 0.00            | 372.00     |
    | ORG0000711     | 10006173 | 3                  | Final         | AY             | 1920   | AEAL-1144     |  4              | 271.00      | 0.00          | 0.00            | 271.00     |
    | ORG0000711     | 10006173 | 3                  | Final         | AY             | 1920   | AEAL-1144     |  5              | 217.00      | 0.00          | 0.00            | 217.00     |
    #                                                                                                                                  Planned Value £ 1073.00       Claimed Value £ 1385.00     
    | ORG0000296     | 10006378 | 3                  | Final         | AY             | 1920   | AECT-1044     |  2              | 379751.00   | 0.00          | 0.00            | 379751.00  |
    | ORG0000296     | 10006378 | 3                  | Final         | AY             | 1920   | AECT-1044     |  3              | 244740.00   | 0.00          | 0.00            | 244740.00  |
    | ORG0000296     | 10006378 | 3                  | Final         | AY             | 1920   | AECT-1044     |  4              | 192411.00   | 0.00          | 0.00            | 192411.00  |
    | ORG0000296     | 10006378 | 3                  | Final         | AY             | 1920   | AECT-1044     |  5              | 155970.00   | 0.00          | 0.00            | 155970.00  |
    #                                                                                                                                  Planned Value £ 764976.00     Claimed Value £ 972872.00   
    | ORG0000296     | 10006378 | 3                  | Final         | AY             | 1920   | AECA-1130     |  3              | 371164.00   | 0.00          | 0.00            | 371164.00  |
    | ORG0000296     | 10006378 | 3                  | Final         | AY             | 1920   | AECA-1130     |  4              | 276264.00   | 0.00          | 0.00            | 276264.00  |
    | ORG0000296     | 10006378 | 3                  | Final         | AY             | 1920   | AECA-1130     |  5              | 203642.00   | 0.00          | 0.00            | 203642.00  |
    | ORG0000296     | 10006378 | 3                  | Final         | AY             | 1920   | AECA-1130     |  6              | 178982.00   | 0.00          | 0.00            | 178982.00  |
    | ORG0000296     | 10006378 | 3                  | Final         | AY             | 1920   | AECA-1130     |  7              | 159107.00   | 0.00          | 0.00            | 159107.00  |
    | ORG0000296     | 10006378 | 3                  | Final         | AY             | 1920   | AECA-1130     |  8              | 132725.00   | 0.00          | 0.00            | 132725.00  |
    | ORG0000296     | 10006378 | 3                  | Final         | AY             | 1920   | AECA-1130     |  9              | 120920.00   | 0.00          | 0.00            | 120920.00  |
    #                                                                                                                                  Planned Value £ 1069257.00    Claimed Value £ 1442804.00  
    | ORG0000296     | 10006378 | 3                  | Final         | AY             | 1920   | ALLC-4439     |  2              | 15815.00    | 0.00          | 0.00            | 15815.00   |
    | ORG0000296     | 10006378 | 3                  | Final         | AY             | 1920   | ALLC-4439     |  3              | 10555.00    | 0.00          | 0.00            | 10555.00   |
    | ORG0000296     | 10006378 | 3                  | Final         | AY             | 1920   | ALLC-4439     |  4              | 7876.00     | 0.00          | 0.00            | 7876.00    |
    | ORG0000296     | 10006378 | 3                  | Final         | AY             | 1920   | ALLC-4439     |  5              | 6232.00     | 0.00          | 0.00            | 6232.00    |
    | ORG0000296     | 10006378 | 3                  | Final         | AY             | 1920   | ALLC-4439     |  6              | 5220.00     | 0.00          | 0.00            | 5220.00    |
    | ORG0000296     | 10006378 | 3                  | Final         | AY             | 1920   | ALLC-4439     |  7              | 4413.00     | 0.00          | 0.00            | 4413.00    |
    | ORG0000296     | 10006378 | 3                  | Final         | AY             | 1920   | ALLC-4439     |  8              | 3777.00     | 0.00          | 0.00            | 3777.00    |
    #                                                                                                                                  Planned Value £ 31624.00      Claimed Value £ 53888.00    
    | ORG0000970     | 10007594 | 3                  | Final         | AY             | 1920   | AETL-1221     |  2              | 1328.00     | 0.00          | 0.00            | 1328.00    |
    | ORG0000970     | 10007594 | 3                  | Final         | AY             | 1920   | AETL-1221     |  3              | 952.00      | 0.00          | 0.00            | 952.00     |
    #                                                                                                                                  Planned Value £ 2727.00       Claimed Value £ 2280.00     
    | ORG0000970     | 10007594 | 3                  | Final         | AY             | 1920   | AEAL-1193     |  2              | 444.00      | 0.00          | 0.00            | 444.00     |
    | ORG0000970     | 10007594 | 3                  | Final         | AY             | 1920   | AEAL-1193     |  3              | 306.00      | 0.00          | 0.00            | 306.00     |
    | ORG0000970     | 10007594 | 3                  | Final         | AY             | 1920   | AEAL-1193     |  4              | 229.00      | 0.00          | 0.00            | 229.00     |
    | ORG0000970     | 10007594 | 3                  | Final         | AY             | 1920   | AEAL-1193     |  5              | 185.00      | 0.00          | 0.00            | 185.00     |
    #                                                                                                                                  Planned Value £ 930.00        Claimed Value £ 1164.00     
    | ORG0000371     | 10007945 | 3                  | Final         | AY             | 1920   | AECT-1056     |  2              | 6092.00     | 0.00          | 0.00            | 6092.00    |
    | ORG0000371     | 10007945 | 3                  | Final         | AY             | 1920   | AECT-1056     |  3              | 4195.00     | 0.00          | 0.00            | 4195.00    |
    | ORG0000371     | 10007945 | 3                  | Final         | AY             | 1920   | AECT-1056     |  4              | 3078.00     | 0.00          | 0.00            | 3078.00    |
    | ORG0000371     | 10007945 | 3                  | Final         | AY             | 1920   | AECT-1056     |  5              | 2556.00     | 0.00          | 0.00            | 2556.00    |
    #                                                                                                                                  Planned Value £ 12620.00      Claimed Value £ 15921.00    
    | ORG0000371     | 10007945 | 3                  | Final         | AY             | 1920   | AECA-1156     |  3              | 951084.00   | 0.00          | 0.00            | 951084.00  |
    | ORG0000371     | 10007945 | 3                  | Final         | AY             | 1920   | AECA-1156     |  4              | 685911.00   | 0.00          | 0.00            | 685911.00  |
    | ORG0000371     | 10007945 | 3                  | Final         | AY             | 1920   | AECA-1156     |  5              | 593181.00   | 0.00          | 0.00            | 593181.00  |
    | ORG0000371     | 10007945 | 3                  | Final         | AY             | 1920   | AECA-1156     |  6              | 480866.00   | 0.00          | 0.00            | 480866.00  |
    | ORG0000371     | 10007945 | 3                  | Final         | AY             | 1920   | AECA-1156     |  7              | 406147.00   | 0.00          | 0.00            | 406147.00  |
    | ORG0000371     | 10007945 | 3                  | Final         | AY             | 1920   | AECA-1156     |  8              | 351272.00   | 0.00          | 0.00            | 351272.00  |
    | ORG0000371     | 10007945 | 3                  | Final         | AY             | 1920   | AECA-1156     |  9              | 303304.00   | 0.00          | 0.00            | 303304.00  |
    #                                                                                                                                  Planned Value £ 2841301.00    Claimed Value £ 3771765.00  
    | ORG0000371     | 10007945 | 3                  | Final         | AY             | 1920   | ALLC-4465     |  2              | 91958.00    | 0.00          | 0.00            | 91958.00   |
    | ORG0000371     | 10007945 | 3                  | Final         | AY             | 1920   | ALLC-4465     |  3              | 59372.00    | 0.00          | 0.00            | 59372.00   |
    | ORG0000371     | 10007945 | 3                  | Final         | AY             | 1920   | ALLC-4465     |  4              | 45843.00    | 0.00          | 0.00            | 45843.00   |
    | ORG0000371     | 10007945 | 3                  | Final         | AY             | 1920   | ALLC-4465     |  5              | 36111.00    | 0.00          | 0.00            | 36111.00   |
    | ORG0000371     | 10007945 | 3                  | Final         | AY             | 1920   | ALLC-4465     |  6              | 30798.00    | 0.00          | 0.00            | 30798.00   |
    | ORG0000371     | 10007945 | 3                  | Final         | AY             | 1920   | ALLC-4465     |  7              | 24318.00    | 0.00          | 0.00            | 24318.00   |
    | ORG0000371     | 10007945 | 3                  | Final         | AY             | 1920   | ALLC-4465     |  8              | 21707.00    | 0.00          | 0.00            | 21707.00   |
    #                                                                                                                                  Planned Value £ 178839.00     Claimed Value £ 310107.00   
    | ORG0000376     | 10009439 | 3                  | Final         | AY             | 1920   | AECT-1033     |  2              | 3791.00     | 0.00          | 0.00            | 3791.00    |
    | ORG0000376     | 10009439 | 3                  | Final         | AY             | 1920   | AECT-1033     |  3              | 2536.00     | 0.00          | 0.00            | 2536.00    |
    | ORG0000376     | 10009439 | 3                  | Final         | AY             | 1920   | AECT-1033     |  4              | 1946.00     | 0.00          | 0.00            | 1946.00    |
    | ORG0000376     | 10009439 | 3                  | Final         | AY             | 1920   | AECT-1033     |  5              | 1525.00     | 0.00          | 0.00            | 1525.00    |
    #                                                                                                                                  Planned Value £ 7921.00       Claimed Value £ 9798.00     
    | ORG0000376     | 10009439 | 3                  | Final         | AY             | 1920   | AECA-1089     |  3              | 48111.00    | 0.00          | 0.00            | 48111.00   |
    | ORG0000376     | 10009439 | 3                  | Final         | AY             | 1920   | AECA-1089     |  4              | 38121.00    | 0.00          | 0.00            | 38121.00   |
    | ORG0000376     | 10009439 | 3                  | Final         | AY             | 1920   | AECA-1089     |  5              | 30862.00    | 0.00          | 0.00            | 30862.00   |
    | ORG0000376     | 10009439 | 3                  | Final         | AY             | 1920   | AECA-1089     |  6              | 25432.00    | 0.00          | 0.00            | 25432.00   |
    | ORG0000376     | 10009439 | 3                  | Final         | AY             | 1920   | AECA-1089     |  7              | 22414.00    | 0.00          | 0.00            | 22414.00   |
    | ORG0000376     | 10009439 | 3                  | Final         | AY             | 1920   | AECA-1089     |  8              | 18196.00    | 0.00          | 0.00            | 18196.00   |
    | ORG0000376     | 10009439 | 3                  | Final         | AY             | 1920   | AECA-1089     |  9              | 16360.00    | 0.00          | 0.00            | 16360.00   |
    #                                                                                                                                  Planned Value £ 151928.00     Claimed Value £ 199496.00   
    | ORG0000376     | 10009439 | 3                  | Final         | AY             | 1920   | ALLC-4399     |  2              | 31453.00    | 0.00          | 0.00            | 31453.00   |
    | ORG0000376     | 10009439 | 3                  | Final         | AY             | 1920   | ALLC-4399     |  3              | 20506.00    | 0.00          | 0.00            | 20506.00   |
    | ORG0000376     | 10009439 | 3                  | Final         | AY             | 1920   | ALLC-4399     |  4              | 15229.00    | 0.00          | 0.00            | 15229.00   |
    | ORG0000376     | 10009439 | 3                  | Final         | AY             | 1920   | ALLC-4399     |  5              | 11927.00    | 0.00          | 0.00            | 11927.00   |
    | ORG0000376     | 10009439 | 3                  | Final         | AY             | 1920   | ALLC-4399     |  6              | 10510.00    | 0.00          | 0.00            | 10510.00   |
    | ORG0000376     | 10009439 | 3                  | Final         | AY             | 1920   | ALLC-4399     |  7              | 9207.00     | 0.00          | 0.00            | 9207.00    |
    | ORG0000376     | 10009439 | 3                  | Final         | AY             | 1920   | ALLC-4399     |  8              | 7748.00     | 0.00          | 0.00            | 7748.00    |
    #                                                                                                                                  Planned Value £ 61802.00      Claimed Value £ 106580.00   
    | ORG0000832     | 10021684 | 3                  | Final         | AY             | 1920   | AETL-1229     |  2              | 259.00      | 0.00          | 0.00            | 259.00     |
    | ORG0000832     | 10021684 | 3                  | Final         | AY             | 1920   | AETL-1229     |  3              | 185.00      | 0.00          | 0.00            | 185.00     |
    #                                                                                                                                  Planned Value £ 542.00        Claimed Value £ 444.00      
    | ORG0000832     | 10021684 | 3                  | Final         | AY             | 1920   | AEAL-1169     |  2              | 494.00      | 0.00          | 0.00            | 494.00     |
    | ORG0000832     | 10021684 | 3                  | Final         | AY             | 1920   | AEAL-1169     |  3              | 331.00      | 0.00          | 0.00            | 331.00     |
    | ORG0000832     | 10021684 | 3                  | Final         | AY             | 1920   | AEAL-1169     |  4              | 249.00      | 0.00          | 0.00            | 249.00     |
    | ORG0000832     | 10021684 | 3                  | Final         | AY             | 1920   | AEAL-1169     |  5              | 193.00      | 0.00          | 0.00            | 193.00     |
    #                                                                                                                                  Planned Value £ 999.00        Claimed Value £ 1267.00     
    | ORG0000846     | 10022358 | 3                  | Final         | AY             | 1920   | AETL-1266     |  2              | 809.00      | 0.00          | 0.00            | 809.00     |
    | ORG0000846     | 10022358 | 3                  | Final         | AY             | 1920   | AETL-1266     |  3              | 526.00      | 0.00          | 0.00            | 526.00     |
    #                                                                                                                                  Planned Value £ 1647.00       Claimed Value £ 1335.00     
    | ORG0000846     | 10022358 | 3                  | Final         | AY             | 1920   | AEAL-1189     |  2              | 744.00      | 0.00          | 0.00            | 744.00     |
    | ORG0000846     | 10022358 | 3                  | Final         | AY             | 1920   | AEAL-1189     |  3              | 475.00      | 0.00          | 0.00            | 475.00     |
    | ORG0000846     | 10022358 | 3                  | Final         | AY             | 1920   | AEAL-1189     |  4              | 384.00      | 0.00          | 0.00            | 384.00     |
    | ORG0000846     | 10022358 | 3                  | Final         | AY             | 1920   | AEAL-1189     |  5              | 283.00      | 0.00          | 0.00            | 283.00     |
    #                                                                                                                                  Planned Value £ 1475.00       Claimed Value £ 1886.00     
    | ORG0000384     | 10024962 | 3                  | Final         | AY             | 1920   | AECT-1104     |  2              | 3412.00     | 0.00          | 0.00            | 3412.00    |
    | ORG0000384     | 10024962 | 3                  | Final         | AY             | 1920   | AECT-1104     |  3              | 2235.00     | 0.00          | 0.00            | 2235.00    |
    | ORG0000384     | 10024962 | 3                  | Final         | AY             | 1920   | AECT-1104     |  4              | 1779.00     | 0.00          | 0.00            | 1779.00    |
    | ORG0000384     | 10024962 | 3                  | Final         | AY             | 1920   | AECT-1104     |  5              | 1407.00     | 0.00          | 0.00            | 1407.00    |
    #                                                                                                                                  Planned Value £ 6863.00       Claimed Value £ 8833.00     
    | ORG0000384     | 10024962 | 3                  | Final         | AY             | 1920   | AECA-1408     |  3              | 4916161.00  | 0.00          | 0.00            | 4916161.00 |
    | ORG0000384     | 10024962 | 3                  | Final         | AY             | 1920   | AECA-1408     |  4              | 3838298.00  | 0.00          | 0.00            | 3838298.00 |
    | ORG0000384     | 10024962 | 3                  | Final         | AY             | 1920   | AECA-1408     |  5              | 2944773.00  | 0.00          | 0.00            | 2944773.00 |
    | ORG0000384     | 10024962 | 3                  | Final         | AY             | 1920   | AECA-1408     |  6              | 2412041.00  | 0.00          | 0.00            | 2412041.00 |
    | ORG0000384     | 10024962 | 3                  | Final         | AY             | 1920   | AECA-1408     |  7              | 2054755.00  | 0.00          | 0.00            | 2054755.00 |
    | ORG0000384     | 10024962 | 3                  | Final         | AY             | 1920   | AECA-1408     |  8              | 1852950.00  | 0.00          | 0.00            | 1852950.00 |
    | ORG0000384     | 10024962 | 3                  | Final         | AY             | 1920   | AECA-1408     |  9              | 1725441.00  | 0.00          | 0.00            | 1725441.00 |
    #                                                                                                                                  Planned Value £ 15091140.00   Claimed Value £ 19744420.00 
    | ORG0000384     | 10024962 | 3                  | Final         | AY             | 1920   | ALLC-4623     |  2              | 576303.00   | 0.00          | 0.00            | 576303.00  |
    | ORG0000384     | 10024962 | 3                  | Final         | AY             | 1920   | ALLC-4623     |  3              | 381772.00   | 0.00          | 0.00            | 381772.00  |
    | ORG0000384     | 10024962 | 3                  | Final         | AY             | 1920   | ALLC-4623     |  4              | 293540.00   | 0.00          | 0.00            | 293540.00  |
    | ORG0000384     | 10024962 | 3                  | Final         | AY             | 1920   | ALLC-4623     |  5              | 229517.00   | 0.00          | 0.00            | 229517.00  |
    | ORG0000384     | 10024962 | 3                  | Final         | AY             | 1920   | ALLC-4623     |  6              | 192951.00   | 0.00          | 0.00            | 192951.00  |
    | ORG0000384     | 10024962 | 3                  | Final         | AY             | 1920   | ALLC-4623     |  7              | 160417.00   | 0.00          | 0.00            | 160417.00  |
    | ORG0000384     | 10024962 | 3                  | Final         | AY             | 1920   | ALLC-4623     |  8              | 146798.00   | 0.00          | 0.00            | 146798.00  |
    #                                                                                                                                  Planned Value £ 1176459.00    Claimed Value £ 1981298.00  
    | ORG0000387     | 10036143 | 3                  | Final         | AY             | 1920   | AECT-1062     |  2              | 2669.00     | 0.00          | 0.00            | 2669.00    |
    | ORG0000387     | 10036143 | 3                  | Final         | AY             | 1920   | AECT-1062     |  3              | 1900.00     | 0.00          | 0.00            | 1900.00    |
    | ORG0000387     | 10036143 | 3                  | Final         | AY             | 1920   | AECT-1062     |  4              | 1387.00     | 0.00          | 0.00            | 1387.00    |
    | ORG0000387     | 10036143 | 3                  | Final         | AY             | 1920   | AECT-1062     |  5              | 1128.00     | 0.00          | 0.00            | 1128.00    |
    #                                                                                                                                  Planned Value £ 5500.00       Claimed Value £ 7084.00     
    | ORG0000387     | 10036143 | 3                  | Final         | AY             | 1920   | AECA-1183     |  3              | 417532.00   | 0.00          | 0.00            | 417532.00  |
    | ORG0000387     | 10036143 | 3                  | Final         | AY             | 1920   | AECA-1183     |  4              | 295225.00   | 0.00          | 0.00            | 295225.00  |
    | ORG0000387     | 10036143 | 3                  | Final         | AY             | 1920   | AECA-1183     |  5              | 241271.00   | 0.00          | 0.00            | 241271.00  |
    | ORG0000387     | 10036143 | 3                  | Final         | AY             | 1920   | AECA-1183     |  6              | 191805.00   | 0.00          | 0.00            | 191805.00  |
    | ORG0000387     | 10036143 | 3                  | Final         | AY             | 1920   | AECA-1183     |  7              | 173905.00   | 0.00          | 0.00            | 173905.00  |
    | ORG0000387     | 10036143 | 3                  | Final         | AY             | 1920   | AECA-1183     |  8              | 148799.00   | 0.00          | 0.00            | 148799.00  |
    | ORG0000387     | 10036143 | 3                  | Final         | AY             | 1920   | AECA-1183     |  9              | 139611.00   | 0.00          | 0.00            | 139611.00  |
    #                                                                                                                                  Planned Value £ 1201199.00    Claimed Value £ 1608148.00  
    | ORG0000387     | 10036143 | 3                  | Final         | AY             | 1920   | ALLC-4490     |  2              | 128846.00   | 0.00          | 0.00            | 128846.00  |
    | ORG0000387     | 10036143 | 3                  | Final         | AY             | 1920   | ALLC-4490     |  3              | 93123.00    | 0.00          | 0.00            | 93123.00   |
    | ORG0000387     | 10036143 | 3                  | Final         | AY             | 1920   | ALLC-4490     |  4              | 67810.00    | 0.00          | 0.00            | 67810.00   |
    | ORG0000387     | 10036143 | 3                  | Final         | AY             | 1920   | ALLC-4490     |  5              | 52788.00    | 0.00          | 0.00            | 52788.00   |
    | ORG0000387     | 10036143 | 3                  | Final         | AY             | 1920   | ALLC-4490     |  6              | 43103.00    | 0.00          | 0.00            | 43103.00   |
    | ORG0000387     | 10036143 | 3                  | Final         | AY             | 1920   | ALLC-4490     |  7              | 38212.00    | 0.00          | 0.00            | 38212.00   |
    | ORG0000387     | 10036143 | 3                  | Final         | AY             | 1920   | ALLC-4490     |  8              | 32562.00    | 0.00          | 0.00            | 32562.00   |
    #                                                                                                                                  Planned Value £ 268022.00     Claimed Value £ 456444.00   
    | ORG0003012     | 10038939 | 3                  | Final         | AY             | 1920   | AETL-1255     |  2              | 12069.00    | 0.00          | 0.00            | 12069.00   |
    | ORG0003012     | 10038939 | 3                  | Final         | AY             | 1920   | AETL-1255     |  3              | 7384.00     | 0.00          | 0.00            | 7384.00    |
    #                                                                                                                                  Planned Value £ 23004.00      Claimed Value £ 19453.00    
    | ORG0003012     | 10038939 | 3                  | Final         | AY             | 1920   | AEAL-1183     |  2              | 8845.00     | 0.00          | 0.00            | 8845.00    |
    | ORG0003012     | 10038939 | 3                  | Final         | AY             | 1920   | AEAL-1183     |  3              | 6092.00     | 0.00          | 0.00            | 6092.00    |
    | ORG0003012     | 10038939 | 3                  | Final         | AY             | 1920   | AEAL-1183     |  4              | 4663.00     | 0.00          | 0.00            | 4663.00    |
    | ORG0003012     | 10038939 | 3                  | Final         | AY             | 1920   | AEAL-1183     |  5              | 3870.00     | 0.00          | 0.00            | 3870.00    |
    #                                                                                                                                  Planned Value £ 18565.00      Claimed Value £ 23470.00    

    # Pull data from the old DEDs stub or the the new Submit Learner Data (SLD) interface (26220)
   #When  data is retrieved from the DEDS stub and is consumed
    When  data is retrieved from the SLD stub and is consumed

@AcceptanceTest @InProgress
Scenario: J119 Reject Termination Initiation
    # Reject Termination Initiation using the Next Action step
    When the next action performed by manager 'FCS1 Test' on the latest version of contract 'NONLG-811' is to 'Reject Termination Initiation' specifying the reason as 'Test'

@AcceptanceTest @InProgress
Scenario: J120 Non-Financial Amendment
    # Issue a non-financial NOTIFICATION amendment on v1 to create v2. Only the Summary of Funding should be produced. No Funding Agreements.
    When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'NONLG-1440' for a non-financial VARIATION contract amendment
   #When  a request is raised by advisor 'FCS2 Test' against version '1' subversion '0' of contract 'MAIN-400' for a non-financial NOTIFICATION contract amendment

@AcceptanceTest @InProgress
Scenario: J121 Reject Modification Authorisation
    # Reject Modification using the Next Action step
    When the next action performed by manager 'FCS1 Test' on the latest version of contract 'AEBP-571' is to 'Reject Modification' specifying the reason as 'A571 reason'

@AcceptanceTest @InProgress
Scenario: J122 Check contents of CM feed
    Then  the Contract Management 'ALLCONTRACT' feed includes category 'Contract Modified' event details as follows
    | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | ContractTerminationDate | ContractTerminationReason       | AllocationRef   | StopNewStartsFromDate | AllocationTerminationDate | NewStartsSuspendedReason         |
    | 10017571 | AEBP-571       | 1               | 0                  | ?                       | ?                               | AEAL-571        | 10/10/2020            | ?                         | Inadequate Financial Health      |
    | 10017571 | AEBP-571       | 1               | 0                  | ?                       | ?                               | AEBA-571        | 10/10/2020            | ?                         | Inadequate Financial Health      |
    | 10017571 | AEBP-571       | 1               | 0                  | ?                       | ?                               | AEBR-571        | 10/10/2020            | ?                         | Inadequate Financial Health      |
    | 10017571 | AEBP-571       | 1               | 0                  | ?                       | ?                               | AETL-571        | 10/10/2020            | ?                         | Inadequate Financial Health      |

@AcceptanceTest @InProgress
Scenario: J123 Cancel Authorised Modification
    # Manager CANCELS authorised modification (30700)
    When  CRM user 'FCS1 TEST' cancels the authorised modification for Contract '[ContractNo]' Version '1' SubVersion '0' via SDK
    When  CRM user 'FCS1 TEST' cancels the authorised modification for Contract 'DADAS-575' Version '1' SubVersion '0' via SDK

@AcceptanceTest @InProgress
Scenario: J124 Populate NLAPFundingConfig
    # Set the provider config values for NLAP NewStarts for a specific UKPRN (DocumentsDomain.NLAPFundingConfig) (28766)
    Given the following NLAP NewStarts profile values exist in config
    | UKPRN    | 16-18NewStarts2021 | AdultNewStarts2021 | 16-18NewStartsEstimatedFutureFunding | AdultNewStartsEstimatedFutureFunding |
    | 10017007 | 125.00             | 0.00               | 325.00                               | 0.00                                 |

@AcceptanceTest @InProgress
Scenario: J125 Check Funding Allocations in CRM
    # Check the CRM Funding Allocations data (J125)
    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider        | FundingId                                   | FundingVersion | FundingType                | Period | ContractType                            | AllocationFundingStreamCode | FSPGroup    | Status     | SubStatus | Value     | ContractNo | ContractVersionNo | CreatedBy       | ModifiedBy | HoldReason | ReleaseGroup | QueuedOn | QueuedDueToContract |
    | 10017722 | 10017722 Co Ltd | 1619-AS-2021-Contract-Provider-10017722-1_0 | 1_0            | Education & Skills Funding | AY2021 | Conditions of Funding (Grant) (College) | 1619                        | 16-19ED2021 | In Release | Queued    | 23911.00  | ?          | ?                 | CRM Integration | ?          | ?          | RG123417     | 15/10/2021 | EDSK-722          |
    | 10017722 | 10017722 Co Ltd | 1619-AS-2021-Contract-Provider-10017722-1_0 | 1_0            | Education & Skills Funding | AY2021 | Conditions of Funding (Grant) (College) | 1619                        | 16-19ED2021 | In Release | Queued    | 23911.00  | ?          | ?                 | CRM Integration | ?          | ?          | RG123417     | ?          | ?                 |

    Then  the following Funding Allocations data is present in CRM
    | UKPRN    | Provider        | FundingId                                   | FundingVersion | FundingType                | Period | ContractType                            | AllocationFundingStreamCode | FSPGroup    | Status     | SubStatus | Value     | ContractNo | ContractVersionNo | CreatedBy       | ModifiedBy | HoldReason | ReleaseGroup |
    | 10017722 | 10017722 Co Ltd | 1619-AS-2021-Contract-Provider-10017722-1_0 | 1_0            | Education & Skills Funding | AY2021 | Conditions of Funding (Grant) (College) | 1619                        | 16-19ED2021 | In Release | Queued    | 23911.00  | ?          | ?                 | CRM Integration | ?          | ?          | RG123417     |

#    Then  the following Funding Allocations data is present in CRM
#    | UKPRN    | Provider         | FundingId                                               | FundingVersion | FundingType                | Period  | ContractType                             | AllocationFundingStreamCode | FSPGroup        | Status            | SubStatus         | Value       | ContractNo    | ContractVersionNo | CreatedBy             | ModifiedBy            | HoldReason                |
#    | 10014016 | 10014016 Co Ltd  | NFF-AS-2021-Contract-LocalAuthority-10014016-2_2        | 2_2            | Education & Skills Funding | AY2021  | Conditions of Funding (Grant) (LA)       | NFF                         | 16-19ED2021     | Scheduling        | Awaiting Release  | 4004.00     | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         |
#    | 10014014 | 10014014 Co Ltd  | 1619-AS-2021-Contract-LocalAuthority-10014014-2_5       | 2_5            | Education & Skills Funding | AY2021  | Conditions of Funding (Grant) (LA)       | 1619                        | 16-19ED2021     | Withdrawn         | Withdrawn         | 28639.00    | ?             | ?                 | CRM Integration       | CRM Integration       | ?                         |

@AcceptanceTest @InProgress
Scenario: J126 Delete data from Release Groups and delete Release Groups with specified Contracting Profile
    # Clear down Funding Allocation data and delete Release Groups for a specified Contracting Profile
    Given there are no Funding Allocations and no Release Groups in CRM or PaaS for the following Contracting Profiles
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            |
    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (HEI)     |
    | NLG             | AY2021        | NLG2021      | Non-learning Grant                      |

@AcceptanceTest @InProgress
Scenario: J127 Release Group parameter capture
    # Capture the [ReleaseGroup] parameter value (J127)
   #Given the Release Group for the following Contracting Profile has been saved
    Given the Release Groups for the following Contracting Profiles have been saved
    | FundingTypeCode | FundingPeriod | FSPGroupCode | ContractType                            | ReleaseGroupParameterName |
    | EDSK            | AY2021        | 16-19ED2021  | Conditions of Funding (Grant) (College) | CofG_College              |

@AcceptanceTest @InProgress
Scenario: J128 Trigger release of FA's in a Release Group
    # Release Funding Allocations from Contract Control (J128)
   #When  a request is triggered to release the Funding Allocations in Release Group '[ReleaseGroup]'   <- No longer used
    When  a request is triggered to release the following Release Groups together
   #When  a request is triggered to release the following Release Group
    | ReleaseGroup     |
    | [CofG_College]   |
    | [NLG]            |
    | [Bert]           |
    | [Ernie]          |

@AcceptanceTest @InProgress
Scenario: J129 Check state of Release Group in CRM
    # Check the state of a Release Group in CRM (J129)
    Then  Release Group '[CofG_College]' has the following characteristics
    | ReleaseStatus     | AllocationCount | AllocationValue |
    | Awaiting Release  | 23              | 65234.82        |

@AcceptanceTest @InProgress
Scenario: J130 Put one or more Funding Allocations on HOLD 
    # Invoke HOLD process (J130)
    When  User 'FCS8 TEST' opts to put the following Funding Allocations on hold
    | FundingId                                               | HoldReason                     | Comments                    |
    | NLG-AY-2021-Contract-Provider-10017707-3_5              | Under Investigation            | Suspected fraud             |
    | 1619-AY-2021-Contract-Provider-10017123-1_2             | Held by Allocations Team       | ?                           |

@AcceptanceTest @InProgress
Scenario: J131 Check PaaS Funding Allocation
    # Check PaaS FundingAllocation.FundingAllocation (J131)
    Then  the following Funding Allocations data is present in PaaS
    | UKPRN    | FundingId                                         | FundingVersion | Period  | AllocationFundingStreamCode | Value       | ReleaseGroup   | Status           | SubStatus           |
    | 10017561 | 1619-AS-2021-Contract-Provider-10017561-1_6       | 1_6            | AS-2021 | 1619                        | 42230.00    | [CofG_College] | ?                | ?                   |
    | 10017561 | 1619-AS-2021-Contract-Provider-10017561-2_0       | 2_0            | AS-2021 | 1619                        | 69777.00    | ?              | Parked           | AwaitingOutcome     | 
    | 10017562 | NMSS-AY-2021-Contract-Provider-10017562-4_5       | 4_5            | AY-2021 | NMSS                        | 12345.00    | ?              | Discarded        | NonMaterialUpdate   | 

@AcceptanceTest @InProgress
Scenario: J132 Check PaaS Release Group
    # Check PaaS FundingAllocation.ReleaseGroup (J132)
    Then  Release Group '[CofG_College]' in FundingAllocation.ReleaseGroup has a status of 'Released'

@AcceptanceTest @InProgress
Scenario: J133 Release one or more HELD Funding Allocations 
    # Invoke process to release a held Funding Allocation (J133)
    When  User 'FCS8 TEST' opts to release the following held Funding Allocations using Workflow WF47
    | FundingId                                               | 
    | NLG-AY-2021-Contract-Provider-10017123-3_5              | 
    | 1619-AY-2021-Contract-Provider-10017123-1_1             |

@AcceptanceTest @InProgress
Scenario: J134 sfa_Variation check
    # Check that the contract has the following attributes
    Then  the following Contracts exist in CRM
    | UKPRN    | ContractNumber | FundingType                  | HierarchyType | ContractStatus | ContractSubStatus       | ContractValue | ContractVersionNumber | ContractSubVersionNumber | ContractStartDate | ContractEndDate | LatestVersion | LastApprovedVersion | ContractOwner | ContractType                              | ContractDescription      | AmendmentType | CurrentTask              | DocumentationRequired | ParentContract     | Period | PreviousVersion | ProviderName     | State  | TaskOwner                 | ContractValueVariation  |
    | 10017079 | EDSK-079       | Education & Skills Funding   | Contract      | Draft          | Awaiting Documentation  | 163927.00     | 3                     | 0                        | 01/08/2020        | 31/07/2021      | True          | False               | ?             | Conditions of Funding (Grant) (LA)        | ?                        | ?             | Initiate Document Merge  | Yes                   | [MasterContractNo] | AY2021 | ?               | 10017079 Co Ltd  | Active | Document Management Team  | -1250.00                |
    | 10017079 | ESFA-079       | Education & Skills Funding   | Master        | Draft          | ?                       | 0.00          | 1                     | 0                        | 01/08/2020        | 31/07/2021      | False         | False               | ?             | Conditions of Funding (Grant) (LA)        | ?                        | ?             | ?                        | ?                     | ?                  | ?      | ?               | 10017079 Co Ltd  | Active | CRM Integration           | ?                       |

    # Check that the Contract Allocations have the following attributes
    Then  the following Contract Allocations exist in CRM
    | UKPRN    | ContractNumber     | ContractAllocationRef | ContractAllocationDescription | AllocationValue | DeliveryUKPRN | DeliveryProvider | StartDate  | EndDate    | FundingStream | FundingStreamPeriod | HierarchyType         | AllocationValueVariation |
    | 10017079 | EDSK-079           | 16ED-1234             | ?                             | 4932.00         | 10025748      | 10025748 Co Ltd  | 01/08/2020 | 31/07/2021 | 1619ED        | 1619ED2021          | Contract Allocation   | 435.09                   |
    | 10017079 | EDSK-079           | 16ED-3456             | ?                             | 10857.00        | 10025748      | 10025748 Co Ltd  | 01/08/2020 | 31/07/2021 | 1619ED        | 1619ED2021          | Contract Allocation   | 1875.22                  |

@AcceptanceTest @InProgress
Scenario: J135 Withdraw one or more Funding Allocations from Contract Control
    # Invoke process to withdraw Funding Allocation(s) from Contract Control (J135)
    When  User 'FCS8 TEST' opts to withdraw the following Funding Allocations from Contract Control with Withdrawal Reason '?'
    | FundingId                                               | 
    | NLG-AY-2021-Contract-Provider-10017123-3_5              | 
    | 1619-AY-2021-Contract-Provider-10017123-1_1             | 
# or
    # Invoke process to withdraw Funding Allocation(s) from Contract Control (J135)
    When  User 'FCS8 TEST' opts to withdraw the following Funding Allocations from Contract Control with Withdrawal Reason 'Instructed by CFS'
    | FundingId                                               | 
    | DADA-AY-2021-Contract-Provider-10017654-2_4             | 

@AcceptanceTest @InProgress
Scenario: J136 Re-instate funding allocation (33228)
    # Move FA from 'Return to Scheduling' to 'Awaiting Release' (J136)
  # When  User 'FCS8 TEST' opts to re-instate the following Funding Allocation
    When  User 'FCS8 TEST' opts to re-instate the following Funding Allocations together
    |  FundingId                                              |
    |  NMSS-AY-2021-Contract-Provider-10017709-1_4            |

@AcceptanceTest @InProgress
Scenario: J137 Refresh CFS config from latest config spreadsheet
    # Refresh the CFS config tables back to that defined in the config spreadsheet (J137)
    Given the current base CFS config has been loaded

@AcceptanceTest @InProgress
Scenario: J138 Trigger the un-park process 
    # Run the job which reviews all parked Funding Allocations after config is deployed (J138)
    When  the job to review parked Funding Allocations against the latest version of config is run 

@AcceptanceTest @InProgress
Scenario: J139 Check PaaS Org data
    # Check for specific Provider details in the PaaS Organisation table (Organisation.Organisation)
    Then  the following Organisation details exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017161 | 117161 | 10017161 Co Ltd | 0              | Provider Under Change | Yes           | AA017161      | CH017161      | 65 Moffats Lane        | Brookmans  Park        | ?                      | ?                      | Hatfield               | Hertfordshire          | AL9 7RT   |

@AcceptanceTest @InProgress
Scenario: J140 Check CRM Org data
    # Check for specific Provider details in CRM
    Then  the following Organisation details exist in the CRM Organisation table
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017161 | 117161 | 10017161 Co Ltd | 0              | Provider Under Change | Yes           | AA017161      | Ch017161      | 65 Moffats Lane        | Brookmans  Park        | ?                      | ?                      | Hatfield               | Hertfordshire          | AL9 7RT   |

@AcceptanceTest @InProgress
Scenario: J141 Load CFS config data to AllocationFundingStreamConfig
    # Load FundingAllocation.AllocationFundingStreamConfig (J141)
    Given the following data replaces that currently in FundingAllocation.AllocationFundingStreamConfig
    | AllocationFundingStreamCode | AllocationPeriodId | FundingTypeCode | FundingPeriodCode | FSPGroupCode | 
    | 1619                        | AS-2021            | EDSK            | AY2021            | 16-19ED2021  | 
    | DADA                        | AS-2021            | DADA            | AY2021            | DADA2021     | 
    | NFF                         | AS-2021            | EDSK            | AY2021            | 16-19ED2021  | 
    | NLG                         | AS-2021            | NLG             | AY2021            | NLG2021      | 
    | NMSS                        | AY-2021            | EDSK            | AY2021            | 16-19ED2021  | 

@AcceptanceTest @InProgress
Scenario: J142 Load CFS config data to CfSCodesToContractTypeConfig 
    # Load FundingAllocation.CfsCodesToContractTypeConfig (J142)
    Given the following data replaces that currently in FundingAllocation.CfsCodesToContractTypeConfig
    | FundingTypeCode | FundingPeriodCode | ProviderCategory | ContractType                              |
    | DADA            | AY2021            | DEFAULT          | Contract for Services                     |
    | EDSK            | AY2021            | College          | Conditions of Funding (Grant) (College)   |
    | EDSK            | AY2021            | HEI              | Conditions of Funding (Grant) (HEI)       |
    | EDSK            | AY2021            | SSF              | Conditions of Funding (Grant) (LA)        |
    | EDSK            | AY2021            | LA               | Conditions of Funding (Grant) (LA)        |
    | EDSK            | AY2021            | NMSS             | Conditions of Funding (Grant) (NMSS)      |
    | EDSK            | AY2021            | SPI              | Conditions of Funding (Grant) (SPI)       |
    | EDSK            | AY2021            | ITP              | Contract for Services (ITP)               |
    | NLG             | AY2021            | DEFAULT          | Non-learning Grant                        |

@AcceptanceTest @InProgress
Scenario: J143 Load CFS config data to ProviderTypeConfig
    # Load FundingAllocation.ProviderTypeConfig (J143)
    Given the following data replaces that currently in FundingAllocation.ProviderTypeConfig
    | ProviderType    | ProviderSubType   | ProviderCategory |
    | Furth           | 01GFE             | College          |
    | Furth           | 02IPP             | ITP              |
    | Furth           | 03SFC             | College          |
    | Furth           | 04AHC             | College          |
    | Furth           | 05ADC             | College          |
    | Furth           | 06SDC             | College          |
    | Furth           | 07HEP             | HEI              |
    | Furth           | 18ISP             | SPI              |
    | Local           | 10LAU             | LA               |
    | Schoo           | 08SSF             | SSF              |
    | Schoo           | 21NMS             | NMSS             |

@AcceptanceTest @InProgress
Scenario: J144 Load CFS config data to AllocationLineConfig
    # Load FundingAllocation.AllocationLineConfig (J144)
    Given the following data replaces that currently in FundingAllocation.AllocationLineConfig
    | FundingStreamCode | PeriodId   | FundingLineCode | ProviderCategory | FSPCode     | DeliverableCode | 
    | 1619              | AS-2021    | 1619-001        | SSF              | 1619ED2021  | 2               | 
    | 1619              | AS-2021    | 1619-001        | DEFAULT          | 1619ED2021  | 20              | 
    | 1619              | AS-2021    | 1619-001        | SPI              | 1619ED2021  | 32              | 
    | 1619              | AS-2021    | 1619-002        | SSF              | 1619ED2021  | 13              | 
    | 1619              | AS-2021    | 1619-002        | DEFAULT          | 1619ED2021  | 19              | 
    | 1619              | AS-2021    | 1619-003        | DEFAULT          | 1619ED2021  | 33              | 
    | 1619              | AS-2021    | 1619-004        | DEFAULT          | 1619ED2021  | 85              | 
    | 1619              | AS-2021    | 1619-005        | DEFAULT          | 1619ED2021  | 31              | 
    | 1619              | AS-2021    | 1619-005        | SSF              | 1619ED2021  | 47              | 
    | 1619              | AS-2021    | 1619-006        | SSF              | 1619ED2021  | 15              | 
    | 1619              | AS-2021    | 1619-006        | DEFAULT          | 1619ED2021  | 22              | 
    | 1619              | AS-2021    | 1619-007        | DEFAULT          | 1619ED2021  | 112             | 
    | 1619              | AS-2021    | 1619-007        | SSF              | 1619ED2021  | 114             | 
    | 1619              | AS-2021    | 1619-008        | SSF              | 1619ED2021  | 48              | 
    | 1619              | AS-2021    | 1619-008        | DEFAULT          | 1619ED2021  | 914             | 
    | 1619              | AS-2021    | 1619-009        | DEFAULT          | 1619ED2021  | 136             | 
    | 1619              | AS-2021    | 1619-009        | SSF              | 1619ED2021  | 138             | 
    | 1619              | AS-2021    | 1619-010        | DEFAULT          | 1619ED2021  | 125             | 
    | 1619              | AS-2021    | 1619-011        | DEFAULT          | 1619ED2021  | 51              | 
    | 1619              | AS-2021    | 1619-013        | DEFAULT          | 1619ED2021  | 18              | 
    | 1619              | AS-2021    | 1619-020        | DEFAULT          | 1619ED2021  | 52              | 
    | 1619              | AS-2021    | 1619-021        | DEFAULT          | 1619ED2021  | 53              | 
    | 1619              | AS-2021    | 1619-024        | DEFAULT          | 1619ED2021  | 149             | 
    | 1619              | AS-2021    | 1619-024        | SSF              | 1619ED2021  | 151             | 
    | DADA              | AS-2021    | DADA-001        | DEFAULT          | DADA2021    | 1               | 
    | NFF               | AS-2021    | NFF-001         | DEFAULT          | 1619ED2021  | 931             | 
    | NFF               | AS-2021    | NFF-002         | DEFAULT          | 1619ED2021  | 87              | 
    | NFF               | AS-2021    | NFF-003         | DEFAULT          | 1619ED2021  | 89              | 
    | NFF               | AS-2021    | NFF-004         | DEFAULT          | 1619ED2021  | 119             | 
    | NFF               | AS-2021    | NFF-005         | DEFAULT          | 1619ED2021  | 126             | 
    | NFF               | AS-2021    | NFF-005         | SSF              | 1619ED2021  | 129             | 
    | NFF               | AS-2021    | NFF-006         | DEFAULT          | 1619ED2021  | 127             | 
    | NFF               | AS-2021    | NFF-006         | SSF              | 1619ED2021  | 130             | 
    | NFF               | AS-2021    | NFF-007         | DEFAULT          | 1619ED2021  | 124             | 
    | NFF               | AS-2021    | NFF-008         | DEFAULT          | 1619ED2021  | 120             | 
    | NFF               | AS-2021    | NFF-008         | SSF              | 1619ED2021  | 121             | 
    | NLG               | AS-2021    | NLG-001         | DEFAULT          | NLG2021     | 116             | 
    | NLG               | AS-2021    | NLG-002         | DEFAULT          | NLG2021     | 101             | 
    | NLG               | AS-2021    | NLG-003         | DEFAULT          | NLG2021     | 102             | 
    | NMSS              | AY-2021    | NMSS-001        | DEFAULT          | 1619ED2021  | 39              | 
    | NMSS              | AY-2021    | NMSS-002        | DEFAULT          | 1619ED2021  | 15              | 
    | NMSS              | AY-2021    | NMSS-003        | DEFAULT          | 1619ED2021  | 13              | 
    | NMSS              | AY-2021    | NMSS-004        | DEFAULT          | 1619ED2021  | 49              | 
    | NMSS              | AY-2021    | NMSS-005        | DEFAULT          | 1619ED2021  | 43              | 
    | NMSS              | AY-2021    | NMSS-006        | DEFAULT          | 1619ED2021  | 118             | 
    | NMSS              | AY-2021    | NMSS-007        | DEFAULT          | 1619ED2021  | 135             | 
    | NMSS              | AY-2021    | NMSS-008        | DEFAULT          | 1619ED2021  | 140             | 

@AcceptanceTest @InProgress
Scenario: J145 Set up an Organisation in CRM and PaaS with Caseload Advisor

    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10006929' 
    And   there is no caseload advisor for UKPRN '10006929' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10006929 | 
 
#    # This step overrides normal Org processing and will return 'Not Found' for a given UKPRN (Based on A337) 
#    And   the Organisation stub contains a NOTFOUND entry for UKPRN '10006929' 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10006929 Co Ltd' with UKPRN '10006929' and OrgId 'ORG0017780' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10006929 | 106929 | 10006929 Co Ltd | 0              | Active                | Yes           | AA006929      | ?             | 76 Moorfield Road      | Denham Green           | Little Malton          | Uxbridge               | Middlesex              | ?                      | UB9 5NF   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10006929 |

@AcceptanceTest @InProgress
Scenario: J146 Clear down ContractRequest.FundingAllocationRelease
    # Clear down ContractRequest.FundingAllocationRelease (J146)
    Given there is no data in the ContractRequest.FundingAllocationRelease table

@AcceptanceTest @InProgress
Scenario: J147 Upsert a row on ContractRequest.FundingAllocationRelease
    # Truncate ContractRequest.FundingAllocationRelease then insert the following data. (To check if Release Groups are in-flight) (J147)
    Given the following data exists in the ContractRequest.FundingAllocationRelease table
    | FundingTypeCode | FundingPeriodName | ReleaseStatus       |
    | EDSK            | AY2122            | ReleaseInProgress   |
    | CCF             | FY2122            | Released            |
  # | NLG             | AY2122            | Awaiting Release    |
    | Veni            | Vidi              | ReleaseInProgress   |

@AcceptanceTest @InProgress
Scenario: J148 Clear down FundingAllocation.BulkUploadStatus
    # Clear down FundingAllocation.BulkUploadStatus (J148)
    Given there is no data in the FundingAllocation.BulkUploadStatus table

@AcceptanceTest @InProgress
Scenario: J149 Upsert a row on FundingAllocation.BulkUploadStatus
    # Truncate FundingAllocation.BulkUploadStatus then insert the following data. (To check if Bulk Imports are in-flight) (J149)
    Given the following data exists in the FundingAllocation.BulkUploadStatus table
    | FundingTypeCode | FundingPeriodName | Status     |
    | EDSK            | AY2122            | InProgress |
    | CCF             | FY2122            | InProgress |
    | NLG             | AY2122            | Loaded     |
    | Veni            | Vidi              | Loaded     |

@AcceptanceTest @InProgress
Scenario: J150 Remove data from Reconciliation Profile table
    # Delete a specific row from the PerformanceManagement.ClaimReconciliationReferenceDataReconProfiling table (J150)
    Given there is no data in the Reconciliation Profiling table for UKPRN '12345678' and FundingPeriod 'AY2021'

@AcceptanceTest @InProgress
Scenario: J151 Upsert data in the Reconciliation Profile table
    # Upsert a specific row on the PerformanceManagement.ClaimReconciliationReferenceDataReconProfiling table - to share underpayments between four periods (J151)
    Given the Reconciliation Profiling table includes a row for UKPRN '10017824' and FundingPeriod 'AY2021'
    Given the Reconciliation Profiling table includes a row for UKPRN '10017825' and FundingPeriod 'AY2021'
    Given the Reconciliation Profiling table includes a row for UKPRN '10017826' and FundingPeriod 'AY2021'

@AcceptanceTest @InProgress
Scenario: J152 Set up two Providers for 35597
    
    # Organisation and Advisors 
    Given there is no Organisation data in CRM for UKPRN '10007709' 
    And   there is no caseload advisor for UKPRN '10007709' 
 
    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    | 
    | 10007709 | 
 
    And   caseload advisor 'FCS2 Test' is assigned to provider 'York College' with UKPRN '10007709' and OrgId 'ORG0007709' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name                               | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10007709 | 217709 | York College                       | 0              | Active                | Yes           | AA017709      | ?             | 35 Hall Road           | Tame Valley            | ?                      | ?                      | Tamworth               | Staffordshire          | B77 5DQ   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10007709 |




#    # Organisation and Advisors 
#    Given there is no Organisation data in CRM for UKPRN '10054747' 
#    And   there is no caseload advisor for UKPRN '10054747' 
# 
#    And   there is no Organisation data in PaaS for the following UKPRNs 
#    | UKPRN    | 
#    | 100054747| 
# 
#    And   caseload advisor 'FCS2 Test' is assigned to provider 'Orchard Hill College' with UKPRN '10054747' and OrgId 'ORG0054747' and has 'FCS1 Test' as a manager 
#
#    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
#    And   the following Organisations exist in the FCT Organisation Service 
#    | UKPRN    | UPIN   | Name                 | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
#    | 10054747 | 254747 | Orchard Hill College | 0              | Active                | Yes           | AA054747      | ?             | 8 Orchard Hill         | Tame Valley            | ?                      | ?                      | Tamworth               | Staffordshire          | B77 5DQ   |
#
#    # Put the same Provider data in the CRM Organisation table 
#    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
#    | UKPRN    |
#    | 10054747 |

@AcceptanceTest @InProgress
Scenario: J153 Levy override templates (Bulk)
    # Bulk - include a variety of override template names
    When  a request is issued to amend the following Levy contract via Bulk
    | UKPRN    | MasterContractNumber | ContractNumber | Version | Status   | SubStatus                                | AmendmentType | AddNonLevy2019Allocation | AllowUnderTermination |	ShouldMergeAmendmentTemplate | LetterTemplateName                   | AgreementTemplateName                      |
    | 10017771 | MasterContractNo     | ContractNo-1   | 1       | Approved | Awaiting Termination Initiation Approval | Notification  | No                       | Yes                   |	Yes                          | LEVY1799_Amendment_No-TD_DUMMY.docx  | T&C_LEVY_Under_Term_DUMMY_2017-05-01.docx  |
    | 10017773 | MasterContractNo     | ContractNo-3   | 1       | Approved | Awaiting Termination Initiation Approval | Notification  | No                       | Yes                   |	Yes                          | ?                                    | T&C_LEVY_Under_Term_DUMMY_2017-05-01.docx  |
    | 10017774 | MasterContractNo     | ContractNo-4   | 1       | Approved | Awaiting Termination Initiation Approval | Notification  | No                       | Yes                   |	Yes                          | LEVY1799_Amendment_TD_DUMMY.docx     | ?                                          |

@AcceptanceTest @InProgress
Scenario: J154 Levy override templates (Singleton)
    # Single - include a variety of override template names
    When  a request is issued to amend the following Levy contract via Single
    | UKPRN    | MasterContractNumber | ContractNumber | Version | Status   | SubStatus                                | AmendmentType | AddNonLevy2019Allocation | ShouldMergeAmendmentTemplate | LetterTemplateName                    | AgreementTemplateName                       |
    | 10017775 | [MasterContractNo]   | ContractNo-5   | 1       | Approved | Awaiting Termination Initiation Approval | Notification  | No                       | Yes                          | LEVY1799_Amendment_No-TD_DUMMY.docx   | T&C_LEVY_Under_Term_DUMMY_2017-05-01.docx   |
    | 10017776 | [MasterContractNo]   | ContractNo-6   | 1       | Approved | Awaiting Termination Initiation Approval | Notification  | No                       | Yes                          | LEVY1799_Amendment_TD_DUMMY.docx      | ?                                           |
    | 10017777 | [MasterContractNo]   | ContractNo-7   | 1       | Approved | Awaiting Termination Initiation Approval | Notification  | No                       | Yes                          | ?                                     | T&C_LEVY_Under_Term_DUMMY_2017-05-01.docx   |
    | 10017778 | [MasterContractNo]   | ContractNo-8   | 1       | Approved | Awaiting Termination Initiation Approval | Notification  | No                       | Yes                          | ?                                     | ?                                           |

@AcceptanceTest @InProgress
Scenario: J155 Check the Parked and Discarded spreadsheet(33814)
    # Delete then recreate the Parked and Discarded spreadsheet (J155)
 #  When the Parked and Discarded extract is run
    When the Parked and Discarded spreadsheet is recreated
    
    # Check the named tab of the Parked and Discarded spreadsheet in the 'Funding Allocation Extracts' folder for particular row(s) (J155)
 #  Then  the Parked and Discarded extract includes the following 
    Then  the Parked and Discarded spreadsheet includes the following 
    | TabName   | CFSFundingId                                         | CFSValue    | FCSStatus | FCSSubStatus                     | CFSProviderType                      | CFSProviderSubType   |
   #| Parked    | 1619-AS-2223-Contracting-localAuthority-10000143-1_0 | 11255572.49 | Parked    | AwaitingFundingAllocationConfig  | Local authority maintained schools   | Community school     |
    | Discarded | 1619-AS-2122-Contract-Provider-10017211-1_1          | 21869.00    | Discarded | Superseded                       | Furth                                | 02IPP                |

 # or

    Then  the Parked and Discarded spreadsheet includes these entries 
    | TabName   | CFSFundingId                                         | CFSValue    | FCSStatus | FCSSubStatus                     |
   #| Parked    | 1619-AS-2223-Contracting-localAuthority-10000143-1_0 | 11255572.49 | Parked    | AwaitingFundingAllocationConfig  |
    | Discarded | 1619-AS-2122-Contract-Provider-10017211-1_1          | 21869.00    | Discarded | Superseded                       |

@AcceptanceTest @InProgress
Scenario: J156 Set NLAP New Starts config values
    # Set the provider config values for NLAP NewStarts for a specific UKPRN (DocumentsDomain.NLAPFundingConfig) (28766)
    Given the following NLAP NewStarts profile values exist in config
    | UKPRN    | 16-18NewStarts2021 | AdultNewStarts2021 | 16-18NewStartsEstimatedFutureFunding | AdultNewStartsEstimatedFutureFunding |
    | 10064085 | 7561.00            | 8317.00            | 6605.00                              | 3887.00                              |

@AcceptanceTest @InProgress
Scenario: J157 Clear down NLAP New Starts config values
    # Remove all trace of NLAP config values for NewStarts for a specific UKPRN (DocumentsDomain.NLAPFundingConfig) (28766)
    And   there is no NLAP NewStarts profile data in config for UKPRN '10064085'

@AcceptanceTest @InProgress
Scenario: J158 Planned data on ADP feed
    # Check Planned data on the ADP feed
    Then  the Allocation Delivery Monitoring Service atom feed contains the following Planned data  
    | AllocationDeliveryEntryCategory   | ContractNumber | VersionNumber | AllocationNumber | DeliverableCode | Period | PlannedValue | PlannedVolume |
    | NewContractAllocationApproved     | ESIF-184       | 1             | ESF-184          | 3               | 201804 | 4241.00      | 0             |
    | NewContractAllocationApproved     | ESIF-184       | 1             | ESF-184          | 4               | 201804 | 1782.00      | 54            |

@AcceptanceTest @InProgress
Scenario: J159 Override Date
    # Set the override date
    Given the override date is '05/03/2015'

#@AcceptanceTest @InProgress
Scenario: J160 CDA 
    # Run the CDA report
    Given there is no CDA report named 'CDA Last Approved Version J160.csv'

    When  the following CDA report is run
    | FundingStreamPeriod   | Version               | Suffix |
    | SDFII2223             | Last Approved Version | J160   |

    Then  a report named 'CDA Latest Version J160.csv' is created

@AcceptanceTest @InProgress
Scenario: J161 Orgs and Advisors
    # Set Organisation and Advisors
    Given there is no Organisation data in CRM for UKPRN '10005972'
    And   there is no caseload advisor for UKPRN '10005972'

    And   there is no Organisation data in PaaS for the following UKPRNs 
    | UKPRN    |
    | 10005972 |

    And   caseload advisor 'FCS2 Test' is assigned to provider 'Hogwarts School of Witchcraft and Wizardry' with UKPRN '10005972' and OrgId 'ORG0005972' and has 'FCS1 Test' as a manager 

    # Put Provider data in the PaaS Organisation table (Organisation.Organisation) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name                                       | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10005972 | 005972 | Hogwarts School of Witchcraft and Wizardry | 0              | Active                | Yes           | AA005972      | CH005972      | Hogwarts Castle        | Moray Firth            | ?                      | ?                      | ?                      | Highlands              | HG1 1HG   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10005972 |

@AcceptanceTest @InProgress
Scenario: J162 
    # Clear down subnominal data from CRM SubnominalAggregation for specified subnominal codes (J162)
    Given there is no Subnominal data in CRM for the following subnominal codes
    | SubnominalCode |
    | 2207010        |
    | 2240200        |

@AcceptanceTest @InProgress
Scenario: J163 Run the Consolidated Payment Summary Report 
    # Set the override date, run the Consolidated Payment Summary Report and save output in Sharepoint (30759) (J050)
    When a Consolidated Payment Summary Report is created in Sharepoint for '13/07/2023'
    # Check the above report manually

@AcceptanceTest @InProgress
Scenario: J164 Save the Consolidated Payment Summary Report 
    # Copy\Save a named Sharepoint file to a named folder\filename
    Given Sharepoint file '2023-04 Payments.xlsx' in 'Consolidated Payment Summary' is copied to 'Datafiles/Downloads' as 'J163.xlsx'

@AcceptanceTest @InProgress
Scenario: J165

@AcceptanceTest @InProgress
Scenario: J166

@AcceptanceTest @InProgress
Scenario: J167

@AcceptanceTest @InProgress
Scenario: J168
