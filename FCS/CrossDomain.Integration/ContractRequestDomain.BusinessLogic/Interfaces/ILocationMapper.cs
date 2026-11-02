namespace SFA.FCT.ContractRequestDomain.BusinessLogic.Interfaces
{
    using System.Collections.Generic;
    using Common;
    using CrossDomain.Integration.Entities.ContractRequest;
    using CrossDomain.Integration.Entities.ExcelUpload;

    public interface ILocationMapper
    {
        IDictionary<string, ExcelLocation> GenerateExcelLocations(dataLoadResults dataLoadResults);

        void UpdateWithStructuralInformation(IDictionary<string, ExcelLocation> locations, contractRequestType contractRequest);
    }
}
