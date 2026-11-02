@Feature14826

Feature: WithdrawlContractCreateRevisedNewValidation
	As an Allocations user
	I Want to be able to validate Revised New Contract
	And check validation is correct

@AcceptanceTest @Withdrawn20221104
Scenario: E072 Rule CBR-013a and Rule CBR-012b is validated when no Contract Number or Master Contract is specified for an Revised New Contract 
(and there is a matching natural key for the contract in the system (CBR-013e)
	
	Given all contracts with this ukprn have been deleted '90018468'
	And all contracts with this ukprn have been deleted '80018468'
	And   the override date is '22/07/2016'
	And The file 'MAIN AY 1617 14052015130000 RevisedNew1.xlsx' file exists at 'DataFiles\Release2' with a UKPRN '90018468'

	And   the draft contract header details for the latest version of the contract are as follows
    | UKPRN    | LegalName  | MasterContractNumber | ContractNumber   | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent | OrgId      |
    | 90018468 | NACRO		| SFA-5068			   | MAIN-5068		  | 1                     |  01/08/2016       |  31/07/2017     | 12000		    | Contract for Services | 1420   | New       | ORG0017990 |
	
	And   the contract exists in CRM
	
	When the file for syntax validation is copied from the source location to the 'Input'
	Then I should see a file for syntax validation success report
	And a results report excel spreadsheet is generated in the storage 
	And '[Contract] A contract number and master contract number must be specified when creating a Revised New contract' is in Row '2' of the 'Results' Column on the 'Contract' tab of the result report
	And '[Contract] Cannot create Contract Amendment or Revised New Contract as an existing contract for this given UKPRN cannot be found matching this Contract Number, Period and Funding Type.' is in Row '3' of the 'Results' Column on the 'Contract' tab of the result report

@AcceptanceTest @Withdrawn20221104
Scenario: E073 Rule CBR-013b is validated when no existing Contract Number exists for an Revised New Contract
	
	Given all contracts with this ukprn have been deleted '90018469'
	And   the override date is '22/07/2016'
   	And The file 'MAIN AY 1617 14052015130000 RevisedNew2.xlsx' file exists at 'DataFiles\Release2' with a UKPRN '90018469'
	When the file for syntax validation is copied from the source location to the 'Input'
	Then I should see a file for syntax validation success report
	And a results report excel spreadsheet is generated in the storage 
	And '[Contract] A contract number must exist when creating a Revised New contract' is in Row '2' of the 'Results' Column on the 'Contract' tab of the result report

@AcceptanceTest @Withdrawn20221104
Scenario: E074 Rule CBR-013c is validated when no Contract Number is specified for an Revised New Contract
	
	Given all contracts with this ukprn have been deleted '90018470'
	And   the override date is '22/07/2016'
	And The file 'MAIN AY 1617 14052015130000 RevisedNew3.xlsx' file exists at 'DataFiles\Release2' with a UKPRN '90018470'

	And   the draft contract header details for the latest version of the contract are as follows
    | UKPRN    | LegalName  | MasterContractNumber | ContractNumber   | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent | OrgId      |
    | 90018470 | NACRO		| SFA-5070			   | MAIN-5070		  | 1                     |  01/08/2016       |  31/07/2017     | 12000		    | Contract for Services | 1420   | New       | ORG0017990 |
	
	And   the contract exists in CRM
	
	When the file for syntax validation is copied from the source location to the 'Input'
	Then I should see a file for syntax validation success report
	And a results report excel spreadsheet is generated in the storage 
	And '[Contract] Amendent Type must be blank when creating a 'Revised New' contract' is in Row '2' of the 'Results' Column on the 'Contract' tab of the result report

@AcceptanceTest @Withdrawn20221104
Scenario: E075 Rule CBR-013d is validated when no Contract Number is specified for an Revised New Contract
	
	Given all contracts with this ukprn have been deleted '90018471'
	And   the override date is '22/07/2016'
	And The file 'MAIN AY 1617 14052015130000 RevisedNew4.xlsx' file exists at 'DataFiles\Release2' with a UKPRN '90018471'
	And   the draft contract header details for the latest version of the contract are as follows
    | UKPRN    | LegalName  | MasterContractNumber | ContractNumber   | ContractVersionNumber | ContractStartDate | ContractEndDate | ContractValue | ContractType          | Period | CRMIntent | OrgId      |
    | 90018471 | NACRO		| SFA-5071			   | MAIN-5071		  | 1                     |  01/08/2016       |  31/07/2017     | 100000	    | Contract for Services | 1420   | New       | ORG0017990 |
	
	And   the contract exists in CRM
	
	When the file for syntax validation is copied from the source location to the 'Input'
	Then I should see a file for syntax validation success report
	And a results report excel spreadsheet is generated in the storage 
	And '[Contract] Cannot create Contract Amendment or Revised New Contract as an existing contract for this given UKPRN cannot be found matching this Contract Number, Period and Funding Type.' is in Row '2' of the 'Results' Column on the 'Contract' tab of the result report

