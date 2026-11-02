namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules.UDC
{
    using System.Collections.Generic;
    using CrossDomain.Integration.Entities.ContractRequest;

    /// <summary>
    /// UDC-020. Cannot create a draft Contract Amendment if there is no existing Approved or Withdrawn Contract.
    /// </summary>
    public class ContractAmendmentMustHaveExistingApprovedOrWithdrawnContractRule : IRule<contractRequestType>
    {
        public string ErrorMessage => ValidationRuleErrorMessages.ContractAmendmentMustHaveExistingApprovedContract;

        public errorInfoTypeLevel ErrorLevel => errorInfoTypeLevel.Contract;

        public IEnumerable<string> GetFailuresForItem(contractRequestType itemToValidate)
        {
            var failures = new List<string>();
            var masterContract = itemToValidate.contract;

            foreach (var contract in masterContract.contracts)
            {
                if (!contract.IsApprovedContractWithContractNumberPresentInCrm)
                {
                    failures.Add(contract.correlationId);
                }
            }
            
            return failures;
        }
    }
}