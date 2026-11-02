namespace SFA.FCT.ContractRequestDomain.BusinessLogic.Validation
{
    using System.Collections.Generic;
    using CrossDomain.Integration.Entities.ExcelUpload;

    public abstract class AbstractFileRule : IFileRule
    {
        public virtual bool RunIfErrorsHaveAlreadyOccured => true;

        public abstract List<errorInfo> GetFailuresForItem(dataLoadResults itemToValidate);
    }
}
