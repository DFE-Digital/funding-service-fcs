namespace SFA.FCT.ContractCreateDomain.BusinessLogic
{
    using System.Collections.Generic;
    using CrossDomain.Integration.Entities.ContractRequest;
    using CrossDomain.Integration.Events;
    using Validation;

    public class ContractValidator : IContractValidator
    {
        private readonly ConditionalRuleExtractor _conditionalRuleExtractor = new ConditionalRuleExtractor();

        public void Enrich(NewContractRequestEvent message)
        {
            List<IRule<contractRequestType>> rules = new List<IRule<contractRequestType>>();
           
            ////rules.AddRange(_conditionalRuleExtractor.CreateConditionalRules(message));

            new Validator().Validate(message.ContractRequest, rules);
        }
    }
}