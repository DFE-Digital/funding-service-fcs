Feature: DASLevyCommitmentInitiation 16104

@AcceptanceTest @Withdrawn20230123
@PublishNewLevyContract
Scenario: A102SLD Create and approve a Levy contract in May 20. Consume three consecutive actuals for LEVY alloc. Check Feed, docs, CRM and PaaS 
    Given there is no Contract, Task or Workflow data for UKPRN '10017102'
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Input-Appendices' for UKPRN '10017102'
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Output-Documents for Publication' for UKPRN '10017102'
    And   the PaaS MonthEndIsRunning indicator is set to 'False'
    And   there is no Levy event data in the DAS agreement stub
    And   there are no entries in the DCFS stub table
    And   there is no data in the MonitoringDeliverables.PaymentInstructionAudit table for UKPRN '10017102'
    And   there are no DAS engagement events stored in FCS
	And   there is no caseload for provider with UKPRN '10017102'
    And   the override date is reset



	# Remove the provider from RoATP (ContractManagement.RoATPProvider)
	And   there is no data on RoATP for the following providers
    | Ukprn    |
    | 10017102 |

    # Add the provider to RoATP (ContractManagement.RoATPProvider)
    # Note: 'Main provider' and 'Employer provider' ProviderTypes are valid and are used to create contracts. 'Supporting provider' ProviderType is not. 
    And   the following providers exist on RoATP 
    | Ukprn    | Name            | ProviderType  | ParentCompanyGuarantee | NewOrganisationWithoutFinancialTrackRecord | StartDate  | 
    | 10017102 | 10017102 Co Ltd | Main provider | False                  | False                                      | 15/03/2017 | 




    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017102' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017102 Co Ltd' with UKPRN '10017102' and OrgId 'ORG0017102' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017102' 
 
    # Put data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017102 | 117102 | 10017102 Co Ltd | 0              | Provider Under Change | Yes           | AA017102      | ?             | 63 Church Way          | Iffley Village         | Oxford                 | ?                      | ?                      | ?                      | OX4 4EG   |

    # Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017102 |




   # Inject data into the stub (16104)
    And   the following Levy event data is available in the DAS agreement stub
    | Id    | Event     | CreatedOn                | ProviderId | ContractType      |
    | 42751 | CREATED   | 2017-02-16T09:31:29.1012 | 10017142   | ProviderAgreement |
    | 42752 | CREATED   | 2017-02-16T09:31:29.1013 | 10017239   | ProviderAgreement |
    | 42753 | CREATED   | 2017-02-16T09:31:29.1015 | 10017224   | ProviderAgreement |
    | 42754 | CREATED   | 2017-02-16T09:31:29.1020 | 10017727   | ProviderAgreement |
    | 42755 | CREATED   | 2017-02-16T09:31:29.1024 | 10017279   | ProviderAgreement |
    | 42756 | CREATED   | 2017-02-16T09:31:29.1026 | 10017624   | ProviderAgreement |
    | 42757 | CREATED   | 2017-02-16T09:31:29.1030 | 10017209   | ProviderAgreement |
    | 42758 | CREATED   | 2017-02-16T09:31:29.1032 | 10017185   | ProviderAgreement |
    | 42759 | CREATED   | 2017-02-16T09:31:29.1035 | 10017691   | ProviderAgreement |
    | 42760 | CREATED   | 2017-02-16T09:31:29.1037 | 10017422   | ProviderAgreement |
    | 42761 | CREATED   | 2017-02-16T09:31:29.1041 | 10017262   | ProviderAgreement |
    | 42762 | CREATED   | 2017-02-16T09:31:29.1044 | 10017278   | ProviderAgreement |
    | 42763 | CREATED   | 2017-02-16T09:31:29.1045 | 10017140   | ProviderAgreement |
    | 42764 | CREATED   | 2017-02-16T09:31:29.1050 | 10017158   | ProviderAgreement |
    | 42765 | CREATED   | 2017-02-16T09:31:29.1055 | 10017287   | ProviderAgreement |
    | 42766 | CREATED   | 2017-02-16T09:31:29.1059 | 10017139   | ProviderAgreement |
    | 42767 | CREATED   | 2017-02-16T09:31:29.1064 | 10017446   | ProviderAgreement |
    | 42768 | CREATED   | 2017-02-16T09:31:29.1067 | 10017408   | ProviderAgreement |
    | 42769 | CREATED   | 2017-02-16T09:31:29.1072 | 10017670   | ProviderAgreement |
    | 42770 | CREATED   | 2017-02-16T09:31:29.1077 | 10017502   | ProviderAgreement |
    | 42771 | CREATED   | 2017-02-16T09:31:29.1078 | 10017647   | ProviderAgreement |
    | 42772 | CREATED   | 2017-02-16T09:31:29.1081 | 10017774   | ProviderAgreement |
    | 42773 | CREATED   | 2017-02-16T09:31:29.1084 | 10017565   | ProviderAgreement |
    | 42774 | CREATED   | 2017-02-16T09:31:29.1085 | 10017606   | ProviderAgreement |
    | 42775 | CREATED   | 2017-02-16T09:31:29.1089 | 10017782   | ProviderAgreement |
    | 42776 | CREATED   | 2017-02-16T09:31:29.1092 | 10017221   | ProviderAgreement |
    | 42777 | CREATED   | 2017-02-16T09:31:29.1097 | 10017292   | ProviderAgreement |
    | 42778 | CREATED   | 2017-02-16T09:31:29.1101 | 10017606   | ProviderAgreement |
    | 42779 | CREATED   | 2017-02-16T09:31:29.1106 | 10017169   | ProviderAgreement |
    | 42780 | CREATED   | 2017-02-16T09:31:29.1108 | 10017176   | ProviderAgreement |
    | 42781 | CREATED   | 2017-02-16T09:31:29.1112 | 10017315   | ProviderAgreement |
    | 42782 | CREATED   | 2017-02-16T09:31:29.1116 | 10017537   | ProviderAgreement |
    | 42783 | CREATED   | 2017-02-16T09:31:29.1117 | 10017501   | ProviderAgreement |
    | 42784 | CREATED   | 2017-02-16T09:31:29.1120 | 10017744   | ProviderAgreement |
    | 42785 | CREATED   | 2017-02-16T09:31:29.1125 | 10017204   | ProviderAgreement |
    | 42786 | CREATED   | 2017-02-16T09:31:29.1127 | 10017659   | ProviderAgreement |
    | 42787 | CREATED   | 2017-02-16T09:31:29.1131 | 10017686   | ProviderAgreement |
    | 42788 | CREATED   | 2017-02-16T09:31:29.1133 | 10017365   | ProviderAgreement |
    | 42789 | CREATED   | 2017-02-16T09:31:29.1137 | 10017357   | ProviderAgreement |
    | 42790 | CREATED   | 2017-02-16T09:31:29.1140 | 10017429   | ProviderAgreement |
    | 42791 | CREATED   | 2017-02-16T09:31:29.1143 | 10017635   | ProviderAgreement |
    | 42792 | CREATED   | 2017-02-16T09:31:29.1146 | 10017283   | ProviderAgreement |
    | 42793 | CREATED   | 2017-02-16T09:31:29.1148 | 10017280   | ProviderAgreement |
    | 42794 | CREATED   | 2017-02-16T09:31:29.1153 | 10017213   | ProviderAgreement |
    | 42795 | CREATED   | 2017-02-16T09:31:29.1154 | 10017224   | ProviderAgreement |
    | 42796 | CREATED   | 2017-02-16T09:31:29.1156 | 10017763   | ProviderAgreement |
    | 42797 | CREATED   | 2017-02-16T09:31:29.1159 | 10017307   | ProviderAgreement |
    | 42798 | CREATED   | 2017-02-16T09:31:29.1161 | 10017261   | ProviderAgreement |
    | 42799 | CREATED   | 2017-02-16T09:31:29.1165 | 10017328   | ProviderAgreement |
    | 42800 | CREATED   | 2017-02-16T09:31:29.1169 | 10017752   | ProviderAgreement |
    | 42801 | CREATED   | 2017-02-16T09:31:29.1170 | 10017566   | ProviderAgreement |
    | 42802 | CREATED   | 2017-02-16T09:31:29.1172 | 10017363   | ProviderAgreement |
    | 42803 | CREATED   | 2017-02-16T09:31:29.1177 | 10017417   | ProviderAgreement |
    | 42804 | CREATED   | 2017-02-16T09:31:29.1179 | 10017278   | ProviderAgreement |
    | 42805 | CREATED   | 2017-02-16T09:31:29.1183 | 10017639   | ProviderAgreement |
    | 42806 | CREATED   | 2017-02-16T09:31:29.1188 | 10017189   | ProviderAgreement |
    | 42807 | CREATED   | 2017-02-16T09:31:29.1191 | 10017271   | ProviderAgreement |
    | 42808 | CREATED   | 2017-02-16T09:31:29.1192 | 10017113   | ProviderAgreement |
    | 42809 | CREATED   | 2017-02-16T09:31:29.1197 | 10017591   | ProviderAgreement |
    | 42810 | CREATED   | 2017-02-16T09:31:29.1199 | 10017320   | ProviderAgreement |
    | 42811 | CREATED   | 2017-02-16T09:31:29.1201 | 10017324   | ProviderAgreement |
    | 42812 | CREATED   | 2017-02-16T09:31:29.1202 | 10017738   | ProviderAgreement |
    | 42813 | CREATED   | 2017-02-16T09:31:29.1205 | 10017627   | ProviderAgreement |
    | 42814 | CREATED   | 2017-02-16T09:31:29.1206 | 10017535   | ProviderAgreement |
    | 42815 | CREATED   | 2017-02-16T09:31:29.1207 | 10017637   | ProviderAgreement |
    | 42816 | CREATED   | 2017-02-16T09:31:29.1211 | 10017625   | ProviderAgreement |
    | 42817 | CREATED   | 2017-02-16T09:31:29.1214 | 10017746   | ProviderAgreement |
    | 42818 | CREATED   | 2017-02-16T09:31:29.1215 | 10017150   | ProviderAgreement |
    | 42819 | CREATED   | 2017-02-16T09:31:29.1217 | 10017549   | ProviderAgreement |
    | 42820 | CREATED   | 2017-02-16T09:31:29.1219 | 10017706   | ProviderAgreement |
    | 42821 | CREATED   | 2017-02-16T09:31:29.1220 | 10017401   | ProviderAgreement |
    | 42822 | CREATED   | 2017-02-16T09:31:29.1221 | 10017423   | ProviderAgreement |
    | 42823 | CREATED   | 2017-02-16T09:31:29.1226 | 10017399   | ProviderAgreement |
    | 42824 | CREATED   | 2017-02-16T09:31:29.1231 | 10017592   | ProviderAgreement |
    | 42825 | CREATED   | 2017-02-16T09:31:29.1235 | 10017216   | ProviderAgreement |
    | 42826 | CREATED   | 2017-02-16T09:31:29.1237 | 10017779   | ProviderAgreement |
    | 42827 | CREATED   | 2017-02-16T09:31:29.1241 | 10017493   | ProviderAgreement |
    | 42828 | CREATED   | 2017-02-16T09:31:29.1245 | 10017293   | ProviderAgreement |
    | 42829 | CREATED   | 2017-02-16T09:31:29.1247 | 10017266   | ProviderAgreement |
    | 42830 | CREATED   | 2017-02-16T09:31:29.1251 | 10017521   | ProviderAgreement |
    | 42831 | CREATED   | 2017-02-16T09:31:29.1255 | 10017761   | ProviderAgreement |
    | 42832 | CREATED   | 2017-02-16T09:31:29.1256 | 10017556   | ProviderAgreement |
    | 42833 | CREATED   | 2017-02-16T09:31:29.1261 | 10017422   | ProviderAgreement |
    | 42834 | CREATED   | 2017-02-16T09:31:29.1262 | 10017556   | ProviderAgreement |
    | 42835 | CREATED   | 2017-02-16T09:31:29.1263 | 10017416   | ProviderAgreement |
    | 42836 | CREATED   | 2017-02-16T09:31:29.1267 | 10017467   | ProviderAgreement |
    | 42837 | CREATED   | 2017-02-16T09:31:29.1268 | 10017696   | ProviderAgreement |
    | 42838 | CREATED   | 2017-02-16T09:31:29.1272 | 10017295   | ProviderAgreement |
    | 42839 | CREATED   | 2017-02-16T09:31:29.1274 | 10017353   | ProviderAgreement |
    | 42840 | CREATED   | 2017-02-16T09:31:29.1278 | 10017540   | ProviderAgreement |
    | 42841 | CREATED   | 2017-02-16T09:31:29.1281 | 10017207   | ProviderAgreement |
    | 42842 | CREATED   | 2017-02-16T09:31:29.1285 | 10017751   | ProviderAgreement |
    | 42843 | CREATED   | 2017-02-16T09:31:29.1289 | 10017751   | ProviderAgreement |
    | 42844 | CREATED   | 2017-02-16T09:31:29.1293 | 10017309   | ProviderAgreement |
    | 42845 | CREATED   | 2017-02-16T09:31:29.1294 | 10017276   | ProviderAgreement |
    | 42846 | CREATED   | 2017-02-16T09:31:29.1298 | 10017756   | ProviderAgreement |
    | 42847 | CREATED   | 2017-02-16T09:31:29.1303 | 10017723   | ProviderAgreement |
    | 42848 | CREATED   | 2017-02-16T09:31:29.1308 | 10017739   | ProviderAgreement |
    | 42849 | CREATED   | 2017-02-16T09:31:29.1309 | 10017647   | ProviderAgreement |
    | 42850 | CREATED   | 2017-02-16T09:31:29.1310 | 10017744   | ProviderAgreement |
    | 42851 | CREATED   | 2017-02-16T09:31:29.1314 | 10017727   | ProviderAgreement |
    | 42852 | INITIATED | 2017-02-16T09:31:29.1317 | 10017102   | ProviderAgreement |
    | 42853 | CREATED   | 2017-02-16T09:31:29.1318 | 10017513   | ProviderAgreement |
    | 42854 | CREATED   | 2017-02-16T09:31:29.1320 | 10017341   | ProviderAgreement |
    | 42855 | CREATED   | 2017-02-16T09:31:29.1321 | 10017156   | ProviderAgreement |
    | 42856 | CREATED   | 2017-02-16T09:31:29.1325 | 10017149   | ProviderAgreement |
    | 42857 | CREATED   | 2017-02-16T09:31:29.1327 | 10017241   | ProviderAgreement |
    | 42858 | CREATED   | 2017-02-16T09:31:29.1332 | 10017774   | ProviderAgreement |
    | 42859 | CREATED   | 2017-02-16T09:31:29.1336 | 10017433   | ProviderAgreement |
    | 42860 | CREATED   | 2017-02-16T09:31:29.1340 | 10017293   | ProviderAgreement |
    | 42861 | CREATED   | 2017-02-16T09:31:29.1344 | 10017336   | ProviderAgreement |
    | 42862 | CREATED   | 2017-02-16T09:31:29.1345 | 10017403   | ProviderAgreement |
    | 42863 | CREATED   | 2017-02-16T09:31:29.1347 | 10017543   | ProviderAgreement |
    | 42864 | CREATED   | 2017-02-16T09:31:29.1349 | 10017681   | ProviderAgreement |
    | 42865 | CREATED   | 2017-02-16T09:31:29.1352 | 10017411   | ProviderAgreement |
    | 42866 | CREATED   | 2017-02-16T09:31:29.1355 | 10017564   | ProviderAgreement |
    | 42867 | CREATED   | 2017-02-16T09:31:29.1359 | 10017129   | ProviderAgreement |
    | 42868 | CREATED   | 2017-02-16T09:31:29.1364 | 10017140   | ProviderAgreement |
    | 42869 | CREATED   | 2017-02-16T09:31:29.1367 | 10017219   | ProviderAgreement |
    | 42870 | CREATED   | 2017-02-16T09:31:29.1371 | 10017410   | ProviderAgreement |
    | 42871 | CREATED   | 2017-02-16T09:31:29.1374 | 10017514   | ProviderAgreement |
    | 42872 | CREATED   | 2017-02-16T09:31:29.1379 | 10017299   | ProviderAgreement |
    | 42873 | CREATED   | 2017-02-16T09:31:29.1383 | 10017685   | ProviderAgreement |
    | 42874 | CREATED   | 2017-02-16T09:31:29.1388 | 10017697   | ProviderAgreement |
    | 42875 | CREATED   | 2017-02-16T09:31:29.1390 | 10017247   | ProviderAgreement |

    When  the Levy event data is pulled from the DAS agreement stub
    And   the Levy contract is created in CRM for UKPRN '10017102'

    Then  there is only one Levy contract in CRM for UKPRN '10017102' with a status of 'Draft' 
 
    # I need this step in this format to allow time for the contract to be created so that the parameters can be retrieved correctly by the next step 
    And   the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber | 
    | Draft  | Published to Provider  | Yes           | No                  | 1                     | 

    # Retrieve parameters from CRM  
   #When  I retrieve the latest EFA contract details from CRM for provider '10017102' for FundingType 'LEVY' and period '1799' and Delivery Organisation '10017088' 
    And   I retrieve the latest contract details from CRM for provider '10017102' for FundingType 'LEVY' and period '1799' 




    # Check the contract has been created ok 
    Then  the draft contract header details for the new Levy contract are as follows 
    | UKPRN    | LegalName            | FundingType | MasterContractNumber | ContractNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | PeriodTypeCode | Period | CRMIntent    | OrgId      | 
    | 10017102 | 10017102 Co Ltd      | LEVY        | [MasterContractNo]   | [ContractNo]   | 01/05/2017        | ?               | 0.00          | Provider Agreement    | LEVY           | 1799   | New          | ORG0017102 | 
 
    And   the draft Levy contract allocations details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | FundingStreamPeriodCode | ContractNumber | AllocationRef       | AllocationStartDate | AllocationEndDate | AllocationValue | CRMIntent    | PeriodTypeCode | Period | 
    | 10017102 | LEVY              | LEVY1799                | [ContractNo]   | [AllocRef_LEVY]     | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   | 
    | 10017102 | NONLEVY           | NONLEVY2019             | [ContractNo]   | [AllocRef_NLA]      | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   | 
 
    And   the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | May-17   | DeliverableDescription                | 
    | 10017102 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships      | 
    | 10017102 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships      | 
    | 10017102 | NONLEVY           | [AllocRef_NLA]      | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships  | 
    | 10017102 | NONLEVY           | [AllocRef_NLA]      | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships  | 
 
    And   there are no open tasks for the contract 
    And   there is no contract owner assigned to the latest version of the contract 
 
    # Check deliverable period count prior to approval 
    And   there are '4' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 




   # Check Atom feed data for a type 1 'Published to Provider' event
    And   the ContractManagement.AtomFeedItem table contains one ItemType '1' event for contract number '[ContractNo]'
    And   the ItemType '1' event for contract number '[ContractNo]' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017102_[ContractNo]_v1.pdf' in 'LEVY-1799-Output-Documents for Publication' is copied to 'Datafiles/Downloads' as '10017102_APPLEVY-102_v1.pdf'

   # Check Contract documentation (16390)
    And   a file named '10017102_' & '[ContractNo]' & '_v1.pdf' does not exist in sharepoint location 'LEVY-1799-Input-Appendices'
    And   the file named '10017102_[ContractNo]_v1.pdf' in Sharepoint location 'LEVY-1799-Output-Documents for Publication' contains the following lines in order 
    """
    Department for Education Apprenticeship Agreement for Training
    Providers
    Terms and Conditions
    THIS AGREEMENT is made on the date the Agreement is digitally signed by the Training
    Provider through the Manage Your Education and Skills Funding Service having
    already been signed by the Department and is between:
    10017102 Co Ltd THE SECRETARY OF STATE FOR
    63 Church Way EDUCATION
    Iffley Village DEPARTMENT FOR
    Oxford EDUCATION
    AND
    OX4 4EG 20 GREAT SMITH STREET
    LONDON
    SW1P 3BT
    Company No: AA017102
    UKPRN: 10017102
    Referred to in this Agreement as “the Referred to in this Agreement as “the
    Training Provider” Department”
    “Expiry Date” means 31 July 2025 or such later date as is notified in writing by
    Department for Education Apprenticeship Agreement for Training Providers, Winter 2022, Version
    4.1
    Education & Skills Funding Agency
    Education and Skills Funding Agency - GOV.UK (www.gov.uk)
    56
    """

    # The Amendment Letter is not included
    And   the pdf file does not contain the following text
    """
    Agreement number: [MasterContractNo] 
    """




    # Change the date
    Given the override date is '04/05/2020'

	# Approve the contract (15397)
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    
    # Check deliverable period count after approval 
    Then  there are '28' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 
 
    # After approval there should be a May-20 deliverable period for each of deliverables 1 through 14 for each allocation
    Then   the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | May-20   | DeliverableDescription                               | 
    | 10017102 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships                     | 
    | 10017102 | LEVY              | [AllocRef_LEVY]     | 2               | 1                     | ?        | 0.00     | 16-18 Levy - Levy Funded                             | 
    | 10017102 | LEVY              | [AllocRef_LEVY]     | 3               | 1                     | ?        | 0.00     | 16-18 Levy - Co-Invested                             | 
    | 10017102 | LEVY              | [AllocRef_LEVY]     | 4               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Learning Support        | 
    | 10017102 | LEVY              | [AllocRef_LEVY]     | 5               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Other                   | 
    | 10017102 | LEVY              | [AllocRef_LEVY]     | 6               | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Employers       | 
    | 10017102 | LEVY              | [AllocRef_LEVY]     | 13              | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Individuals     | 
    | 10017102 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships                     | 
    | 10017102 | LEVY              | [AllocRef_LEVY]     | 8               | 7                     | ?        | 0.00     | Adult Levy - Levy Funded                             | 
    | 10017102 | LEVY              | [AllocRef_LEVY]     | 9               | 7                     | ?        | 0.00     | Adult Levy - Co-Invested                             | 
    | 10017102 | LEVY              | [AllocRef_LEVY]     | 10              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Learning Support        | 
    | 10017102 | LEVY              | [AllocRef_LEVY]     | 11              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Other                   | 
    | 10017102 | LEVY              | [AllocRef_LEVY]     | 12              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Employers       | 
    | 10017102 | LEVY              | [AllocRef_LEVY]     | 14              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Individuals     | 
     
    | 10017102 | NONLEVY           | [AllocRef_NLA]      | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships                 | 
    | 10017102 | NONLEVY           | [AllocRef_NLA]      | 2               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Levy Funded                         | 
    | 10017102 | NONLEVY           | [AllocRef_NLA]      | 3               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Co-Invested                         | 
    | 10017102 | NONLEVY           | [AllocRef_NLA]      | 4               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Learning Support    | 
    | 10017102 | NONLEVY           | [AllocRef_NLA]      | 5               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Other               | 
    | 10017102 | NONLEVY           | [AllocRef_NLA]      | 6               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Employers   | 
    | 10017102 | NONLEVY           | [AllocRef_NLA]      | 7               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Individuals | 
    | 10017102 | NONLEVY           | [AllocRef_NLA]      | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships                 | 
    | 10017102 | NONLEVY           | [AllocRef_NLA]      | 9               | 8                     | ?        | 0.00     | Adult Non-Levy - Levy Funded                         | 
    | 10017102 | NONLEVY           | [AllocRef_NLA]      | 10              | 8                     | ?        | 0.00     | Adult Non-Levy - Co-Invested                         | 
    | 10017102 | NONLEVY           | [AllocRef_NLA]      | 11              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Learning Support    | 
    | 10017102 | NONLEVY           | [AllocRef_NLA]      | 12              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Other               | 
    | 10017102 | NONLEVY           | [AllocRef_NLA]      | 13              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Employers   | 
    | 10017102 | NONLEVY           | [AllocRef_NLA]      | 14              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Individuals | 

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017102 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 04/05/2020        | ?               | ?             |
    | 10017102 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/05/2017        | ?               | ?             |

	# Check the Workflow History
    And   the following workflow history entries are present on the latest version of the contract
    | Action                                         | CompletedBy       | Previous Contract Owner | New Contract Owner | 
    | Confirm Receipt of Digital Signature           | CRM Integration   | ?                       | ?                  |
    | Document Published For Digital Sign Off        | CRM Integration   | ?                       | ?                  |
    | Skip Review and Internal Approval              | CRM Integration   | ?                       | ?                  |

    # Check Atom feed data for a type 0 'Approved' event
    And   the ContractManagement.AtomFeedItem table contains one ItemType '0' event for contract number '[ContractNo]'
    And   the ItemType '0' event for contract number '[ContractNo]' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema



    
	# Change the date 
    Given the override date is '07/06/2020'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals 
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS

	# Pull DCFS PoI actuals for May 2020 (17384) 
    And   the following closed collections are available in DCFS
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode | DeliverableCode | ActualVolume | ActualValue |
    | APPS           | APPS37               | ORG0017102     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]          |         | 2               | 0            | 417.41      |
    | APPS           | APPS37               | ORG0017102     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]          |         | 3               | 0            | 421.21      |
    | APPS           | APPS37               | ORG0017102     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]          |         | 4               | 0            | 105.55      |
    | APPS           | APPS37               | ORG0017102     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]          |         | 5               | 0            | 0.00        |
    | APPS           | APPS37               | ORG0017102     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]          |         | 6               | 0            | 267.05      |
    | APPS           | APPS37               | ORG0017102     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]          |         | 8               | 0            | 1168.10     |
    | APPS           | APPS37               | ORG0017102     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]          |         | 9               | 0            | 228.41      |
    | APPS           | APPS37               | ORG0017102     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]          |         | 10              | 0            | 0.00        |
    | APPS           | APPS37               | ORG0017102     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]          |         | 11              | 0            | 260.74      |
    | APPS           | APPS37               | ORG0017102     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]          |         | 12              | 0            | 0.00        |
    #
	| APPS           | APPS37               | ORG0017102     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]          |         | 2               | 0            | 0.00        |
    | APPS           | APPS37               | ORG0017102     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]          |         | 3               | 0            | 773.25      |
    | APPS           | APPS37               | ORG0017102     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]          |         | 4               | 0            | 1192.86     |
    | APPS           | APPS37               | ORG0017102     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]          |         | 5               | 0            | 1322.41     |
    | APPS           | APPS37               | ORG0017102     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]          |         | 6               | 0            | 1115.85     |
    | APPS           | APPS37               | ORG0017102     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]          |         | 8               | 0            | 1353.98     |
    | APPS           | APPS37               | ORG0017102     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]          |         | 9               | 0            | 1121.85     |
    | APPS           | APPS37               | ORG0017102     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]          |         | 10              | 0            | 605.32      |
    | APPS           | APPS37               | ORG0017102     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]          |         | 11              | 0            | 759.83      |
    | APPS           | APPS37               | ORG0017102     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]          |         | 12              | 0            | 329.56      |
    #
	| APPS           | APPS37               | ORG0017102     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]          |         | 2               | 0            | 0.00        |
    | APPS           | APPS37               | ORG0017102     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]          |         | 3               | 0            | 0.00        |
    | APPS           | APPS37               | ORG0017102     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]          |         | 4               | 0            | 0.00        |
    | APPS           | APPS37               | ORG0017102     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]          |         | 5               | 0            | 559.64      |
    | APPS           | APPS37               | ORG0017102     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]          |         | 6               | 0            | 324.57      |
    | APPS           | APPS37               | ORG0017102     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]          |         | 8               | 0            | 1295.61     |
    | APPS           | APPS37               | ORG0017102     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]          |         | 9               | 0            | 1264.76     |
    | APPS           | APPS37               | ORG0017102     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]          |         | 10              | 0            | 0.00        |
    | APPS           | APPS37               | ORG0017102     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]          |         | 11              | 0            | -114.50     |
    | APPS           | APPS37               | ORG0017102     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]          |         | 12              | 0            | 187.84      |
    #
	| APPS           | APPS37               | ORG0017102     | CM             | 202008 | LEVY1799                | [AllocRef_LEVY]          |         | 2               | 0            | 0.00        |
    | APPS           | APPS37               | ORG0017102     | CM             | 202008 | LEVY1799                | [AllocRef_LEVY]          |         | 3               | 0            | 1479.52     |
    | APPS           | APPS37               | ORG0017102     | CM             | 202008 | LEVY1799                | [AllocRef_LEVY]          |         | 4               | 0            | 717.72      |
    | APPS           | APPS37               | ORG0017102     | CM             | 202008 | LEVY1799                | [AllocRef_LEVY]          |         | 5               | 0            | 162.31      |
    | APPS           | APPS37               | ORG0017102     | CM             | 202008 | LEVY1799                | [AllocRef_LEVY]          |         | 6               | 0            | 19.98       |
    | APPS           | APPS37               | ORG0017102     | CM             | 202008 | LEVY1799                | [AllocRef_LEVY]          |         | 8               | 0            | 0.00        |
    | APPS           | APPS37               | ORG0017102     | CM             | 202008 | LEVY1799                | [AllocRef_LEVY]          |         | 9               | 0            | -50.01      |
    | APPS           | APPS37               | ORG0017102     | CM             | 202008 | LEVY1799                | [AllocRef_LEVY]          |         | 10              | 0            | 877.86      |
    | APPS           | APPS37               | ORG0017102     | CM             | 202008 | LEVY1799                | [AllocRef_LEVY]          |         | 11              | 0            | 285.82      |
    | APPS           | APPS37               | ORG0017102     | CM             | 202008 | LEVY1799                | [AllocRef_LEVY]          |         | 12              | 0            | 0.00        |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    Then  the following data is present in the MonitoringDeliverables.PaymentInstructionAudit table for UKPRN '10017102'
    | CollectionReturnPeriod | OrganisationId | FundingStreamPeriodCode | DeliverableCode | Period | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | AllocationStartDate | CollectionReturnCode | CollectionType | PaymentValue | ContractAllocation Number |
    | 202005                 | ORG0017102     | LEVY1799                | 2               | 202005 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS37               | APPS           | 417.41       | [AllocRef_LEVY]           |
    | 202005                 | ORG0017102     | LEVY1799                | 3               | 202005 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS37               | APPS           | 421.21       | [AllocRef_LEVY]           |
    | 202005                 | ORG0017102     | LEVY1799                | 4               | 202005 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS37               | APPS           | 105.55       | [AllocRef_LEVY]           |
    | 202005                 | ORG0017102     | LEVY1799                | 5               | 202005 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS37               | APPS           | 0.00         | [AllocRef_LEVY]           |
    | 202005                 | ORG0017102     | LEVY1799                | 6               | 202005 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS37               | APPS           | 267.05       | [AllocRef_LEVY]           |
    | 202005                 | ORG0017102     | LEVY1799                | 8               | 202005 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS37               | APPS           | 1168.10      | [AllocRef_LEVY]           |
    | 202005                 | ORG0017102     | LEVY1799                | 9               | 202005 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS37               | APPS           | 228.41       | [AllocRef_LEVY]           |
    | 202005                 | ORG0017102     | LEVY1799                | 10              | 202005 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS37               | APPS           | 0.00         | [AllocRef_LEVY]           |
    | 202005                 | ORG0017102     | LEVY1799                | 11              | 202005 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS37               | APPS           | 260.74       | [AllocRef_LEVY]           |
    | 202005                 | ORG0017102     | LEVY1799                | 12              | 202005 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS37               | APPS           | 0.00         | [AllocRef_LEVY]           |

    And   there are '10' rows in the MonitoringDeliverables.PaymentInstructionAudit table for UKPRN '10017102'


    

    # Change the date
	Given the override date is '07/07/2020'

	# Pull DCFS PoI actuals for June 2020 (17384) 
    And   the following closed collections are available in DCFS
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode | DeliverableCode | ActualVolume | ActualValue |
    | APPS           | APPS38               | ORG0017102     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]          |         | 2               | 0            | 417.41      |
    | APPS           | APPS38               | ORG0017102     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]          |         | 3               | 0            | 421.21      |
    | APPS           | APPS38               | ORG0017102     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]          |         | 4               | 0            | 105.55      |
    | APPS           | APPS38               | ORG0017102     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]          |         | 5               | 0            | 0.00        |
    | APPS           | APPS38               | ORG0017102     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]          |         | 6               | 0            | 267.05      |
    | APPS           | APPS38               | ORG0017102     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]          |         | 8               | 0            | 1168.10     |
    | APPS           | APPS38               | ORG0017102     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]          |         | 9               | 0            | 228.41      |
    | APPS           | APPS38               | ORG0017102     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]          |         | 10              | 0            | 0.00        |
    | APPS           | APPS38               | ORG0017102     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]          |         | 11              | 0            | 260.74      |
    | APPS           | APPS38               | ORG0017102     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]          |         | 12              | 0            | 0.00        |
    #
	| APPS           | APPS38               | ORG0017102     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]          |         | 2               | 0            | 0.00        |
    | APPS           | APPS38               | ORG0017102     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]          |         | 3               | 0            | 773.25      |
    | APPS           | APPS38               | ORG0017102     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]          |         | 4               | 0            | 1192.86     |
    | APPS           | APPS38               | ORG0017102     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]          |         | 5               | 0            | 1322.41     |
    | APPS           | APPS38               | ORG0017102     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]          |         | 6               | 0            | 1115.85     |
    | APPS           | APPS38               | ORG0017102     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]          |         | 8               | 0            | 1353.98     |
    | APPS           | APPS38               | ORG0017102     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]          |         | 9               | 0            | 1121.85     |
    | APPS           | APPS38               | ORG0017102     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]          |         | 10              | 0            | 605.32      |
    | APPS           | APPS38               | ORG0017102     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]          |         | 11              | 0            | 759.83      |
    | APPS           | APPS38               | ORG0017102     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]          |         | 12              | 0            | 329.56      |
    #
	| APPS           | APPS38               | ORG0017102     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]          |         | 2               | 0            | 0.00        |
    | APPS           | APPS38               | ORG0017102     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]          |         | 3               | 0            | 0.00        |
    | APPS           | APPS38               | ORG0017102     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]          |         | 4               | 0            | 0.00        |
    | APPS           | APPS38               | ORG0017102     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]          |         | 5               | 0            | 559.64      |
    | APPS           | APPS38               | ORG0017102     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]          |         | 6               | 0            | 324.57      |
    | APPS           | APPS38               | ORG0017102     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]          |         | 8               | 0            | 1295.61     |
    | APPS           | APPS38               | ORG0017102     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]          |         | 9               | 0            | 1264.76     |
    | APPS           | APPS38               | ORG0017102     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]          |         | 10              | 0            | 0.00        |
    | APPS           | APPS38               | ORG0017102     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]          |         | 11              | 0            | -114.50     |
    | APPS           | APPS38               | ORG0017102     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]          |         | 12              | 0            | 187.84      |
    #
	| APPS           | APPS38               | ORG0017102     | CM             | 202008 | LEVY1799                | [AllocRef_LEVY]          |         | 2               | 0            | 0.00        |
    | APPS           | APPS38               | ORG0017102     | CM             | 202008 | LEVY1799                | [AllocRef_LEVY]          |         | 3               | 0            | 1479.52     |
    | APPS           | APPS38               | ORG0017102     | CM             | 202008 | LEVY1799                | [AllocRef_LEVY]          |         | 4               | 0            | 717.72      |
    | APPS           | APPS38               | ORG0017102     | CM             | 202008 | LEVY1799                | [AllocRef_LEVY]          |         | 5               | 0            | 162.31      |
    | APPS           | APPS38               | ORG0017102     | CM             | 202008 | LEVY1799                | [AllocRef_LEVY]          |         | 6               | 0            | 19.98       |
    | APPS           | APPS38               | ORG0017102     | CM             | 202008 | LEVY1799                | [AllocRef_LEVY]          |         | 8               | 0            | 0.00        |
    | APPS           | APPS38               | ORG0017102     | CM             | 202008 | LEVY1799                | [AllocRef_LEVY]          |         | 9               | 0            | -50.01      |
    | APPS           | APPS38               | ORG0017102     | CM             | 202008 | LEVY1799                | [AllocRef_LEVY]          |         | 10              | 0            | 877.86      |
    | APPS           | APPS38               | ORG0017102     | CM             | 202008 | LEVY1799                | [AllocRef_LEVY]          |         | 11              | 0            | 285.82      |
    | APPS           | APPS38               | ORG0017102     | CM             | 202008 | LEVY1799                | [AllocRef_LEVY]          |         | 12              | 0            | 0.00        |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    Then  the following data is present in the MonitoringDeliverables.PaymentInstructionAudit table for UKPRN '10017102'
    | CollectionReturnPeriod | OrganisationId | FundingStreamPeriodCode | DeliverableCode | Period | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | AllocationStartDate | CollectionReturnCode | CollectionType | PaymentValue | ContractAllocation Number |
    | 202005                 | ORG0017102     | LEVY1799                | 2               | 202005 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS37               | APPS           | 417.41       | [AllocRef_LEVY]           |
    | 202005                 | ORG0017102     | LEVY1799                | 3               | 202005 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS37               | APPS           | 421.21       | [AllocRef_LEVY]           |
    | 202005                 | ORG0017102     | LEVY1799                | 4               | 202005 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS37               | APPS           | 105.55       | [AllocRef_LEVY]           |
    | 202005                 | ORG0017102     | LEVY1799                | 5               | 202005 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS37               | APPS           | 0.00         | [AllocRef_LEVY]           |
    | 202005                 | ORG0017102     | LEVY1799                | 6               | 202005 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS37               | APPS           | 267.05       | [AllocRef_LEVY]           |
    | 202005                 | ORG0017102     | LEVY1799                | 8               | 202005 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS37               | APPS           | 1168.10      | [AllocRef_LEVY]           |
    | 202005                 | ORG0017102     | LEVY1799                | 9               | 202005 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS37               | APPS           | 228.41       | [AllocRef_LEVY]           |
    | 202005                 | ORG0017102     | LEVY1799                | 10              | 202005 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS37               | APPS           | 0.00         | [AllocRef_LEVY]           |
    | 202005                 | ORG0017102     | LEVY1799                | 11              | 202005 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS37               | APPS           | 260.74       | [AllocRef_LEVY]           |
    | 202005                 | ORG0017102     | LEVY1799                | 12              | 202005 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS37               | APPS           | 0.00         | [AllocRef_LEVY]           |
    #
	| 202006                 | ORG0017102     | LEVY1799                | 2               | 202006 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS38               | APPS           | 0.00         | [AllocRef_LEVY]           |
    | 202006                 | ORG0017102     | LEVY1799                | 3               | 202006 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS38               | APPS           | 773.25       | [AllocRef_LEVY]           |
    | 202006                 | ORG0017102     | LEVY1799                | 4               | 202006 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS38               | APPS           | 1192.86      | [AllocRef_LEVY]           |
    | 202006                 | ORG0017102     | LEVY1799                | 5               | 202006 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS38               | APPS           | 1322.41      | [AllocRef_LEVY]           |
    | 202006                 | ORG0017102     | LEVY1799                | 6               | 202006 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS38               | APPS           | 1115.85      | [AllocRef_LEVY]           |
    | 202006                 | ORG0017102     | LEVY1799                | 8               | 202006 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS38               | APPS           | 1353.98      | [AllocRef_LEVY]           |
    | 202006                 | ORG0017102     | LEVY1799                | 9               | 202006 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS38               | APPS           | 1121.85      | [AllocRef_LEVY]           |
    | 202006                 | ORG0017102     | LEVY1799                | 10              | 202006 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS38               | APPS           | 605.32       | [AllocRef_LEVY]           |
    | 202006                 | ORG0017102     | LEVY1799                | 11              | 202006 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS38               | APPS           | 759.83       | [AllocRef_LEVY]           |
    | 202006                 | ORG0017102     | LEVY1799                | 12              | 202006 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS38               | APPS           | 329.56       | [AllocRef_LEVY]           |

    And   there are '20' rows in the MonitoringDeliverables.PaymentInstructionAudit table for UKPRN '10017102'




    # Change the date
	Given the override date is '07/08/2020'

	# Pull DCFS PoI actuals for July 2020 (17384)   
    And   the following closed collections are available in DCFS
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber | UoPCode | DeliverableCode | ActualVolume | ActualValue |
    | APPS           | APPS39               | ORG0017102     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]          |         | 2               | 0            | 417.41      |
    | APPS           | APPS39               | ORG0017102     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]          |         | 3               | 0            | 421.21      |
    | APPS           | APPS39               | ORG0017102     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]          |         | 4               | 0            | 105.55      |
    | APPS           | APPS39               | ORG0017102     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]          |         | 5               | 0            | 0.00        |
    | APPS           | APPS39               | ORG0017102     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]          |         | 6               | 0            | 267.05      |
    | APPS           | APPS39               | ORG0017102     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]          |         | 8               | 0            | 1168.10     |
    | APPS           | APPS39               | ORG0017102     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]          |         | 9               | 0            | 228.41      |
    | APPS           | APPS39               | ORG0017102     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]          |         | 10              | 0            | 0.00        |
    | APPS           | APPS39               | ORG0017102     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]          |         | 11              | 0            | 260.74      |
    | APPS           | APPS39               | ORG0017102     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]          |         | 12              | 0            | 0.00        |
    #
	| APPS           | APPS39               | ORG0017102     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]          |         | 2               | 0            | 0.00        |
    | APPS           | APPS39               | ORG0017102     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]          |         | 3               | 0            | 773.25      |
    | APPS           | APPS39               | ORG0017102     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]          |         | 4               | 0            | 1192.86     |
    | APPS           | APPS39               | ORG0017102     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]          |         | 5               | 0            | 1322.41     |
    | APPS           | APPS39               | ORG0017102     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]          |         | 6               | 0            | 1115.85     |
    | APPS           | APPS39               | ORG0017102     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]          |         | 8               | 0            | 1353.98     |
    | APPS           | APPS39               | ORG0017102     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]          |         | 9               | 0            | 1121.85     |
    | APPS           | APPS39               | ORG0017102     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]          |         | 10              | 0            | 605.32      |
    | APPS           | APPS39               | ORG0017102     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]          |         | 11              | 0            | 759.83      |
    | APPS           | APPS39               | ORG0017102     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]          |         | 12              | 0            | 329.56      |
    #
	| APPS           | APPS39               | ORG0017102     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]          |         | 2               | 0            | 0.00        |
	| APPS           | APPS39               | ORG0017102     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]          |         | 3               | 0            | 0.00        |
    | APPS           | APPS39               | ORG0017102     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]          |         | 4               | 0            | 0.00        |
    | APPS           | APPS39               | ORG0017102     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]          |         | 5               | 0            | 559.64      |
    | APPS           | APPS39               | ORG0017102     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]          |         | 6               | 0            | 324.57      |
    | APPS           | APPS39               | ORG0017102     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]          |         | 8               | 0            | 1295.61     |
    | APPS           | APPS39               | ORG0017102     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]          |         | 9               | 0            | 1264.76     |
    | APPS           | APPS39               | ORG0017102     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]          |         | 10              | 0            | 0.00        |
    | APPS           | APPS39               | ORG0017102     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]          |         | 11              | 0            | -114.50     |
    | APPS           | APPS39               | ORG0017102     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]          |         | 12              | 0            | 187.84      |
    #
	| APPS           | APPS39               | ORG0017102     | CM             | 202008 | LEVY1799                | [AllocRef_LEVY]          |         | 2               | 0            | 0.00        |
	| APPS           | APPS39               | ORG0017102     | CM             | 202008 | LEVY1799                | [AllocRef_LEVY]          |         | 3               | 0            | 1479.52     |
    | APPS           | APPS39               | ORG0017102     | CM             | 202008 | LEVY1799                | [AllocRef_LEVY]          |         | 4               | 0            | 717.72      |
    | APPS           | APPS39               | ORG0017102     | CM             | 202008 | LEVY1799                | [AllocRef_LEVY]          |         | 5               | 0            | 162.31      |
    | APPS           | APPS39               | ORG0017102     | CM             | 202008 | LEVY1799                | [AllocRef_LEVY]          |         | 6               | 0            | 19.98       |
    | APPS           | APPS39               | ORG0017102     | CM             | 202008 | LEVY1799                | [AllocRef_LEVY]          |         | 8               | 0            | 0.00        |
    | APPS           | APPS39               | ORG0017102     | CM             | 202008 | LEVY1799                | [AllocRef_LEVY]          |         | 9               | 0            | -50.01      |
    | APPS           | APPS39               | ORG0017102     | CM             | 202008 | LEVY1799                | [AllocRef_LEVY]          |         | 10              | 0            | 877.86      |
    | APPS           | APPS39               | ORG0017102     | CM             | 202008 | LEVY1799                | [AllocRef_LEVY]          |         | 11              | 0            | 285.82      |
    | APPS           | APPS39               | ORG0017102     | CM             | 202008 | LEVY1799                | [AllocRef_LEVY]          |         | 12              | 0            | 0.00        |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    Then  the following data is present in the MonitoringDeliverables.PaymentInstructionAudit table for UKPRN '10017102'
    | CollectionReturnPeriod | OrganisationId | FundingStreamPeriodCode | DeliverableCode | Period | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | AllocationStartDate | CollectionReturnCode | CollectionType | PaymentValue | ContractAllocation Number |
    | 202005                 | ORG0017102     | LEVY1799                | 2               | 202005 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS37               | APPS           | 417.41       | [AllocRef_LEVY]           |
    | 202005                 | ORG0017102     | LEVY1799                | 3               | 202005 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS37               | APPS           | 421.21       | [AllocRef_LEVY]           |
    | 202005                 | ORG0017102     | LEVY1799                | 4               | 202005 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS37               | APPS           | 105.55       | [AllocRef_LEVY]           |
    | 202005                 | ORG0017102     | LEVY1799                | 5               | 202005 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS37               | APPS           | 0.00         | [AllocRef_LEVY]           |
    | 202005                 | ORG0017102     | LEVY1799                | 6               | 202005 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS37               | APPS           | 267.05       | [AllocRef_LEVY]           |
    | 202005                 | ORG0017102     | LEVY1799                | 8               | 202005 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS37               | APPS           | 1168.10      | [AllocRef_LEVY]           |
    | 202005                 | ORG0017102     | LEVY1799                | 9               | 202005 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS37               | APPS           | 228.41       | [AllocRef_LEVY]           |
    | 202005                 | ORG0017102     | LEVY1799                | 10              | 202005 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS37               | APPS           | 0.00         | [AllocRef_LEVY]           |
    | 202005                 | ORG0017102     | LEVY1799                | 11              | 202005 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS37               | APPS           | 260.74       | [AllocRef_LEVY]           |
    | 202005                 | ORG0017102     | LEVY1799                | 12              | 202005 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS37               | APPS           | 0.00         | [AllocRef_LEVY]           |
    #
	| 202006                 | ORG0017102     | LEVY1799                | 2               | 202006 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS38               | APPS           | 0.00         | [AllocRef_LEVY]           |
    | 202006                 | ORG0017102     | LEVY1799                | 3               | 202006 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS38               | APPS           | 773.25       | [AllocRef_LEVY]           |
    | 202006                 | ORG0017102     | LEVY1799                | 4               | 202006 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS38               | APPS           | 1192.86      | [AllocRef_LEVY]           |
    | 202006                 | ORG0017102     | LEVY1799                | 5               | 202006 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS38               | APPS           | 1322.41      | [AllocRef_LEVY]           |
    | 202006                 | ORG0017102     | LEVY1799                | 6               | 202006 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS38               | APPS           | 1115.85      | [AllocRef_LEVY]           |
    | 202006                 | ORG0017102     | LEVY1799                | 8               | 202006 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS38               | APPS           | 1353.98      | [AllocRef_LEVY]           |
    | 202006                 | ORG0017102     | LEVY1799                | 9               | 202006 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS38               | APPS           | 1121.85      | [AllocRef_LEVY]           |
    | 202006                 | ORG0017102     | LEVY1799                | 10              | 202006 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS38               | APPS           | 605.32       | [AllocRef_LEVY]           |
    | 202006                 | ORG0017102     | LEVY1799                | 11              | 202006 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS38               | APPS           | 759.83       | [AllocRef_LEVY]           |
    | 202006                 | ORG0017102     | LEVY1799                | 12              | 202006 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS38               | APPS           | 329.56       | [AllocRef_LEVY]           |
    #
	| 202007                 | ORG0017102     | LEVY1799                | 2               | 202007 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS39               | APPS           | 0.00         | [AllocRef_LEVY]           |
    | 202007                 | ORG0017102     | LEVY1799                | 3               | 202007 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS39               | APPS           | 0.00         | [AllocRef_LEVY]           |
    | 202007                 | ORG0017102     | LEVY1799                | 4               | 202007 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS39               | APPS           | 0.00         | [AllocRef_LEVY]           |
    | 202007                 | ORG0017102     | LEVY1799                | 5               | 202007 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS39               | APPS           | 559.64       | [AllocRef_LEVY]           |
    | 202007                 | ORG0017102     | LEVY1799                | 6               | 202007 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS39               | APPS           | 324.57       | [AllocRef_LEVY]           |
    | 202007                 | ORG0017102     | LEVY1799                | 8               | 202007 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS39               | APPS           | 1295.61      | [AllocRef_LEVY]           |
    | 202007                 | ORG0017102     | LEVY1799                | 9               | 202007 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS39               | APPS           | 1264.76      | [AllocRef_LEVY]           |
    | 202007                 | ORG0017102     | LEVY1799                | 10              | 202007 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS39               | APPS           | 0.00         | [AllocRef_LEVY]           |
    | 202007                 | ORG0017102     | LEVY1799                | 11              | 202007 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS39               | APPS           | -114.50      | [AllocRef_LEVY]           |
    | 202007                 | ORG0017102     | LEVY1799                | 12              | 202007 | 10017102 | [ContractNo]   | 1               | 0                  | 04/05/2020          | APPS39               | APPS           | 187.84       | [AllocRef_LEVY]           |

    And   there are '30' rows in the MonitoringDeliverables.PaymentInstructionAudit table for UKPRN '10017102'




    # Check PAAS after all PoI actuals have been processed (17385)
    And   PAAS table PaymentSchedule.DeliverablePayment contains the following values
    | AllocationNumber | VersionNumber | DeliverableCode | Period   | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | CollectionReturnCode | ActualVolume | ActualValue |
    | [AllocRef_LEVY]  | 1             | 2               | 202005   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 417.41                      | 417.41           | APPS37               | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 3               | 202005   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 421.21                      | 421.21           | APPS37               | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 4               | 202005   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 105.55                      | 105.55           | APPS37               | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 5               | 202005   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | APPS37               | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 6               | 202005   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 267.05                      | 267.05           | APPS37               | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 8               | 202005   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1168.10                     | 1168.10          | APPS37               | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 9               | 202005   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 228.41                      | 228.41           | APPS37               | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 10              | 202005   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | APPS37               | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 11              | 202005   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 260.74                      | 260.74           | APPS37               | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 12              | 202005   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | APPS37               | ?            | 0.00        |
    #
	| [AllocRef_LEVY]  | 1             | 2               | 202006   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | APPS38               | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 3               | 202006   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 773.25                      | 773.25           | APPS38               | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 4               | 202006   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1192.86                     | 1192.86          | APPS38               | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 5               | 202006   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1322.41                     | 1322.41          | APPS38               | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 6               | 202006   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1115.85                     | 1115.85          | APPS38               | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 8               | 202006   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1353.98                     | 1353.98          | APPS38               | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 9               | 202006   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1121.85                     | 1121.85          | APPS38               | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 10              | 202006   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 605.32                      | 605.32           | APPS38               | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 11              | 202006   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 759.83                      | 759.83           | APPS38               | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 12              | 202006   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 329.56                      | 329.56           | APPS38               | ?            | 0.00        |
    #
	| [AllocRef_LEVY]  | 1             | 2               | 202007   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | APPS39               | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 3               | 202007   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | APPS39               | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 4               | 202007   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | APPS39               | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 5               | 202007   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 559.64                      | 559.64           | APPS39               | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 6               | 202007   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 324.57                      | 324.57           | APPS39               | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 8               | 202007   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1295.61                     | 1295.61          | APPS39               | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 9               | 202007   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1264.76                     | 1264.76          | APPS39               | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 10              | 202007   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | APPS39               | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 11              | 202007   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | -114.50                     | -114.50          | APPS39               | ?            | 0.00        |
    | [AllocRef_LEVY]  | 1             | 12              | 202007   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 187.84                      | 187.84           | APPS39               | ?            | 0.00        |


    # Check the RECONCILIATION AMOUNTS in CRM on the latest approved contract
    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | May-20   |
    | [ContractNo]   | [AllocRef_LEVY]    | 1               | 0.00      | ?        | 
    | [ContractNo]   | [AllocRef_LEVY]    | 7               | 0.00      | ?        | 
    | [ContractNo]   | [AllocRef_LEVY]    | 13              | 0.00      | ?        | 
    | [ContractNo]   | [AllocRef_LEVY]    | 14              | 0.00      | ?        | 
	#
    | [ContractNo]   | [AllocRef_NLA]     | 1               | 0.00      | ?        | 
    | [ContractNo]   | [AllocRef_NLA]     | 2               | 0.00      | ?        | 
    | [ContractNo]   | [AllocRef_NLA]     | 3               | 0.00      | ?        | 
    | [ContractNo]   | [AllocRef_NLA]     | 4               | 0.00      | ?        | 
    | [ContractNo]   | [AllocRef_NLA]     | 5               | 0.00      | ?        | 
    | [ContractNo]   | [AllocRef_NLA]     | 6               | 0.00      | ?        | 
    | [ContractNo]   | [AllocRef_NLA]     | 7               | 0.00      | ?        | 
    | [ContractNo]   | [AllocRef_NLA]     | 8               | 0.00      | ?        | 
    | [ContractNo]   | [AllocRef_NLA]     | 9               | 0.00      | ?        | 
    | [ContractNo]   | [AllocRef_NLA]     | 10              | 0.00      | ?        | 
    | [ContractNo]   | [AllocRef_NLA]     | 11              | 0.00      | ?        | 
    | [ContractNo]   | [AllocRef_NLA]     | 12              | 0.00      | ?        | 
    | [ContractNo]   | [AllocRef_NLA]     | 13              | 0.00      | ?        | 
    | [ContractNo]   | [AllocRef_NLA]     | 14              | 0.00      | ?        | 

    And   the Reconciliation Data is calculated as follows 
    | ContractNumber | AllocationRef      | DeliverableCode | Total     | May-20   | Jun-20   | Jul-20   |
    | [ContractNo]   | [AllocRef_LEVY]    | 2               | 417.41    | 417.41   | 0.00     | 0.00     | 
    | [ContractNo]   | [AllocRef_LEVY]    | 3               | 1194.46   | 421.21   | 773.25   | 0.00     | 
    | [ContractNo]   | [AllocRef_LEVY]    | 4               | 1298.41   | 105.55   | 1192.86  | 0.00     | 
    | [ContractNo]   | [AllocRef_LEVY]    | 5               | 1882.05   | 0.00     | 1322.41  | 559.64   | 
    | [ContractNo]   | [AllocRef_LEVY]    | 6               | 1707.47   | 267.05   | 1115.85  | 324.57   | 
    | [ContractNo]   | [AllocRef_LEVY]    | 8               | 3817.69   | 1168.10  | 1353.98  | 1295.61  | 
    | [ContractNo]   | [AllocRef_LEVY]    | 9               | 2615.02   | 228.41   | 1121.85  | 1264.76  | 
    | [ContractNo]   | [AllocRef_LEVY]    | 10              | 605.32    | 0.00     | 605.32   | 0.00     | 
    | [ContractNo]   | [AllocRef_LEVY]    | 11              | 906.07    | 260.74   | 759.83   | -114.50  | 
    | [ContractNo]   | [AllocRef_LEVY]    | 12              | 517.40    | 0.00     | 329.56   | 187.84   | 
									              

	# Tidy up
    And   the override date is reset

@AcceptanceTest @Withdrawn20230123
@PublishNewLevyContract
Scenario: A103 Create and approve a Levy contract where caseload exists without an assigned adviser. (No company no) Consume two (late) consecutive actuals for LEVY alloc. Check Feed, docs, CRM and PaaS
    Given there is no Contract, Task or Workflow data for UKPRN '10017103'
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Input-Appendices' for UKPRN '10017103'
    And   there are no Levy contract documents in sharepoint location 'LEVY-1799-Output-Documents for Publication' for UKPRN '10017103'
    And   the PaaS MonthEndIsRunning indicator is set to 'False'
    And   there is no Levy event data in the DAS agreement stub
    And   there are no entries in the DCFS stub table
    And   there is no data in the MonitoringDeliverables.PaymentInstructionAudit table for UKPRN '10017103'
    And   there are no DAS engagement events stored in FCS
    And   the override date is reset



    # Remove the provider from RoATP (ContractManagement.RoATPProvider)
    And   there is no data on RoATP for the following providers
    | Ukprn    |
    | 10017103 |

    # Add the provider to RoATP (ContractManagement.RoATPProvider)
    # Note: 'Main provider' and 'Employer provider' ProviderTypes are valid and are used to create contracts. 'Supporting provider' ProviderType is not. 
    And   the following providers exist on RoATP 
    | Ukprn    | Name            | ProviderType  | ParentCompanyGuarantee | NewOrganisationWithoutFinancialTrackRecord | StartDate  | 
    | 10017103 | 10017103 Co Ltd | Main provider | False                  | False                                      | 15/03/2017 | 



    # Set organisation and advisors 
    Given there is no Organisation data for UKPRN '10017103' 
    And   caseload advisor 'FCS2 Test' is assigned to provider '10017103 Co Ltd' with UKPRN '10017103' and OrgId 'ORG0017103' and has 'FCS1 Test' as a manager 
   #And   caseload advisor 'FCS2 Test' is assigned to UKPRN '10017103' 
 
    # Put data in the PaaS Organisation table (dbo.Organisations) J056
    And   the following Organisations exist in the FCT Organisation Service
    | UKPRN    | UPIN   | Name            | SequenceNumber | Status                | UKRLPCalledOk | CompanyNumber | CharityNumber | AddressLine1           | AddressLine2           | AddressLine3           | AddressLine4           | Town                   | County                 | Postcode  |
    | 10017103 | 117103 | 10017103 Co Ltd | 0              | Provider Under Change | Yes           | ?             | AA017103      | 72 Brackenwoods        | Necton                 | ?                      | ?                      | Swaffham               | Norfolk                | PE37 8EX  |
    
	# Put the same Provider data in the CRM Organisation table 
    And   PaaS Organisation data has been replicated in CRM for the following UKPRNs
    | UKPRN    |
    | 10017103 |



   # Inject data into the stub (16104)
    And   the following Levy event data is available in the DAS agreement stub
    | Id    | Event     | CreatedOn                | ProviderId | ContractType      |
    | 42751 | CREATED   | 2017-02-16T09:31:29.1012 | 10017142   | ProviderAgreement |
    | 42752 | CREATED   | 2017-02-16T09:31:29.1013 | 10017239   | ProviderAgreement |
    | 42753 | CREATED   | 2017-02-16T09:31:29.1015 | 10017224   | ProviderAgreement |
    | 42754 | CREATED   | 2017-02-16T09:31:29.1020 | 10017727   | ProviderAgreement |
    | 42755 | CREATED   | 2017-02-16T09:31:29.1024 | 10017279   | ProviderAgreement |
    | 42756 | CREATED   | 2017-02-16T09:31:29.1026 | 10017624   | ProviderAgreement |
    | 42757 | CREATED   | 2017-02-16T09:31:29.1030 | 10017209   | ProviderAgreement |
    | 42758 | CREATED   | 2017-02-16T09:31:29.1032 | 10017185   | ProviderAgreement |
    | 42759 | CREATED   | 2017-02-16T09:31:29.1035 | 10017691   | ProviderAgreement |
    | 42760 | CREATED   | 2017-02-16T09:31:29.1037 | 10017422   | ProviderAgreement |
    | 42761 | CREATED   | 2017-02-16T09:31:29.1041 | 10017262   | ProviderAgreement |
    | 42762 | CREATED   | 2017-02-16T09:31:29.1044 | 10017278   | ProviderAgreement |
    | 42763 | CREATED   | 2017-02-16T09:31:29.1045 | 10017140   | ProviderAgreement |
    | 42764 | CREATED   | 2017-02-16T09:31:29.1050 | 10017158   | ProviderAgreement |
    | 42765 | CREATED   | 2017-02-16T09:31:29.1055 | 10017287   | ProviderAgreement |
    | 42766 | CREATED   | 2017-02-16T09:31:29.1059 | 10017139   | ProviderAgreement |
    | 42767 | CREATED   | 2017-02-16T09:31:29.1064 | 10017446   | ProviderAgreement |
    | 42768 | CREATED   | 2017-02-16T09:31:29.1067 | 10017408   | ProviderAgreement |
    | 42769 | CREATED   | 2017-02-16T09:31:29.1072 | 10017670   | ProviderAgreement |
    | 42770 | CREATED   | 2017-02-16T09:31:29.1077 | 10017502   | ProviderAgreement |
    | 42771 | CREATED   | 2017-02-16T09:31:29.1078 | 10017647   | ProviderAgreement |
    | 42772 | CREATED   | 2017-02-16T09:31:29.1081 | 10017774   | ProviderAgreement |
    | 42773 | CREATED   | 2017-02-16T09:31:29.1084 | 10017565   | ProviderAgreement |
    | 42774 | CREATED   | 2017-02-16T09:31:29.1085 | 10017606   | ProviderAgreement |
    | 42775 | CREATED   | 2017-02-16T09:31:29.1089 | 10017782   | ProviderAgreement |
    | 42776 | CREATED   | 2017-02-16T09:31:29.1092 | 10017221   | ProviderAgreement |
    | 42777 | CREATED   | 2017-02-16T09:31:29.1097 | 10017292   | ProviderAgreement |
    | 42778 | CREATED   | 2017-02-16T09:31:29.1101 | 10017606   | ProviderAgreement |
    | 42779 | CREATED   | 2017-02-16T09:31:29.1106 | 10017169   | ProviderAgreement |
    | 42780 | CREATED   | 2017-02-16T09:31:29.1108 | 10017176   | ProviderAgreement |
    | 42781 | CREATED   | 2017-02-16T09:31:29.1112 | 10017315   | ProviderAgreement |
    | 42782 | CREATED   | 2017-02-16T09:31:29.1116 | 10017537   | ProviderAgreement |
    | 42783 | CREATED   | 2017-02-16T09:31:29.1117 | 10017501   | ProviderAgreement |
    | 42784 | CREATED   | 2017-02-16T09:31:29.1120 | 10017744   | ProviderAgreement |
    | 42785 | CREATED   | 2017-02-16T09:31:29.1125 | 10017204   | ProviderAgreement |
    | 42786 | CREATED   | 2017-02-16T09:31:29.1127 | 10017659   | ProviderAgreement |
    | 42787 | CREATED   | 2017-02-16T09:31:29.1131 | 10017686   | ProviderAgreement |
    | 42788 | CREATED   | 2017-02-16T09:31:29.1133 | 10017365   | ProviderAgreement |
    | 42789 | CREATED   | 2017-02-16T09:31:29.1137 | 10017357   | ProviderAgreement |
    | 42790 | CREATED   | 2017-02-16T09:31:29.1140 | 10017429   | ProviderAgreement |
    | 42791 | CREATED   | 2017-02-16T09:31:29.1143 | 10017635   | ProviderAgreement |
    | 42792 | CREATED   | 2017-02-16T09:31:29.1146 | 10017283   | ProviderAgreement |
    | 42793 | CREATED   | 2017-02-16T09:31:29.1148 | 10017280   | ProviderAgreement |
    | 42794 | CREATED   | 2017-02-16T09:31:29.1153 | 10017213   | ProviderAgreement |
    | 42795 | CREATED   | 2017-02-16T09:31:29.1154 | 10017224   | ProviderAgreement |
    | 42796 | CREATED   | 2017-02-16T09:31:29.1156 | 10017763   | ProviderAgreement |
    | 42797 | CREATED   | 2017-02-16T09:31:29.1159 | 10017307   | ProviderAgreement |
    | 42798 | CREATED   | 2017-02-16T09:31:29.1161 | 10017261   | ProviderAgreement |
    | 42799 | CREATED   | 2017-02-16T09:31:29.1165 | 10017328   | ProviderAgreement |
    | 42800 | CREATED   | 2017-02-16T09:31:29.1169 | 10017752   | ProviderAgreement |
    | 42801 | CREATED   | 2017-02-16T09:31:29.1170 | 10017566   | ProviderAgreement |
    | 42802 | CREATED   | 2017-02-16T09:31:29.1172 | 10017363   | ProviderAgreement |
    | 42803 | CREATED   | 2017-02-16T09:31:29.1177 | 10017417   | ProviderAgreement |
    | 42804 | CREATED   | 2017-02-16T09:31:29.1179 | 10017278   | ProviderAgreement |
    | 42805 | CREATED   | 2017-02-16T09:31:29.1183 | 10017639   | ProviderAgreement |
    | 42806 | CREATED   | 2017-02-16T09:31:29.1188 | 10017189   | ProviderAgreement |
    | 42807 | CREATED   | 2017-02-16T09:31:29.1191 | 10017271   | ProviderAgreement |
    | 42808 | CREATED   | 2017-02-16T09:31:29.1192 | 10017113   | ProviderAgreement |
    | 42809 | CREATED   | 2017-02-16T09:31:29.1197 | 10017591   | ProviderAgreement |
    | 42810 | CREATED   | 2017-02-16T09:31:29.1199 | 10017320   | ProviderAgreement |
    | 42811 | CREATED   | 2017-02-16T09:31:29.1201 | 10017324   | ProviderAgreement |
    | 42812 | CREATED   | 2017-02-16T09:31:29.1202 | 10017738   | ProviderAgreement |
    | 42813 | CREATED   | 2017-02-16T09:31:29.1205 | 10017627   | ProviderAgreement |
    | 42814 | CREATED   | 2017-02-16T09:31:29.1206 | 10017535   | ProviderAgreement |
    | 42815 | CREATED   | 2017-02-16T09:31:29.1207 | 10017637   | ProviderAgreement |
    | 42816 | CREATED   | 2017-02-16T09:31:29.1211 | 10017625   | ProviderAgreement |
    | 42817 | CREATED   | 2017-02-16T09:31:29.1214 | 10017746   | ProviderAgreement |
    | 42818 | CREATED   | 2017-02-16T09:31:29.1215 | 10017150   | ProviderAgreement |
    | 42819 | CREATED   | 2017-02-16T09:31:29.1217 | 10017549   | ProviderAgreement |
    | 42820 | CREATED   | 2017-02-16T09:31:29.1219 | 10017706   | ProviderAgreement |
    | 42821 | CREATED   | 2017-02-16T09:31:29.1220 | 10017401   | ProviderAgreement |
    | 42822 | CREATED   | 2017-02-16T09:31:29.1221 | 10017423   | ProviderAgreement |
    | 42823 | CREATED   | 2017-02-16T09:31:29.1226 | 10017399   | ProviderAgreement |
    | 42824 | CREATED   | 2017-02-16T09:31:29.1231 | 10017592   | ProviderAgreement |
    | 42825 | CREATED   | 2017-02-16T09:31:29.1235 | 10017216   | ProviderAgreement |
    | 42826 | CREATED   | 2017-02-16T09:31:29.1237 | 10017779   | ProviderAgreement |
    | 42827 | CREATED   | 2017-02-16T09:31:29.1241 | 10017493   | ProviderAgreement |
    | 42828 | CREATED   | 2017-02-16T09:31:29.1245 | 10017293   | ProviderAgreement |
    | 42829 | CREATED   | 2017-02-16T09:31:29.1247 | 10017266   | ProviderAgreement |
    | 42830 | CREATED   | 2017-02-16T09:31:29.1251 | 10017521   | ProviderAgreement |
    | 42831 | CREATED   | 2017-02-16T09:31:29.1255 | 10017761   | ProviderAgreement |
    | 42832 | CREATED   | 2017-02-16T09:31:29.1256 | 10017556   | ProviderAgreement |
    | 42833 | CREATED   | 2017-02-16T09:31:29.1261 | 10017422   | ProviderAgreement |
    | 42834 | CREATED   | 2017-02-16T09:31:29.1262 | 10017556   | ProviderAgreement |
    | 42835 | CREATED   | 2017-02-16T09:31:29.1263 | 10017416   | ProviderAgreement |
    | 42836 | CREATED   | 2017-02-16T09:31:29.1267 | 10017467   | ProviderAgreement |
    | 42837 | CREATED   | 2017-02-16T09:31:29.1268 | 10017696   | ProviderAgreement |
    | 42838 | CREATED   | 2017-02-16T09:31:29.1272 | 10017295   | ProviderAgreement |
    | 42839 | CREATED   | 2017-02-16T09:31:29.1274 | 10017353   | ProviderAgreement |
    | 42840 | CREATED   | 2017-02-16T09:31:29.1278 | 10017540   | ProviderAgreement |
    | 42841 | CREATED   | 2017-02-16T09:31:29.1281 | 10017207   | ProviderAgreement |
    | 42842 | CREATED   | 2017-02-16T09:31:29.1285 | 10017751   | ProviderAgreement |
    | 42843 | CREATED   | 2017-02-16T09:31:29.1289 | 10017751   | ProviderAgreement |
    | 42844 | CREATED   | 2017-02-16T09:31:29.1293 | 10017309   | ProviderAgreement |
    | 42845 | CREATED   | 2017-02-16T09:31:29.1294 | 10017276   | ProviderAgreement |
    | 42846 | CREATED   | 2017-02-16T09:31:29.1298 | 10017756   | ProviderAgreement |
    | 42847 | CREATED   | 2017-02-16T09:31:29.1303 | 10017723   | ProviderAgreement |
    | 42848 | CREATED   | 2017-02-16T09:31:29.1308 | 10017739   | ProviderAgreement |
    | 42849 | CREATED   | 2017-02-16T09:31:29.1309 | 10017647   | ProviderAgreement |
    | 42850 | CREATED   | 2017-02-16T09:31:29.1310 | 10017744   | ProviderAgreement |
    | 42851 | CREATED   | 2017-02-16T09:31:29.1314 | 10017727   | ProviderAgreement |
    | 42852 | CREATED   | 2017-02-16T09:31:29.1317 | 10017443   | ProviderAgreement |
    | 42853 | CREATED   | 2017-02-16T09:31:29.1318 | 10017513   | ProviderAgreement |
    | 42854 | CREATED   | 2017-02-16T09:31:29.1320 | 10017341   | ProviderAgreement |
    | 42855 | CREATED   | 2017-02-16T09:31:29.1321 | 10017156   | ProviderAgreement |
    | 42856 | CREATED   | 2017-02-16T09:31:29.1325 | 10017149   | ProviderAgreement |
    | 42857 | CREATED   | 2017-02-16T09:31:29.1327 | 10017241   | ProviderAgreement |
    | 42858 | CREATED   | 2017-02-16T09:31:29.1332 | 10017774   | ProviderAgreement |
    | 42859 | CREATED   | 2017-02-16T09:31:29.1336 | 10017433   | ProviderAgreement |
    | 42860 | INITIATED | 2017-02-16T09:31:29.1340 | 10017103   | ProviderAgreement |
    | 42861 | CREATED   | 2017-02-16T09:31:29.1344 | 10017336   | ProviderAgreement |
    | 42862 | CREATED   | 2017-02-16T09:31:29.1345 | 10017403   | ProviderAgreement |
    | 42863 | CREATED   | 2017-02-16T09:31:29.1347 | 10017543   | ProviderAgreement |
    | 42864 | CREATED   | 2017-02-16T09:31:29.1349 | 10017681   | ProviderAgreement |
    | 42865 | CREATED   | 2017-02-16T09:31:29.1352 | 10017411   | ProviderAgreement |
    | 42866 | CREATED   | 2017-02-16T09:31:29.1355 | 10017564   | ProviderAgreement |
    | 42867 | CREATED   | 2017-02-16T09:31:29.1359 | 10017129   | ProviderAgreement |
    | 42868 | CREATED   | 2017-02-16T09:31:29.1364 | 10017140   | ProviderAgreement |
    | 42869 | CREATED   | 2017-02-16T09:31:29.1367 | 10017219   | ProviderAgreement |
    | 42870 | CREATED   | 2017-02-16T09:31:29.1371 | 10017410   | ProviderAgreement |
    | 42871 | CREATED   | 2017-02-16T09:31:29.1374 | 10017514   | ProviderAgreement |
    | 42872 | CREATED   | 2017-02-16T09:31:29.1379 | 10017299   | ProviderAgreement |
    | 42873 | CREATED   | 2017-02-16T09:31:29.1383 | 10017685   | ProviderAgreement |
    | 42874 | CREATED   | 2017-02-16T09:31:29.1388 | 10017697   | ProviderAgreement |
    | 42875 | CREATED   | 2017-02-16T09:31:29.1390 | 10017247   | ProviderAgreement |

    When  the Levy event data is pulled from the DAS agreement stub
    And   the Levy contract is created in CRM for UKPRN '10017103'

 


    # Check the contract has been created ok 
    Then  the draft contract header details for the new Levy contract are as follows 
    | UKPRN    | LegalName            | FundingType | MasterContractNumber | ContractNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | PeriodTypeCode | Period | CRMIntent    | OrgId      | 
    | 10017103 | 10017103 Co Ltd      | LEVY        | [MasterContractNo]   | [ContractNo]   | 01/05/2017        | ?               | 0.00          | Provider Agreement    | LEVY           | 1799   | New          | ORG0017103 | 
 
    And   the draft Levy contract allocations details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | FundingStreamPeriodCode | ContractNumber | AllocationRef       | AllocationStartDate | AllocationEndDate | AllocationValue | CRMIntent    | PeriodTypeCode | Period | 
    | 10017103 | LEVY              | LEVY1799                | [ContractNo]   | [AllocRef_LEVY]     | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   | 
    | 10017103 | NONLEVY           | NONLEVY2019             | [ContractNo]   | [AllocRef_NLA]      | 01/05/2017          | ?                 | 0.00            | New          | LEVY           | 1799   | 
 
    And   the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | May-17   | DeliverableDescription                | 
    | 10017103 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships      | 
    | 10017103 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships      | 
    | 10017103 | NONLEVY           | [AllocRef_NLA]      | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships  | 
    | 10017103 | NONLEVY           | [AllocRef_NLA]      | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships  | 

    And   there are no open tasks for the contract
    And   there is no contract owner assigned to the latest version of the contract

	# I need this step in this format to allow time for the contract to be created so that the parameters can be retrieved by the next step
    And   the latest version of the contract has the following settings 
    | Status | SubStatus              | LatestVersion | LastApprovedVersion | ContractVersionNumber |
    | Draft  | Published to Provider  | Yes           | No                  | 1                     |




    # Retrieve parameters from CRM 
   #When  I retrieve the latest EFA contract details from CRM for provider '10017103' for FundingType 'LEVY' and period '1799' and Delivery Organisation '10017103' 
    And   I retrieve the latest contract details from CRM for provider '10017103' for FundingType 'LEVY' and period '1799' 

    # Check deliverable period count prior to approval
    And   there are '4' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'

    # Check Atom feed data for a type 1 'Published to Provider' event
    And   the ContractManagement.AtomFeedItem table contains one ItemType '1' event for contract number '[ContractNo]'
    And   the ItemType '1' event for contract number '[ContractNo]' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema

    # Copy\Save a named Sharepoint file to a named folder\filename
    And   Sharepoint file '10017103_[ContractNo]_v1.pdf' in 'LEVY-1799-Output-Documents for Publication' is copied to 'Datafiles/Downloads' as '10017103_APPLEVY-103_v1.pdf'

    # Check Contract documentation (16390)
    And   a file named '10017103_' & '[ContractNo]' & '_v1.pdf' does not exist in sharepoint location 'LEVY-1799-Input-Appendices'
    And   the file named '10017103_[ContractNo]_v1.pdf' in Sharepoint location 'LEVY-1799-Output-Documents for Publication' contains the following lines in order 
    """
    Department for Education Apprenticeship Agreement for Training
    Providers
    Terms and Conditions
    THIS AGREEMENT is made on the date the Agreement is digitally signed by the Training
    Provider through the Manage Your Education and Skills Funding Service having
    already been signed by the Department and is between:
    10017103 Co Ltd THE SECRETARY OF STATE FOR
    72 Brackenwoods EDUCATION
    Necton DEPARTMENT FOR
    Swaffham EDUCATION
    Norfolk AND 20 GREAT SMITH STREET
    PE37 8EX LONDON
    SW1P 3BT
    UKPRN: 10017103
    Referred to in this Agreement as “the Referred to in this Agreement as “the
    Training Provider” Department”
    “Expiry Date” means 31 July 2025 or such later date as is notified in writing by
    Department for Education Apprenticeship Agreement for Training Providers, Winter 2022, Version
    4.1
    Education & Skills Funding Agency
    Education and Skills Funding Agency - GOV.UK (www.gov.uk)
    56
    """

    # The Amendment Letter is not included
    And   the pdf file does not contain the following text
    """
    Agreement number: [MasterContractNo] 
    """





    # Change the date
    Given the override date is '10/05/2020'

    # Approve the contract (15397)
    When  a contract approval message is received from SFS for MasterContractNumber '[MasterContractNo]' and ContractNumber '[ContractNo]' and Version '1'
    
    # Check deliverable period count after approval 
    Then  there are '28' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]' 
 
    # After approval there should be a May-20 deliverable period for each of deliverables 1 through 14 for each allocation 
    Then   the draft Levy contract deliverables details for the new Levy contract are as follows 
    | UKPRN    | FundingStreamCode | AllocationRef       | DeliverableCode | ParentDeliverableCode | Total    | May-20   | DeliverableDescription                               | 
    | 10017103 | LEVY              | [AllocRef_LEVY]     | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Levy Apprenticeships                     | 
    | 10017103 | LEVY              | [AllocRef_LEVY]     | 2               | 1                     | ?        | 0.00     | 16-18 Levy - Levy Funded                             | 
    | 10017103 | LEVY              | [AllocRef_LEVY]     | 3               | 1                     | ?        | 0.00     | 16-18 Levy - Co-Invested                             | 
    | 10017103 | LEVY              | [AllocRef_LEVY]     | 4               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Learning Support        | 
    | 10017103 | LEVY              | [AllocRef_LEVY]     | 5               | 1                     | ?        | 0.00     | 16-18 Levy - Agency Funded - Other                   | 
    | 10017103 | LEVY              | [AllocRef_LEVY]     | 6               | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Employers       | 
    | 10017103 | LEVY              | [AllocRef_LEVY]     | 13              | 1                     | ?        | 0.00     | 16-18 Levy - Additional Payments for Individuals     | 
    | 10017103 | LEVY              | [AllocRef_LEVY]     | 7               | 0                     | 0.00     | 0.00     | Total Adult Levy Apprenticeships                     | 
    | 10017103 | LEVY              | [AllocRef_LEVY]     | 8               | 7                     | ?        | 0.00     | Adult Levy - Levy Funded                             | 
    | 10017103 | LEVY              | [AllocRef_LEVY]     | 9               | 7                     | ?        | 0.00     | Adult Levy - Co-Invested                             | 
    | 10017103 | LEVY              | [AllocRef_LEVY]     | 10              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Learning Support        | 
    | 10017103 | LEVY              | [AllocRef_LEVY]     | 11              | 7                     | ?        | 0.00     | Adult Levy - Agency Funded - Other                   | 
    | 10017103 | LEVY              | [AllocRef_LEVY]     | 12              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Employers       | 
    | 10017103 | LEVY              | [AllocRef_LEVY]     | 14              | 7                     | ?        | 0.00     | Adult Levy - Additional Payments for Individuals     | 
     
    | 10017103 | NONLEVY           | [AllocRef_NLA]      | 1               | 0                     | 0.00     | 0.00     | Total 16-18 Non-Levy Apprenticeships                 | 
    | 10017103 | NONLEVY           | [AllocRef_NLA]      | 2               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Levy Funded                         | 
    | 10017103 | NONLEVY           | [AllocRef_NLA]      | 3               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Co-Invested                         | 
    | 10017103 | NONLEVY           | [AllocRef_NLA]      | 4               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Learning Support    | 
    | 10017103 | NONLEVY           | [AllocRef_NLA]      | 5               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Agency Funded - Other               | 
    | 10017103 | NONLEVY           | [AllocRef_NLA]      | 6               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Employers   | 
    | 10017103 | NONLEVY           | [AllocRef_NLA]      | 7               | 1                     | ?        | 0.00     | 16-18 Non-Levy - Additional Payments for Individuals | 
    | 10017103 | NONLEVY           | [AllocRef_NLA]      | 8               | 0                     | 0.00     | 0.00     | Total Adult Non-Levy Apprenticeships                 | 
    | 10017103 | NONLEVY           | [AllocRef_NLA]      | 9               | 8                     | ?        | 0.00     | Adult Non-Levy - Levy Funded                         | 
    | 10017103 | NONLEVY           | [AllocRef_NLA]      | 10              | 8                     | ?        | 0.00     | Adult Non-Levy - Co-Invested                         | 
    | 10017103 | NONLEVY           | [AllocRef_NLA]      | 11              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Learning Support    | 
    | 10017103 | NONLEVY           | [AllocRef_NLA]      | 12              | 8                     | ?        | 0.00     | Adult Non-Levy - Agency Funded - Other               | 
    | 10017103 | NONLEVY           | [AllocRef_NLA]      | 13              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Employers   | 
    | 10017103 | NONLEVY           | [AllocRef_NLA]      | 14              | 8                     | ?        | 0.00     | Adult Non-Levy - Additional Payments for Individuals | 

    # Check the CONTRACT version, status and dates in CRM
    And   the following contract values are present in CRM
    | UKPRN    | ContractNumber     | ContractVersionNumber | ContractSubVersionNumber | ContractStatus   | ContractSubStatus         | LatestVersion | LastApprovedVersion | ContractStartDate | ContractEndDate | AmendmentType |
    | 10017103 | [ContractNo]       | 1                     | 0                        | Approved         | Approved                  | True          | True                | 10/05/2020        | ?               | ?             |
    | 10017103 | [MasterContractNo] | 1                     | 0                        | Draft            | ?                         | False         | False               | 01/05/2017        | ?               | ?             |

    And   there are '28' deliverable period rows in CRM linked to the latest version of contract number '[ContractNo]'
	
    And   the following workflow history entries are present on the latest version of the contract
    | Action                                         | CompletedBy       | Previous Contract Owner | New Contract Owner | 
    | Confirm Receipt of Digital Signature           | CRM Integration   | ?                       | ?                  |
    | Document Published For Digital Sign Off        | CRM Integration   | ?                       | ?                  |
    | Skip Review and Internal Approval              | CRM Integration   | ?                       | ?                  |

    And   the following workflow history entries are not present on the latest version of the contract 
    | Action                                                             |
    | Approve for Issue                                                  |
    | Automatically Approved                                             |

    # Check Atom feed data for a type 0 'Approved' event
    And   the ContractManagement.AtomFeedItem table contains one ItemType '0' event for contract number '[ContractNo]'
    And   the ItemType '0' event for contract number '[ContractNo]' in the ContractManagement.AtomFeedItem table conforms to the Corporate Contract Schema




    # Change the date
    Given the override date is '07/08/2020'

    # Clear down MonitoringDeliverables.SummarisedActual and MonitoringDeliverables.ClosedCollection before the first pull of actuals 
    And   there are no entries in the SummarisedActuals or ClosedCollections tables in PaaS
    
	# Pull DCFS PoI actuals for July 2020 (17384) 
	And   the following closed collections are available in DCFS
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber  | UoPCode | DeliverableCode | ActualVolume | ActualValue |
    | APPS           | APPS39               | ORG0017103     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]           |         | 2               | 0            | 475.14      |
    | APPS           | APPS39               | ORG0017103     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]           |         | 3               | 0            | 1169.90     |
    | APPS           | APPS39               | ORG0017103     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]           |         | 4               | 0            | 405.59      |
    | APPS           | APPS39               | ORG0017103     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]           |         | 5               | 0            | 923.27      |
    | APPS           | APPS39               | ORG0017103     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]           |         | 6               | 0            | -99.96      |
    | APPS           | APPS39               | ORG0017103     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]           |         | 8               | 0            | -99.64      |
    | APPS           | APPS39               | ORG0017103     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]           |         | 9               | 0            | 336.95      |
    | APPS           | APPS39               | ORG0017103     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]           |         | 10              | 0            | 0.00        |
    | APPS           | APPS39               | ORG0017103     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]           |         | 11              | 0            | 0.00        |
    | APPS           | APPS39               | ORG0017103     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]           |         | 12              | 0            | 207.80      |
    #
	| APPS           | APPS39               | ORG0017103     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]           |         | 2               | 0            | 1126.65     |
    | APPS           | APPS39               | ORG0017103     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]           |         | 3               | 0            | 31.75       |
    | APPS           | APPS39               | ORG0017103     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]           |         | 4               | 0            | 246.97      |
    | APPS           | APPS39               | ORG0017103     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]           |         | 5               | 0            | 157.29      |
    | APPS           | APPS39               | ORG0017103     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]           |         | 6               | 0            | 660.46      |
    | APPS           | APPS39               | ORG0017103     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]           |         | 8               | 0            | 831.47      |
    | APPS           | APPS39               | ORG0017103     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]           |         | 9               | 0            | 1403.09     |
    | APPS           | APPS39               | ORG0017103     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]           |         | 10              | 0            | 390.49      |
    | APPS           | APPS39               | ORG0017103     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]           |         | 11              | 0            | 1313.25     |
    | APPS           | APPS39               | ORG0017103     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]           |         | 12              | 0            | 0.00        |
    #
	| APPS           | APPS39               | ORG0017103     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]           |         | 2               | 0            | 227.11      |
    | APPS           | APPS39               | ORG0017103     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]           |         | 3               | 0            | -124.40     |
    | APPS           | APPS39               | ORG0017103     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]           |         | 4               | 0            | 598.91      |
    | APPS           | APPS39               | ORG0017103     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]           |         | 5               | 0            | 440.24      |
    | APPS           | APPS39               | ORG0017103     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]           |         | 6               | 0            | 1046.26     |
    | APPS           | APPS39               | ORG0017103     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]           |         | 8               | 0            | 157.41      |
    | APPS           | APPS39               | ORG0017103     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]           |         | 9               | 0            | 520.45      |
    | APPS           | APPS39               | ORG0017103     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]           |         | 10              | 0            | 1.34        |
    | APPS           | APPS39               | ORG0017103     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]           |         | 11              | 0            | 1201.79     |
    | APPS           | APPS39               | ORG0017103     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]           |         | 12              | 0            | 1107.26     |
    #
	| APPS           | APPS39               | ORG0017103     | CM             | 202008 | LEVY1799                | [AllocRef_LEVY]           |         | 2               | 0            | -80.11      |
    | APPS           | APPS39               | ORG0017103     | CM             | 202008 | LEVY1799                | [AllocRef_LEVY]           |         | 3               | 0            | 654.24      |
    | APPS           | APPS39               | ORG0017103     | CM             | 202008 | LEVY1799                | [AllocRef_LEVY]           |         | 4               | 0            | 399.01      |
    | APPS           | APPS39               | ORG0017103     | CM             | 202008 | LEVY1799                | [AllocRef_LEVY]           |         | 5               | 0            | 0.00        |
    | APPS           | APPS39               | ORG0017103     | CM             | 202008 | LEVY1799                | [AllocRef_LEVY]           |         | 6               | 0            | 428.34      |
    | APPS           | APPS39               | ORG0017103     | CM             | 202008 | LEVY1799                | [AllocRef_LEVY]           |         | 8               | 0            | 78.84       |
    | APPS           | APPS39               | ORG0017103     | CM             | 202008 | LEVY1799                | [AllocRef_LEVY]           |         | 9               | 0            | -142.68     |
    | APPS           | APPS39               | ORG0017103     | CM             | 202008 | LEVY1799                | [AllocRef_LEVY]           |         | 10              | 0            | 1229.20     |
    | APPS           | APPS39               | ORG0017103     | CM             | 202008 | LEVY1799                | [AllocRef_LEVY]           |         | 11              | 0            | 515.97      |
    | APPS           | APPS39               | ORG0017103     | CM             | 202008 | LEVY1799                | [AllocRef_LEVY]           |         | 12              | 0            | -193.34     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    Then  the following data is present in the MonitoringDeliverables.PaymentInstructionAudit table for UKPRN '10017103'
    | CollectionReturnPeriod | OrganisationId | FundingStreamPeriodCode | DeliverableCode | Period | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | AllocationStartDate | CollectionReturnCode | CollectionType | PaymentValue | ContractAllocation Number  |
    | 202007                 | ORG0017103     | LEVY1799                | 2               | 202007 | 10017103 | [ContractNo]   | 1               | 0                  | 10/05/2020          | APPS39               | APPS           | 227.11       | [AllocRef_LEVY]            |
    | 202007                 | ORG0017103     | LEVY1799                | 3               | 202007 | 10017103 | [ContractNo]   | 1               | 0                  | 10/05/2020          | APPS39               | APPS           | -124.40      | [AllocRef_LEVY]            |
    | 202007                 | ORG0017103     | LEVY1799                | 4               | 202007 | 10017103 | [ContractNo]   | 1               | 0                  | 10/05/2020          | APPS39               | APPS           | 598.91       | [AllocRef_LEVY]            |
    | 202007                 | ORG0017103     | LEVY1799                | 5               | 202007 | 10017103 | [ContractNo]   | 1               | 0                  | 10/05/2020          | APPS39               | APPS           | 440.24       | [AllocRef_LEVY]            |
    | 202007                 | ORG0017103     | LEVY1799                | 6               | 202007 | 10017103 | [ContractNo]   | 1               | 0                  | 10/05/2020          | APPS39               | APPS           | 1046.26      | [AllocRef_LEVY]            |
    | 202007                 | ORG0017103     | LEVY1799                | 8               | 202007 | 10017103 | [ContractNo]   | 1               | 0                  | 10/05/2020          | APPS39               | APPS           | 157.41       | [AllocRef_LEVY]            |
    | 202007                 | ORG0017103     | LEVY1799                | 9               | 202007 | 10017103 | [ContractNo]   | 1               | 0                  | 10/05/2020          | APPS39               | APPS           | 520.45       | [AllocRef_LEVY]            |
    | 202007                 | ORG0017103     | LEVY1799                | 10              | 202007 | 10017103 | [ContractNo]   | 1               | 0                  | 10/05/2020          | APPS39               | APPS           | 1.34         | [AllocRef_LEVY]            |
    | 202007                 | ORG0017103     | LEVY1799                | 11              | 202007 | 10017103 | [ContractNo]   | 1               | 0                  | 10/05/2020          | APPS39               | APPS           | 1201.79      | [AllocRef_LEVY]            |
    | 202007                 | ORG0017103     | LEVY1799                | 12              | 202007 | 10017103 | [ContractNo]   | 1               | 0                  | 10/05/2020          | APPS39               | APPS           | 1107.26      | [AllocRef_LEVY]            |

    And   there are '10' rows in the MonitoringDeliverables.PaymentInstructionAudit table for UKPRN '10017103'




	# Change the date
	Given the override date is '07/09/2020'

	# Pull DCFS PoI actuals for August 2020 (17384)
    And   the following closed collections are available in DCFS
    | CollectionType | CollectionReturnCode | OrganisationId | PeriodTypeCode | Period | FundingStreamPeriodCode | ContractAllocationNumber  | UoPCode | DeliverableCode | ActualVolume | ActualValue |
    | APPS           | APPS40               | ORG0017103     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]           |         | 2               | 0            | 475.14      |
    | APPS           | APPS40               | ORG0017103     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]           |         | 3               | 0            | 1169.90     |
    | APPS           | APPS40               | ORG0017103     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]           |         | 4               | 0            | 405.59      |
    | APPS           | APPS40               | ORG0017103     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]           |         | 5               | 0            | 923.27      |
    | APPS           | APPS40               | ORG0017103     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]           |         | 6               | 0            | -99.96      |
    | APPS           | APPS40               | ORG0017103     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]           |         | 8               | 0            | -99.64      |
    | APPS           | APPS40               | ORG0017103     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]           |         | 9               | 0            | 336.95      |
    | APPS           | APPS40               | ORG0017103     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]           |         | 10              | 0            | 0.00        |
    | APPS           | APPS40               | ORG0017103     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]           |         | 11              | 0            | 0.00        |
    | APPS           | APPS40               | ORG0017103     | CM             | 202005 | LEVY1799                | [AllocRef_LEVY]           |         | 12              | 0            | 207.80      |
    #
	| APPS           | APPS40               | ORG0017103     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]           |         | 2               | 0            | 1126.65     |
    | APPS           | APPS40               | ORG0017103     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]           |         | 3               | 0            | 31.75       |
    | APPS           | APPS40               | ORG0017103     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]           |         | 4               | 0            | 246.97      |
    | APPS           | APPS40               | ORG0017103     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]           |         | 5               | 0            | 157.29      |
    | APPS           | APPS40               | ORG0017103     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]           |         | 6               | 0            | 660.46      |
    | APPS           | APPS40               | ORG0017103     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]           |         | 8               | 0            | 831.47      |
    | APPS           | APPS40               | ORG0017103     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]           |         | 9               | 0            | 1403.09     |
    | APPS           | APPS40               | ORG0017103     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]           |         | 10              | 0            | 390.49      |
    | APPS           | APPS40               | ORG0017103     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]           |         | 11              | 0            | 1313.25     |
    | APPS           | APPS40               | ORG0017103     | CM             | 202006 | LEVY1799                | [AllocRef_LEVY]           |         | 12              | 0            | 0.00        |
    #
	| APPS           | APPS40               | ORG0017103     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]           |         | 2               | 0            | 227.11      |
    | APPS           | APPS40               | ORG0017103     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]           |         | 3               | 0            | -124.40     |
    | APPS           | APPS40               | ORG0017103     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]           |         | 4               | 0            | 598.91      |
    | APPS           | APPS40               | ORG0017103     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]           |         | 5               | 0            | 440.24      |
    | APPS           | APPS40               | ORG0017103     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]           |         | 6               | 0            | 1046.26     |
    | APPS           | APPS40               | ORG0017103     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]           |         | 8               | 0            | 157.41      |
    | APPS           | APPS40               | ORG0017103     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]           |         | 9               | 0            | 520.45      |
    | APPS           | APPS40               | ORG0017103     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]           |         | 10              | 0            | 1.34        |
    | APPS           | APPS40               | ORG0017103     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]           |         | 11              | 0            | 1201.79     |
    | APPS           | APPS40               | ORG0017103     | CM             | 202007 | LEVY1799                | [AllocRef_LEVY]           |         | 12              | 0            | 1107.26     |
    #
	| APPS           | APPS40               | ORG0017103     | CM             | 202008 | LEVY1799                | [AllocRef_LEVY]           |         | 2               | 0            | -80.11      |
    | APPS           | APPS40               | ORG0017103     | CM             | 202008 | LEVY1799                | [AllocRef_LEVY]           |         | 3               | 0            | 654.24      |
    | APPS           | APPS40               | ORG0017103     | CM             | 202008 | LEVY1799                | [AllocRef_LEVY]           |         | 4               | 0            | 399.01      |
    | APPS           | APPS40               | ORG0017103     | CM             | 202008 | LEVY1799                | [AllocRef_LEVY]           |         | 5               | 0            | 0.00        |
    | APPS           | APPS40               | ORG0017103     | CM             | 202008 | LEVY1799                | [AllocRef_LEVY]           |         | 6               | 0            | 428.34      |
    | APPS           | APPS40               | ORG0017103     | CM             | 202008 | LEVY1799                | [AllocRef_LEVY]           |         | 8               | 0            | 78.84       |
    | APPS           | APPS40               | ORG0017103     | CM             | 202008 | LEVY1799                | [AllocRef_LEVY]           |         | 9               | 0            | -142.68     |
    | APPS           | APPS40               | ORG0017103     | CM             | 202008 | LEVY1799                | [AllocRef_LEVY]           |         | 10              | 0            | 1229.20     |
    | APPS           | APPS40               | ORG0017103     | CM             | 202008 | LEVY1799                | [AllocRef_LEVY]           |         | 11              | 0            | 515.97      |
    | APPS           | APPS40               | ORG0017103     | CM             | 202008 | LEVY1799                | [AllocRef_LEVY]           |         | 12              | 0            | -193.34     |

    # Pull actuals from the old DCFS DEDs or the new Submit Learner Data (SLD) interface (24329)
   #When  the FCT system polls the DCFS DEDS service
    When  the FCT system polls the SLD service

    Then  the following data is present in the MonitoringDeliverables.PaymentInstructionAudit table for UKPRN '10017103'
    | CollectionReturnPeriod | OrganisationId | FundingStreamPeriodCode | DeliverableCode | Period | UKPRN    | ContractNumber | ContractVersion | ContractSubVersion | AllocationStartDate | CollectionReturnCode | CollectionType | PaymentValue | ContractAllocation Number  |
    | 202007                 | ORG0017103     | LEVY1799                | 2               | 202007 | 10017103 | [ContractNo]   | 1               | 0                  | 10/05/2020          | APPS39               | APPS           | 227.11       | [AllocRef_LEVY]            |
    | 202007                 | ORG0017103     | LEVY1799                | 3               | 202007 | 10017103 | [ContractNo]   | 1               | 0                  | 10/05/2020          | APPS39               | APPS           | -124.40      | [AllocRef_LEVY]            |
    | 202007                 | ORG0017103     | LEVY1799                | 4               | 202007 | 10017103 | [ContractNo]   | 1               | 0                  | 10/05/2020          | APPS39               | APPS           | 598.91       | [AllocRef_LEVY]            |
    | 202007                 | ORG0017103     | LEVY1799                | 5               | 202007 | 10017103 | [ContractNo]   | 1               | 0                  | 10/05/2020          | APPS39               | APPS           | 440.24       | [AllocRef_LEVY]            |
    | 202007                 | ORG0017103     | LEVY1799                | 6               | 202007 | 10017103 | [ContractNo]   | 1               | 0                  | 10/05/2020          | APPS39               | APPS           | 1046.26      | [AllocRef_LEVY]            |
    | 202007                 | ORG0017103     | LEVY1799                | 8               | 202007 | 10017103 | [ContractNo]   | 1               | 0                  | 10/05/2020          | APPS39               | APPS           | 157.41       | [AllocRef_LEVY]            |
    | 202007                 | ORG0017103     | LEVY1799                | 9               | 202007 | 10017103 | [ContractNo]   | 1               | 0                  | 10/05/2020          | APPS39               | APPS           | 520.45       | [AllocRef_LEVY]            |
    | 202007                 | ORG0017103     | LEVY1799                | 10              | 202007 | 10017103 | [ContractNo]   | 1               | 0                  | 10/05/2020          | APPS39               | APPS           | 1.34         | [AllocRef_LEVY]            |
    | 202007                 | ORG0017103     | LEVY1799                | 11              | 202007 | 10017103 | [ContractNo]   | 1               | 0                  | 10/05/2020          | APPS39               | APPS           | 1201.79      | [AllocRef_LEVY]            |
    | 202007                 | ORG0017103     | LEVY1799                | 12              | 202007 | 10017103 | [ContractNo]   | 1               | 0                  | 10/05/2020          | APPS39               | APPS           | 1107.26      | [AllocRef_LEVY]            |
    #
	| 202008                 | ORG0017103     | LEVY1799                | 2               | 202008 | 10017103 | [ContractNo]   | 1               | 0                  | 10/05/2020          | APPS40               | APPS           | -80.11       | [AllocRef_LEVY]            |
    | 202008                 | ORG0017103     | LEVY1799                | 3               | 202008 | 10017103 | [ContractNo]   | 1               | 0                  | 10/05/2020          | APPS40               | APPS           | 654.24       | [AllocRef_LEVY]            |
    | 202008                 | ORG0017103     | LEVY1799                | 4               | 202008 | 10017103 | [ContractNo]   | 1               | 0                  | 10/05/2020          | APPS40               | APPS           | 399.01       | [AllocRef_LEVY]            |
    | 202008                 | ORG0017103     | LEVY1799                | 5               | 202008 | 10017103 | [ContractNo]   | 1               | 0                  | 10/05/2020          | APPS40               | APPS           | 0.00         | [AllocRef_LEVY]            |
    | 202008                 | ORG0017103     | LEVY1799                | 6               | 202008 | 10017103 | [ContractNo]   | 1               | 0                  | 10/05/2020          | APPS40               | APPS           | 428.34       | [AllocRef_LEVY]            |
    | 202008                 | ORG0017103     | LEVY1799                | 8               | 202008 | 10017103 | [ContractNo]   | 1               | 0                  | 10/05/2020          | APPS40               | APPS           | 78.84        | [AllocRef_LEVY]            |
    | 202008                 | ORG0017103     | LEVY1799                | 9               | 202008 | 10017103 | [ContractNo]   | 1               | 0                  | 10/05/2020          | APPS40               | APPS           | -142.68      | [AllocRef_LEVY]            |
    | 202008                 | ORG0017103     | LEVY1799                | 10              | 202008 | 10017103 | [ContractNo]   | 1               | 0                  | 10/05/2020          | APPS40               | APPS           | 1229.20      | [AllocRef_LEVY]            |
    | 202008                 | ORG0017103     | LEVY1799                | 11              | 202008 | 10017103 | [ContractNo]   | 1               | 0                  | 10/05/2020          | APPS40               | APPS           | 515.97       | [AllocRef_LEVY]            |
    | 202008                 | ORG0017103     | LEVY1799                | 12              | 202008 | 10017103 | [ContractNo]   | 1               | 0                  | 10/05/2020          | APPS40               | APPS           | -193.34      | [AllocRef_LEVY]            |

    And   there are '20' rows in the MonitoringDeliverables.PaymentInstructionAudit table for UKPRN '10017103'

    # Check PAAS after all PoI actuals have been processed (17385)
    And   PAAS table PaymentSchedule.DeliverablePayment contains the following values
    | AllocationNumber  | VersionNumber | DeliverableCode | Period   | PeriodTypeCode | PlannedVolume | PlannedValue | ProfilePaymentAmount | CappedPaymentAmount | BalancingPaymentAmount | ReconciliationPaymentAmount | NetPaymentAmount | CollectionReturnCode | ActualVolume | ActualValue |
    | [AllocRef_LEVY]   | 1             | 2               | 202007   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 227.11                      | 227.11           | APPS39               | ?            | 0.00        |
    | [AllocRef_LEVY]   | 1             | 3               | 202007   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | -124.40                     | -124.40          | APPS39               | ?            | 0.00        |
    | [AllocRef_LEVY]   | 1             | 4               | 202007   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 598.91                      | 598.91           | APPS39               | ?            | 0.00        |
    | [AllocRef_LEVY]   | 1             | 5               | 202007   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 440.24                      | 440.24           | APPS39               | ?            | 0.00        |
    | [AllocRef_LEVY]   | 1             | 6               | 202007   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1046.26                     | 1046.26          | APPS39               | ?            | 0.00        |
    | [AllocRef_LEVY]   | 1             | 8               | 202007   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 157.41                      | 157.41           | APPS39               | ?            | 0.00        |
    | [AllocRef_LEVY]   | 1             | 9               | 202007   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 520.45                      | 520.45           | APPS39               | ?            | 0.00        |
    | [AllocRef_LEVY]   | 1             | 10              | 202007   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1.34                        | 1.34             | APPS39               | ?            | 0.00        |
    | [AllocRef_LEVY]   | 1             | 11              | 202007   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1201.79                     | 1201.79          | APPS39               | ?            | 0.00        |
    | [AllocRef_LEVY]   | 1             | 12              | 202007   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1107.26                     | 1107.26          | APPS39               | ?            | 0.00        |
    #
	| [AllocRef_LEVY]   | 1             | 2               | 202008   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | -80.11                      | -80.11           | APPS40               | ?            | 0.00        |
    | [AllocRef_LEVY]   | 1             | 3               | 202008   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 654.24                      | 654.24           | APPS40               | ?            | 0.00        |
    | [AllocRef_LEVY]   | 1             | 4               | 202008   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 399.01                      | 399.01           | APPS40               | ?            | 0.00        |
    | [AllocRef_LEVY]   | 1             | 5               | 202008   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 0.00                        | 0.00             | APPS40               | ?            | 0.00        |
    | [AllocRef_LEVY]   | 1             | 6               | 202008   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 428.34                      | 428.34           | APPS40               | ?            | 0.00        |
    | [AllocRef_LEVY]   | 1             | 8               | 202008   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 78.84                       | 78.84            | APPS40               | ?            | 0.00        |
    | [AllocRef_LEVY]   | 1             | 9               | 202008   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | -142.68                     | -142.68          | APPS40               | ?            | 0.00        |
    | [AllocRef_LEVY]   | 1             | 10              | 202008   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 1229.20                     | 1229.20          | APPS40               | ?            | 0.00        |
    | [AllocRef_LEVY]   | 1             | 11              | 202008   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | 515.97                      | 515.97           | APPS40               | ?            | 0.00        |
    | [AllocRef_LEVY]   | 1             | 12              | 202008   | 2              | 0             | 0.00         | 0.00                 | 0.00                | 0.00                   | -193.34                     | -193.34          | APPS40               | ?            | 0.00        |


    # Check CRM after all PoI actuals have been processed (17385)
    And  the Reconciliation Data in CRM is calculated as follows for Levy
    | ContractNumber | AllocationRef   | VersionNumber | DeliverableCode | Jul-20  | Aug-20  |
    | [ContractNo]   | [AllocRef_LEVY] | 1             | 2               | 227.11  | -80.11  |
    | [ContractNo]   | [AllocRef_LEVY] | 1             | 3               | -124.40 | 654.24  |
    | [ContractNo]   | [AllocRef_LEVY] | 1             | 4               | 598.91  | 399.01  |
    | [ContractNo]   | [AllocRef_LEVY] | 1             | 5               | 440.24  | 0.00    |
    | [ContractNo]   | [AllocRef_LEVY] | 1             | 6               | 1046.26 | 428.34  |
    | [ContractNo]   | [AllocRef_LEVY] | 1             | 8               | 157.41  | 78.84   |
    | [ContractNo]   | [AllocRef_LEVY] | 1             | 9               | 520.45  | -142.68 |
    | [ContractNo]   | [AllocRef_LEVY] | 1             | 10              | 1.34    | 1229.20 |
    | [ContractNo]   | [AllocRef_LEVY] | 1             | 11              | 1201.79 | 515.97  |
    | [ContractNo]   | [AllocRef_LEVY] | 1             | 12              | 1107.26 | -193.34 |

    And  the Net Payments in CRM are calculated as follows
    | ContractNumber | AllocationRef   | VersionNumber | DeliverableCode | Jul-20   | Aug-20   |
    | [ContractNo]   | [AllocRef_LEVY] | 1             | 2               | 227.11   | -80.11   |
    | [ContractNo]   | [AllocRef_LEVY] | 1             | 3               | -124.40  | 654.24   |
    | [ContractNo]   | [AllocRef_LEVY] | 1             | 4               | 598.91   | 399.01   |
    | [ContractNo]   | [AllocRef_LEVY] | 1             | 5               | 440.24   | 0.00     |
    | [ContractNo]   | [AllocRef_LEVY] | 1             | 6               | 1046.26  | 428.34   |
    | [ContractNo]   | [AllocRef_LEVY] | 1             | 8               | 157.41   | 78.84    |
    | [ContractNo]   | [AllocRef_LEVY] | 1             | 9               | 520.45   | -142.68  |
    | [ContractNo]   | [AllocRef_LEVY] | 1             | 10              | 1.34     | 1229.20  |
    | [ContractNo]   | [AllocRef_LEVY] | 1             | 11              | 1201.79  | 515.97   |
    | [ContractNo]   | [AllocRef_LEVY] | 1             | 12              | 1107.26  | -193.34  |

    And   the Reconciliation Subnominal Amounts are calculated as follows for Levy
    | ContractNumber | AllocationRef   | ReconciliationSubnominal | Jul-20   | Aug-20   |
    | [ContractNo]   | [AllocRef_LEVY] | 2240110                  | 227.11   | -80.11   |
    | [ContractNo]   | [AllocRef_LEVY] | 2240120                  | -124.40  | 654.24   |
    | [ContractNo]   | [AllocRef_LEVY] | 2240130                  | 1039.15  | 399.01   |
    | [ContractNo]   | [AllocRef_LEVY] | 2240140                  | 1046.26  | 428.34   |
    | [ContractNo]   | [AllocRef_LEVY] | 2340110                  | 157.41   | 78.84    |
    | [ContractNo]   | [AllocRef_LEVY] | 2340120                  | 520.45   | -142.68  |
    | [ContractNo]   | [AllocRef_LEVY] | 2340130                  | 1203.13  | 1745.17  |
    | [ContractNo]   | [AllocRef_LEVY] | 2340140                  | 1107.26  | -193.34  |

    

	# Tidy Up
	And   the override date is reset

