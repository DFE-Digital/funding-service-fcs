namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation
{
    using System.Collections.Generic;
    using CrossDomain.Integration.Entities.ContractRequest;

    public interface IRule<TItem>
    {
        ////bool Validate(TItem itemToValidate);

        string ErrorMessage { get; }

        errorInfoTypeLevel ErrorLevel { get; }

        /// <summary>
        /// Runs the rule on the item and returns the correlationIds
        /// </summary>
        /// <param name="itemToValidate">the item to run the rule on</param>
        /// <returns> the correlationIds</returns>
        IEnumerable<string> GetFailuresForItem(TItem itemToValidate);
    }
}
