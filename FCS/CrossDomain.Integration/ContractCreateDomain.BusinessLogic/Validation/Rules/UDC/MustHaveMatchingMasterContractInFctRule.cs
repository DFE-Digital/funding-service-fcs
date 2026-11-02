namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules.UDC
{
    using System.Collections.Generic;
    using CrossDomain.Integration.Entities.ContractRequest;

    public class MustHaveMatchingMasterContractInFctRule : IRule<contractRequestType>
    {
        public string RuleNumber
        {
            get { return "UDC-011"; }
        }

        public string ErrorMessage
        {
            get { return ValidationRuleErrorMessages.MustHaveMatchingMasterContractInFct; }
        }

        public errorInfoTypeLevel ErrorLevel
        {
            get { return errorInfoTypeLevel.MasterContract; }
        }

        public IEnumerable<string> GetFailuresForItem(contractRequestType contractRequest)
        {
            var masterContract = contractRequest.contract;
            var failures = new List<string>();
            if (masterContract.crmNotPresent)
            {
                failures.Add(masterContract.correlationId);
            }

            return failures;
        }
    }
}