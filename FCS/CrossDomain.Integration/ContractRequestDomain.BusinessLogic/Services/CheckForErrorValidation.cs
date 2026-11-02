namespace SFA.FCT.ContractRequestDomain.BusinessLogic.Services
{
    using Interfaces;    
    using CrossDomain.Integration.Entities.ExcelUpload;

    public class CheckForErrorValidation : ICheckForErrorValidation
    {
        public bool Validate(dataLoadResults dataLoadResults)
        {
            return dataLoadResults.error == null || dataLoadResults.error.Length == 0;
        }
    }
}
