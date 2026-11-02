namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules.UDC
{
    using System.Collections.Generic;
    using CrossDomain.Integration.Entities.ContractRequest;

    /// <summary>
    /// Represents Update Draft Contract validation logic
    /// </summary>
    public interface IUpdateDraftContractValidationRule
    {
        /// <summary>
        /// The Rule Number specified by the Contract Data Load Validation Rules specification.
        /// </summary>
        string RuleNumber { get; }
        
        /// <summary>
        /// The message to be used when the rule failed.
        /// </summary>
        string ErrorMessage { get; }

        /// <summary>
        /// Applies the validation rule.
        /// </summary>
        /// <param name="masterContract">Validation starts at Master Contract level.</param>
        /// <returns>A collection of CorrelationId indicating items that have failed the rule.</returns>
        IEnumerable<string> ApplyRule(contractType masterContract);
    }
}
