Feature: RetrieveCRNforProvider 21099

@AcceptanceTest @Withdrawn20201209
Scenario: A355 Bulk upload a new 1819 Mainstream contract. CRM updated with non-null Company Number, a non-null Charity Number and Legal address details
    Given there is no Contract, Task or Workflow data for UKPRN '10017355' 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 
	And   there are no notifications in CRM of type 'Provider Details Updated' for UKPRN '10017355'

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017355' 
   #And   caseload advisor 'FCS2 Test' is assigned to provider '10017355 Co Ltd' with UKPRN '10017355' and OrgId 'ORG0017355' and has 'FCS1 Test' as a manager 
   #And   UPIN '117355' is associated with UKPRN '10017355' in the CRM Organisation table 
 
    # Put data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017355 | 117355 | 10017355 Co Ltd | 0              | Active | Yes           | AA017355      | 17355         | 4 White Oak Square     | London Road            | ?                      | ?                      | Swanley                | Kent                   | BR8 7AG   |

 #  # Put data in the CRM Organisation table J057
 #  And   the following Organisations exist in CRM
 #  | UKPRN    | UPIN   | Name            | Status | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
 #  | 10017355 | 117355 | 10017355 Co Ltd | Active | AA017355      | ?             | 4 White Oak Square     | London Road            | ?                      | ?                      | Swanley                | Kent                   | BR8 7AG   |



    # Change the date 
    Given the override date is '17/07/2018' 

    # Cleardown prior to bulk import
    And   there are no files prefixed 'MAIN AY 1819 23112018121148 v3_A355' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'MAIN AY 1819 23112018121148 v3_A355' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'MAIN AY 1819 23112018121148 v3_A355' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'MAIN AY 1819 23112018121148 v3_A355' in the Sharepoint 'Reports' folder
	And   there are no files prefixed '10017355' in the Sharepoint 'MAIN-1819-Input-Appendices' folder

    # Bulk import to create a new contract
    And   spreadsheet 'MAIN AY 1819 23112018121148 v3_A355.xlsx' exists in the Datafiles folder and UKPRN '10017355' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report
 
     # Associate an Advisor with the main provider
    Given caseload advisor 'FCS2 Test' is assigned to UKPRN '10017355'

    # Check the data in the CRM Organisation table J060
    Then  the CRM Organisation table contains the following values
    | UKPRN    | UPIN   | Name            | Status | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017355 | 117355 | 10017355 Co Ltd | Active | AA017355      | 17355         | 4 White Oak Square     | London Road            | ?                      | ?                      | Swanley                | Kent                   | BR8 7AG   |

   # Check that a 'Provider Details Updated' notification has not been created for the following provider
   # Note: Parameter 1 is simply a string which is searched for in the Notification Name
    And   a notification has not been created with '10017355' in the Notification Name and with a Notification Type of 'Provider Details Updated'


    # Tidy up
    And   the override date is reset

@AcceptanceTest @Complete
Scenario: A357 Create a new ESF contract before call made to UKRLP. Company Number, Charity Number and Address change then Update Draft occurs. CRM is NOT updated with new values
    Given there is no Contract, Task or Workflow data for UKPRN '10017357' 
    And   the PaaS MonthEndIsRunning indicator is set to 'False' 
	And   there are no notifications in CRM of type 'Provider Details Updated' for UKPRN '10017357'
 
    # Change the date 
    And   the override date is '12/08/2017'  

    # Set organisation and advisors 
    And   there is no Organisation data for UKPRN '10017357' 
   #And   caseload advisor 'FCS2 Test' is assigned to provider '10017357 Co Ltd' with UKPRN '10017357' and OrgId 'ORG0017357' and has 'FCS1 Test' as a manager 
   #And   UPIN '117357' is associated with UKPRN '10017357' in the CRM Organisation table 
 
    # Put data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017357 | 117357 | 10017357 Co Ltd | 0              | Active | No            | ?             | ?             | Flat 7b                | 8 Brook Gardens        | High Street North      | Ledsham                | Ellesmere Port         | Merseyside             | CH66 4TT  |

    # Put data in the CRM Organisation table J057
    And   the following Organisations exist in CRM
    | UKPRN    | UPIN   | Name            | Status | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017357 | 117357 | 10017357 Co Ltd | Active | ?             | ?             | Flat 7b                | 8 Brook Gardens        | High Street North      | Ledsham                | Ellesmere Port         | Merseyside             | CH66 4TT  |


    # Create contract 
    And   the draft contract header details for the latest version of the contract are as follows 
    | UKPRN    | LegalName            | MasterContractNumber | ContractNumber | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent    | OrgId      |
    | 10017357 | 10017357 Co Ltd      | ESFA-357             | ESIF-357       | 1                     | 01/08/2017        | 31/07/2017      | 104770.00     | Contract for Services | 1420   | New          | ORG0017357 |

    And   the draft contract allocations details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | FundingStreamCode | FundingStreamPeriodType | AllocationStartDate | AllocationEndDate | AllocationValue | UoPName  | UoPCode | AllocationDescription   | CRMIntent    | LEPName                 | LEPCode  | LotReference | TenderSpecificationReference | TenderAwardReference          | InvestmentPriority                          | AgreementNumber | ActivityDescription | SpecificationTitle  | RegionType     | LearningRatePremium | DeliveryOrg |
    | 10017357 | ESIF-357       | ESF-357       | ESF 201420        | ESF                     | 01/08/2017          | 31/07/2018        | 104770.00       |          |         |                         | New          | Cumbria LEP             | E37007   | 00-1         | TSS_20125                    | 20125/23-415-00-1/10017357    | 1.2 Sustainable integration of young people | 111\SD\7357     | Job Seekers Fund    | SSW                 | Transition     | 1.01                |             |

    And   the draft contract deliverables details for the latest version of the contract are as follows
    | UKPRN    | ContractNumber | AllocationRef | DeliverableCode | ParentDeliverableCode | UnitCost | Total     | Aug-17   | Sep-17   | Oct-17   | Nov-17   | Dec-17   | Jan-18   | Feb-18   | Mar-18   | Apr-18   | May-18   | Jun-18   | Jul-18   | DeliverableDescription                                  | CRMIntent    | DeliveryOrg |
    | 10017357 | ESIF-357       | ESF-357       | 2               | 0                     |          | 38388.00  | 5167.00  | 3524.00  | 5591.00  | 3113.00  | 1995.00  | 1323.00  | 2693.00  | 1431.00  | 5273.00  | 3670.00  | 2259.00  | 2349.00  | RQ01 Regulated Learning                                 | New          |             |
    | 10017357 | ESIF-357       | ESF-357       | 3               | 0                     |          | 34762.00  | 4797.00  | 927.00   | 3566.00  | 5739.00  | 1474.00  | 4456.00  | 2637.00  | 486.00   | 2475.00  | 2049.00  | 4269.00  | 1887.00  | NR01 Non Regulated Activity                             | New          |             |
    | 10017357 | ESIF-357       | ESF-357       | 5               | 0                     |          | 31620.00  | 490.00   | 5375.00  | 686.00   | 3921.00  | 5404.00  | 1489.00  | 2284.00  | 2395.00  | 3169.00  | 1637.00  | 3496.00  | 1274.00  | AC01 Actual Costs                                       | New          |             |

    And   the contract exists in CRM 
    # Contract status is now at 'Awaiting Documentation' 

    # Check the deliverable count in CRM  
    And   there are '36' deliverable period rows in CRM linked to the latest version of contract 'ESIF-357 ' 

    # Change the date 
    And   the override date is '14/08/2017' 

	# Add UPIN to pre-existing CRM Organisation table
	And   UPIN '117357' is associated with UKPRN '10017357' in the CRM Organisation table 

    # UKRLP updates the Org Service
    And   the following Organisations exist in the FCT Organisation Service 
    | OrgId      | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOK | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | ORG0017357 | 10017357 | 117357 | 10017357 Co Ltd | 0              | Active | Yes           | AA017357      | 17357         | 4 Peter Court North    | The Deans              | Bridge Road            | Bagshot                | ?                      | Surrey                 | GU19 5AT  |

    # Cleardown prior to bulk import
    Given there are no files prefixed 'ESF ESF 1420 20112017074450 v2_A357' in the Sharepoint 'Input' folder
    And   there are no files prefixed 'ESF ESF 1420 20112017074450 v2_A357' in the Sharepoint 'Processing' folder
    And   there are no files prefixed 'ESF ESF 1420 20112017074450 v2_A357' in the Sharepoint 'Processed' folder
    And   there are no files prefixed 'ESF ESF 1420 20112017074450 v2_A357' in the Sharepoint 'Reports' folder

    # Bulk import to change the contract details by UPDATE DRAFT
    And   spreadsheet 'ESF ESF 1420 20112017074450 v2_A357.xlsx' exists in the Datafiles folder and UKPRN '10017357' is present in cell 'A2' of the Contract tab
    When  the file is copied to the Sharepoint 'Input' folder 
    Then  a syntax report should exist in the Sharepoint Reports folder
    And   a results report should exist in the Sharepoint Reports folder
    And   'Success' is displayed in field 'J2' on the 'Contract' tab of the result report
 



    # Check the Organisation details in CRM have NOT changed J060
    And   the CRM Organisation table contains the following values
    | UKPRN    | UPIN   | Name            | Status | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017357 | 117357 | 10017357 Co Ltd | Active | ?             | ?             | Flat 7b                | 8 Brook Gardens        | High Street North      | Ledsham                | Ellesmere Port         | Merseyside             | CH66 4TT  |

	# Check that a 'Provider Details Updated' notification has not been created for the following provider
    # Note: Parameter 1 is simply a string which is searched for in the Notification Name
    And   a notification has not been created with '10017357' in the Notification Name and with a Notification Type of 'Provider Details Updated'

    # Tidy up
    Then  the override date is reset
	
@AcceptanceTest @Complete
@HighValue
Scenario: A358 Various UKRLP provider changes occur. Organisation webjob updates FCS and CRM with new Company Numbers, Charity Numbers and Addresses. Notifications issued
    Given there is no Contract, Task or Workflow data for UKPRN '10018101'
	And   there is no Contract, Task or Workflow data for UKPRN '10018112'
	And   there is no Contract, Task or Workflow data for UKPRN '10018123'
	And   there is no Contract, Task or Workflow data for UKPRN '10018134'
	And   there is no Contract, Task or Workflow data for UKPRN '10018145'
	And   there is no Contract, Task or Workflow data for UKPRN '10018156'
	And   there is no Contract, Task or Workflow data for UKPRN '10017358'
	And   there are no notifications of type 'Provider Details Updated'

	# Cleardown CRM notification data
	And   there are no CRM Notifications for the following UKPRNs
	| UKPRN    |
    | 10018101 |
    | 10018112 |
    | 10018123 |
    | 10018134 |
    | 10018145 |
    | 10018156 |
    | 10017358 |

	# Cleardown Organisation data in CRM
	And   there is no Organisation data for UKPRN '10018101' 
    And   there is no Organisation data for UKPRN '10018112' 
    And   there is no Organisation data for UKPRN '10018123' 
    And   there is no Organisation data for UKPRN '10018134' 
    And   there is no Organisation data for UKPRN '10018145' 
    And   there is no Organisation data for UKPRN '10018156'  
	And   there is no Organisation data for UKPRN '10017358'

    # Cleardown Organisation Service (PaaS Organisation table)
    And   there is no data in the FCT Organisation Service for the following Organisations
    | UKPRN    |
    | 10018101 |
    | 10018112 |
    | 10018123 |
    | 10018134 |
    | 10018145 |
    | 10018156 |
    | 10017358 |

    # Cleardown stub data
    And   there is no data in the UKRLP stub for the following Organisations
    | UKPRN    |
    | 10018101 |
    | 10018112 |
    | 10018123 |
    | 10018134 |
    | 10018145 |
    | 10018156 |
    | 10017358 |

    # Put data in the PaaS Organisation table (dbo.Organisations)
    And   the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018101 | 118101 | 10018101 Co Ltd | 0              | Active | Yes           | ?             | ?             | 65 Greg House          | Moffats Lane           | Brookmans  Park        | ?                      | Hatfield               | Hertfordshire          | AL9 7RT   |
    | 10018112 | 118112 | 10018112 Co Ltd | 0              | Active | Yes           | AA018112      | 18112         | 91 Windy Bldgs         | Hullbridge Road        | South Woodham Ferrers  | Chelmsford             | ?                      | Essex                  | CM3 5LJ   |
    | 10018123 | 118123 | 10018123 Co Ltd | 0              | Active | Yes           | AA018123      | ?             | 18 Gratton Ct          | Clare Street           | London                 | ?                      | ?                      | ?                      | EC2A 4LJ  |
    | 10018134 | 118134 | 10018134 Co Ltd | 0              | Active | Yes           | AA018134      | 18134         | 10 West Ave            | St. Mary at Hill       | London                 | ?                      | ?                      | ?                      | EC3R 8EE  |
    | 10018145 | 118145 | 10018145 Co Ltd | 0              | Active | Yes           | AA018145      | 18145-2       | 2 Church Close         | Church Gates           | The Wilderness         | ?                      | Berkhamsted            | Hertfordshire          | HP4 2UB   |
    | 10018156 | 118156 | 10018156 Co Ltd | 0              | Active | Yes           | AA018156      | ?             | 29 Avenue House        | Waterside              | 44 - 48 Wharf Road     | Islington              | London                 | ?                      | N1 7SH    |
   #| 10017358 | 117358 | 10017358 Co Ltd | 0              | Active | Yes           | AA017358      | 17358         | 500 Grant Bldgs        | Chiswick High Road     | London                 | ?                      | ?                      | ?                      | W4 5RG    |

    # Put data in the CRM Organisation table
    And   the following Organisations exist in CRM
    | UKPRN    | UPIN   | Name            | Status | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018101 | 118101 | 10018101 Co Ltd | Active | ?             | ?             | 65 Greg House          | Moffats Lane           | Brookmans  Park        | ?                      | Hatfield               | Hertfordshire          | AL9 7RT   |
    | 10018112 | 118112 | 10018112 Co Ltd | Active | AA018112      | 18112         | 91 Windy Bldgs         | Hullbridge Road        | South Woodham Ferrers  | Chelmsford             | ?                      | Essex                  | CM3 5LJ   |
    | 10018123 | 118123 | 10018123 Co Ltd | Active | AA018123      | ?             | 18 Gratton Ct          | Clare Street           | London                 | ?                      | ?                      | ?                      | EC2A 4LJ  |
    | 10018134 | 118134 | 10018134 Co Ltd | Active | AA018134      | 18134         | 10 West Ave            | St. Mary at Hill       | London                 | ?                      | ?                      | ?                      | EC3R 8EE  |
    | 10018145 | 118145 | 10018145 Co Ltd | Active | AA018145      | 18145-2       | 2 Church Close         | Church Gates           | The Wilderness         | ?                      | Berkhamsted            | Hertfordshire          | HP4 2UB   |
    | 10018156 | 118156 | 10018156 Co Ltd | Active | AA018156      | ?             | 29 Avenue House        | Waterside              | 44 - 48 Wharf Road     | Islington              | London                 | ?                      | N1 7SH    |
   #| 10017358 | 117358 | 10017358 Co Ltd | Active | AA017358      | 17358         | 500 Grant Bldgs        | Chiswick High Road     | London                 | ?                      | ?                      | ?                      | W4 5RG    |

    # Put data in the UKRLP stub  
    And   the following active Organisations exist in the UKRLP stub 
    | UKPRN    | UPIN   | Name            | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018101 | 118101 | 10018101 Co Ltd | XY018101      | ?             | 7 Lansdown House       | Lansdowne Place        | 17 Holdenhurst Road    | ?                      | Bournemouth            | Dorset                 | BH8 8EW   |
    | 10018112 | 118112 | 10018112 Co Ltd | PQ018112      | 18112         | 2440 8th St            | The Quardrant          | Aztec West             | Almondsbury            | Bristol                | ?                      | BS32 4AQ  |
    | 10018123 | 118123 | 10018123 Co Ltd | ?             | 18123         | 4 Buckingham Buildings | Buckingham Court       | Beaufort Park          | Woodlands              | Bristol                | ?                      | BS32 4NF  |
    | 10018134 | 118134 | 10018134 Co Ltd | AA018134      | 18134-1       | 9 Church House         | Quarter Gate           | South Woodham Ferrers  | ?                      | Chelmsford             | Essex                  | CM3 5GT   |
    | 10018145 | 118145 | 10018145 and Co | AA018145      | ?             | Flat 14                | Barnhaven Close        | Wyke Road              | ?                      | Weymouth               | Dorset                 | DT4 9QJ   |
    | 10018156 | 118156 | 10018156 and Co | 00018156      | 18156         | Unit 41                | West Yard              | Camden Lock Place      | Chalk Farm Road        | London                 | ?                      | NW1 8AF   |
   #| 10017358 | 117358 | 10017358 and Co | AA017358      | 17358         | 1 Sherbourne           | Ashley Court           | The High Street        | ?                      | West Dryton            | Middlesex              | UB7 7DN   |

    # Run the update job
    When  the system checks for updated organisations in UKRLP

    # Check that the PaaS Organisation table has been updated
    Then  the following Organisations exist in the FCT Organisation Service 
    | UKPRN    | Name            | Status | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018101 | 10018101 Co Ltd | Active | Yes           | XY018101      | ?             | 7 Lansdown House       | Lansdowne Place        | 17 Holdenhurst Road    | ?                      | Bournemouth            | Dorset                 | BH8 8EW   |
    | 10018112 | 10018112 Co Ltd | Active | Yes           | PQ018112      | 18112         | 2440 8th St            | The Quardrant          | Aztec West             | Almondsbury            | Bristol                | ?                      | BS32 4AQ  |
    | 10018123 | 10018123 Co Ltd | Active | Yes           | ?             | 18123         | 4 Buckingham Buildings | Buckingham Court       | Beaufort Park          | Woodlands              | Bristol                | ?                      | BS32 4NF  |
    | 10018134 | 10018134 Co Ltd | Active | Yes           | AA018134      | 18134-1       | 9 Church House         | Quarter Gate           | South Woodham Ferrers  | ?                      | Chelmsford             | Essex                  | CM3 5GT   |
    | 10018145 | 10018145 Co Ltd | Active | Yes           | AA018145      | ?             | Flat 14                | Barnhaven Close        | Wyke Road              | ?                      | Weymouth               | Dorset                 | DT4 9QJ   |
    | 10018156 | 10018156 Co Ltd | Active | Yes           | 00018156      | 18156         | Unit 41                | West Yard              | Camden Lock Place      | Chalk Farm Road        | London                 | ?                      | NW1 8AF   |
   #| 10017358 | 10017358 Co Ltd | Active | Yes           | AA017358      | 17358         | 1 Sherbourne           | Ashley Court           | The High Street        | ?                      | West Dryton            | Middlesex              | UB7 7DN   |
															
    And   the following Organisations do not exist in the FCT Organisation Service 
    | UKPRN    | 
    | 10017358 | 

    # Check that CRM has been updated
    And   the CRM Organisation table contains the following values
    | UKPRN    | UPIN   | Name            | Status | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10018101 | 118101 | 10018101 Co Ltd | Active | XY018101      | ?             | 7 Lansdown House       | Lansdowne Place        | 17 Holdenhurst Road    | ?                      | Bournemouth            | Dorset                 | BH8 8EW   |
    | 10018112 | 118112 | 10018112 Co Ltd | Active | PQ018112      | 18112         | 2440 8th St            | The Quardrant          | Aztec West             | Almondsbury            | Bristol                | ?                      | BS32 4AQ  |
    | 10018123 | 118123 | 10018123 Co Ltd | Active | ?             | 18123         | 4 Buckingham Buildings | Buckingham Court       | Beaufort Park          | Woodlands              | Bristol                | ?                      | BS32 4NF  |
    | 10018134 | 118134 | 10018134 Co Ltd | Active | AA018134      | 18134-1       | 9 Church House         | Quarter Gate           | South Woodham Ferrers  | ?                      | Chelmsford             | Essex                  | CM3 5GT   |
    | 10018145 | 118145 | 10018145 Co Ltd | Active | AA018145      | ?             | Flat 14                | Barnhaven Close        | Wyke Road              | ?                      | Weymouth               | Dorset                 | DT4 9QJ   |
    | 10018156 | 118156 | 10018156 Co Ltd | Active | 00018156      | 18156         | Unit 41                | West Yard              | Camden Lock Place      | Chalk Farm Road        | London                 | ?                      | NW1 8AF   |
   #| 10017358 | 117358 | 10017358 and Co | Active | AA017358      | 17358         | 1 Sherbourne           | Ashley Court           | The High Street        | ?                      | West Dryton            | Middlesex              | UB7 7DN   |

    And   the following organisations do not exist in the CRM Organisation table
    | UKPRN    | 
    | 10017358 |
	
	# Check that notifications have been created (21138)
	And   the following notifications of type 'Provider Details Updated' related to the 'Contract Managers Team' are present in CRM
	| UKPRN    |  Name						           | Message																  |
	| 10018101 |  Provider Details Updated - 10018101  | Company Number has been updated for provider 10018101 (10018101 Co Ltd)  |
	| 10018101 |  Provider Details Updated - 10018101  | Address has been updated for provider 10018101 (10018101 Co Ltd)         |
	# 
	| 10018112 |  Provider Details Updated - 10018112  | Company Number has been updated for provider 10018112 (10018112 Co Ltd)  |
	| 10018112 |  Provider Details Updated - 10018112  | Address has been updated for provider 10018112 (10018112 Co Ltd)         |
	#
	| 10018123 |  Provider Details Updated - 10018123  | Company Number has been updated for provider 10018123 (10018123 Co Ltd)  |
	| 10018123 |  Provider Details Updated - 10018123  | Charity Number has been updated for provider 10018123 (10018123 Co Ltd)  |
	| 10018123 |  Provider Details Updated - 10018123  | Address has been updated for provider 10018123 (10018123 Co Ltd)         |
	#
	| 10018134 |  Provider Details Updated - 10018134  | Charity Number has been updated for provider 10018134 (10018134 Co Ltd)  |
	| 10018134 |  Provider Details Updated - 10018134  | Address has been updated for provider 10018134 (10018134 Co Ltd)         |
	#
	| 10018145 |  Provider Details Updated - 10018145  | Charity Number has been updated for provider 10018145 (10018145 Co Ltd)  |
	| 10018145 |  Provider Details Updated - 10018145  | Address has been updated for provider 10018145 (10018145 Co Ltd)         |
	#
	| 10018156 |  Provider Details Updated - 10018156  | Company Number has been updated for provider 10018156 (10018156 Co Ltd)  |
	| 10018156 |  Provider Details Updated - 10018156  | Charity Number has been updated for provider 10018156 (10018156 Co Ltd)  |
	| 10018156 |  Provider Details Updated - 10018156  | Address has been updated for provider 10018156 (10018156 Co Ltd)         |


