namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using ContractRequestDomain.Common;
    using CrossDomain.Integration.Entities.ContractRequest;

    /// <summary>
    /// This rule is for CBR-004. Contract type not valid
    /// </summary>
    public class ContractTypeValidationRule : IRule<contractRequestType>
    {
        private readonly IList<string> _validContractTypes;
        private readonly IList<string> _failedCorrelationIds = new List<string>();

        public ContractTypeValidationRule(IEnumerable<string> validContractTypes)
        {
            _validContractTypes = validContractTypes.ToList();
        }

        public string ErrorMessage => ErrorMessages.ContractTypeIsNotValidForContract;

        public errorInfoTypeLevel ErrorLevel => errorInfoTypeLevel.Contract;

        public IEnumerable<string> GetFailuresForItem(contractRequestType item)
        {
            item.contract.contracts.ForEach(CheckContractType);

            return _failedCorrelationIds;
        }

        private bool IsContractTypeValid(string contractType)
        {
            return !_validContractTypes.Contains(contractType, StringComparer.OrdinalIgnoreCase);
        }

        private void CheckContractType(contractType contract)
        {
            if (IsContractTypeValid(contract.contractType1))
            {
                _failedCorrelationIds.Add(contract.correlationId);
            }
        }
    }
}
