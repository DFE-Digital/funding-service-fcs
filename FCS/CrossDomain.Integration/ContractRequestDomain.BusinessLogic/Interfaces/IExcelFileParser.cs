namespace SFA.FCT.ContractRequestDomain.BusinessLogic.Interfaces
{
    using System.IO;
    using CrossDomain.Integration.Entities.ExcelUpload;
    
    public interface IExcelFileParser
    {
        dataLoadResults ReadFile(Stream fileStream, string fileName);
    }
}
