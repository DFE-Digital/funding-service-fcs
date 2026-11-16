namespace SFA.FCT.DocumentsDomain.DocumentGeneration
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.CorporateContract;

    public class CorporateContractValidator : ICorporateContractValidator
    {
        private static readonly List<ValidationRule<Contract>>  MasterContractValidators;
        private static readonly List<ValidationRule<contractType>> ContractValidators;
        private static readonly List<ValidationRule<contractAllocationsContractAllocation>> AllocationValidators;

        static CorporateContractValidator()
        {
            MasterContractValidators = new List<ValidationRule<Contract>>
            {
                new ValidationRule<Contract>("Master contract is missing from message", masterContract => masterContract == null),
                new ValidationRule<Contract>("Master contract has no contract number", masterContract => string.IsNullOrEmpty(masterContract.contractNumber)),
                new ValidationRule<Contract>("Master contract has no funding type", masterContract => masterContract.fundingType == null || string.IsNullOrEmpty(masterContract.fundingType.fundingTypeCode)),
                new ValidationRule<Contract>("Master contract has no contracts", masterContract => masterContract.contracts == null || masterContract.contracts.Count == 0),
                new ValidationRule<Contract>("Master contract has more than one contract", masterContract => masterContract.contracts.Count > 1)
            };

            ContractValidators = new List<ValidationRule<contractType>>
            {
                new ValidationRule<contractType>("Contract is missing a contract number", contract => string.IsNullOrEmpty(contract.contractNumber)),
                new ValidationRule<contractType>("Contract start date not supplied", contract => contract.startDate == DateTime.MinValue),
                new ValidationRule<contractType>("Contract has no allocations", contract => contract.contractAllocations == null || contract.contractAllocations.Count == 0)
            };

            AllocationValidators = new List<ValidationRule<contractAllocationsContractAllocation>>
            {
                new ValidationRule<contractAllocationsContractAllocation>("Allocation has no start date", contractAllocation => contractAllocation.startDate == DateTime.MinValue),                
                new ValidationRule<contractAllocationsContractAllocation>("Allocation has no funding stream code", contractAllocation => contractAllocation.fundingStream == null || string.IsNullOrEmpty(contractAllocation.fundingStream.fundingStreamCode)),
                new ValidationRule<contractAllocationsContractAllocation>("Allocation has no deliverables", contractAllocation => contractAllocation.contractDeliverables == null || contractAllocation.contractDeliverables.Count == 0)
            };
        }

        public string Validate(Contract contract)
        {
            foreach (var validation in ContractValidators.Where(validation => validation.Rule(contract)))
            {
                return validation.ErrorMessage;
            }

            foreach (var contractAllocation in contract.contractAllocations)
            {
                foreach (var validation in AllocationValidators.Where(validation => validation.Rule(contractAllocation)))
                {
                    return validation.ErrorMessage;
                }
            }

            return string.Empty;
        }

        private class ValidationRule<T>
        {
            public ValidationRule(string errorMessage, Func<T, bool> rule)
            {
                ErrorMessage = errorMessage;
                Rule = rule;
            }

            public string ErrorMessage { get; }

            public Func<T, bool> Rule { get; }
        }
    }
}
