namespace SFA.FCT.CrossDomain.Integration.Common.Reporting
{
    public interface IReportingServicesClient
    {
        byte[] RenderReportWs(string reportName, string outputFormat, string[][] reportParams, string reportPath);
    }
}
