namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation
{
    using System.Collections.Generic;
    using CrossDomain.Integration.Entities.ContractRequest;

    public interface IValidator
    {
        bool Validate(contractRequestType itemToValidate, IEnumerable<IRule<contractRequestType>> rules);
    }
}