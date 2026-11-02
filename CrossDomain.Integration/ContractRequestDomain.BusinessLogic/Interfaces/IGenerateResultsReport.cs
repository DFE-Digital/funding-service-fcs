namespace SFA.FCT.ContractRequestDomain.BusinessLogic.Interfaces
{
    using Common;

    public interface IGenerateResultsReport
    {
        byte[] GenerateReport(byte[] originalFileContents, ContractRequestResult[] results, ExcelLocation[] locationMapping);
    }
}
