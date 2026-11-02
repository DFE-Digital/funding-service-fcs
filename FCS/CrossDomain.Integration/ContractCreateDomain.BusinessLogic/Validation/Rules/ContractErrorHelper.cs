namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules
{
    using System.Collections.Generic;
    using CrossDomain.Integration.Entities.ContractRequest;

    public static class ContractErrorHelper
    {
        public static void AddErrorsToContract(contractRequestType contract, List<errorInfoType> errors)
        {
            if (contract.errorInfo == null)
            {
                contract.errorInfo = errors;
            }
            else
            {
                contract.errorInfo.AddRange(errors);
            }
        }

        public static void AddErrorMsgToErrorList(List<errorInfoType> errors, string correlationId, errorInfoTypeLevel level, string errorMsg)
        {
            errors.Add(new errorInfoType
            {
                correlationId = correlationId,
                level = level,
                Value = errorMsg
            });
        }
    }
}
