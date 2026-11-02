namespace SFA.FCT.ContractRequestDomain.BusinessLogic.Validation
{
    using System.Collections.Generic;
    using CrossDomain.Integration.Entities.ExcelUpload;

    public interface IFileRule
    {
        List<errorInfo> GetFailuresForItem(dataLoadResults itemToValidate);
    }
}
