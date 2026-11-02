namespace SFA.FCT.ContractRequestDomain.BusinessLogic.Interfaces
{
    using System.Collections.Generic;
    using NSBFramework;
    using CrossDomain.Integration.Entities.ExcelUpload;

    public interface IContractSyntaxValidation : IContentEnricher<dataLoadResults>
    {
        bool ValidateFile(dataLoadResults file);

        IReadOnlyCollection<errorInfo> Errors { get; }
    }
}
