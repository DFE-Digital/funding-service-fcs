namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules.UDC
{
    using System.Collections.Generic; 
    using CrossDomain.Integration.Entities.ContractRequest;

    public class MustSpecifyMasterContractNumberRule : IRule<contractRequestType>
    {
        public string RuleNumber
        {
            get { return "UDC-003"; }
        }

        public string ErrorMessage
        {
            get { return ValidationRuleErrorMessages.MustSpecifyMasterContractNumber; }
        }

        public errorInfoTypeLevel ErrorLevel
        {
            get { return errorInfoTypeLevel.MasterContract; }
        }

        public IEnumerable<string> GetFailuresForItem(contractRequestType contractRequest)
        {
            var masterContract = contractRequest.contract;
            var failures = new List<string>();

            if (masterContract.CRMIntent == intent.UpdateDraft && string.IsNullOrWhiteSpace(masterContract.contractNumber))
            {
                failures.Add(masterContract.correlationId);
            }

            return failures;
        }
    }
}
