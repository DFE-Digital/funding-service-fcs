namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules.UDC
{
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.ContractRequest;
    using MoreLinq;

    public class MustSpecifyContractAllocationNumberDeleteRule : IRule<contractRequestType>
    {
        public string RuleNumber
        {
            get { return "UDC-007"; }
        }

        public string ErrorMessage
        {
            get { return ValidationRuleErrorMessages.MustSpecifyContractAllocationNumberDelete; }
        }

        public errorInfoTypeLevel ErrorLevel
        {
            get { return errorInfoTypeLevel.Allocation; }
        }

        public IEnumerable<string> GetFailuresForItem(contractRequestType contractRequest)
        {
            var masterContract = contractRequest.contract;
            var failures = new List<string>();

            masterContract.contracts.SelectMany(c => c.contractAllocations)
                          .ForEach(ca =>
                                   {
                                       if (ca.CRMIntent == intent.DeleteDraft &&
                                           string.IsNullOrWhiteSpace(ca.contractAllocationNumber))
                                       {
                                           failures.Add(ca.correlationId);
                                       }
                                   });

            return failures;
        }
    }
}
