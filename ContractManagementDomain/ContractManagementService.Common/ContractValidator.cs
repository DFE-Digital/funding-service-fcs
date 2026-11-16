namespace SFA.FCT.ContractManagementService.Common
{
    using System;
    using System.Linq;
    using CrossDomain.Integration.Entities.CorporateContract;
    using CorporateSchema = CrossDomain.Integration.Entities.CorporateSchema.Contract;

    public static class ContractValidator
    {

        public static bool ValidateMasterAndChildContractNumber(string masterContractNumber, string contractNumber,
            out string errorMessage)
        {
            errorMessage = string.Empty;

            if (string.IsNullOrEmpty(contractNumber) || string.IsNullOrEmpty(masterContractNumber))
            {
                errorMessage = "Missing MasterContractNumber or ContractNumber";
                return false;
            }
            return true;
        }

        public static bool ValidateMasterAndChildContracts(Contract masterContract, out string errorMessage)
        {
            errorMessage = string.Empty;

            if (masterContract == null)
            {
                errorMessage = "ContractManageService called with null contract.";
                return false;
            }

            if ((masterContract.contracts?.Count ?? 0) == 0)
            {
                errorMessage = "ContractManageService called with no child contracts.";
                return false;
            }

            if (masterContract.hierarchyType != hierarchyType.MASTERCONTRACT)
            {
                errorMessage = "ContractManageService called with child contract.";
                return false;
            }

            if (masterContract.contracts?.Count != 1)
            {
                errorMessage = "ContractManageService must be called with single child contract.";
                return false;
            }



            return true;
        }

        public static bool ValidateContractStatus(Contract masterContract, out string errorMessage)
        {
            errorMessage = string.Empty;
            var contract = masterContract.contracts.First();

            CorporateSchema.contractStatusTypeStatus enumContractStatus;
            bool validContractStatus = Enum.TryParse(contract.contractStatus.status, out enumContractStatus);

            if (!validContractStatus)
            {
                errorMessage =
                    $"ContractManageService must be called with a valid contractstatus. {contract.contractStatus.status} is invalid.";
                return false;
            }
            return true;
        }
    }
}
