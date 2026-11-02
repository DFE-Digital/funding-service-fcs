namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules
{
    using System.Collections.Generic;
    using System.Linq;
    using ContractRequestDomain.Common;
    using CrossDomain.Integration.Entities.ContractRequest;
    using MoreLinq;

    /// <summary>
    /// CBR-009
    /// If CRM intent is 'New' or 'New-Variation' all levels of the contract relating to the contract 
    /// should also have a CRM Intent value of 'New'
    /// </summary>
    public class NewIntentConsistentRule : IRule<contractRequestType>
    {
        private readonly IEnumerable<intent> _crmIntents = new List<intent>
        {
            intent.New,
            intent.NewAmendment,
            intent.RevisedNew
        };

        public string ErrorMessage => ErrorMessages.CrmIntentIsNotConsistent;

        public errorInfoTypeLevel ErrorLevel => errorInfoTypeLevel.Contract;

        public IEnumerable<string> GetFailuresForItem(contractRequestType itemToValidate)
        {
            IList<string> failures = new List<string>();

            if (_crmIntents.Contains(itemToValidate.contract.CRMIntent))
            {
                var contractsWithoutNewOrNewVariationIntent =
                    itemToValidate.contract.contracts.Where(c => !_crmIntents.Contains(c.CRMIntent));

                contractsWithoutNewOrNewVariationIntent.ForEach(c => failures.Add(c.correlationId));
                
                var contractsNewList =
                    itemToValidate.contract.contracts.Where(c => _crmIntents.Contains(c.CRMIntent));

                foreach (var contractsNew in contractsNewList)
                {
                    var allocationsWithoutNewOrNewVariationIntent =
                        contractsNew.contractAllocations.Where(c => !_crmIntents.Contains(c.CRMIntent));

                    allocationsWithoutNewOrNewVariationIntent.ForEach(a => failures.Add(a.correlationId));
                   
                    var allocationsWithNewOrNewVariationIntent =
                        contractsNew.contractAllocations.Where(c => _crmIntents.Contains(c.CRMIntent));

                    foreach (var allocationsNew in allocationsWithNewOrNewVariationIntent)
                    {
                        var deliverablesWithoutNewOrNewVariationIntent =
                            allocationsNew.contractDeliverables.Where(c => !_crmIntents.Contains(c.CRMIntent));

                        deliverablesWithoutNewOrNewVariationIntent.ForEach(d => failures.Add(d.correlationId));
                    }
                }
            }

            return failures;
        }
    }
}