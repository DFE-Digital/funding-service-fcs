namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules.UDC
{
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.ContractRequest;

    public class MustSpecifyContractNumberRule : IRule<contractRequestType>
    {
        public string RuleNumber
        {
            get { return "UDC-004"; }
        }

        public string ErrorMessage
        {
            get { return ValidationRuleErrorMessages.MustSpecifyContractNumber; }
        }

        public errorInfoTypeLevel ErrorLevel
        {
            get { return errorInfoTypeLevel.Contract; }
        }

        public IEnumerable<string> GetFailuresForItem(contractRequestType contractRequest)
        {
            var masterContract = contractRequest.contract;
            var failures = new List<string>();
            var contract = masterContract.contracts.First();

            masterContract.contracts
                          .ForEach(c =>
                                   {
                                       if (contract.CRMIntent == intent.UpdateDraft &&
                                           string.IsNullOrWhiteSpace(contract.contractNumber))
                                       {
                                           failures.Add(contract.correlationId);
                                       }
                                   });

            return failures;
        }
    }
}
