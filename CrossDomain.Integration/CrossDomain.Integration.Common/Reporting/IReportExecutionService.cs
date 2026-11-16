namespace SFA.FCT.CrossDomain.Integration.Common.Reporting
{
    using System.Net;
     
    public interface IReportExecutionService
    {
        int Timeout { get; set; }

        ICredentials Credentials { get; set; }

        //ExecutionHeader ExecutionHeaderValue { get; set; }

        //ExecutionInfo GetExecutionInfo();

        //ExecutionInfo LoadReport(string report, string historyId);

        //byte[] Render(string format, string deviceInfo, out string extension, out string mimeType, out string encoding, out Warning[] warnings, out string[] streamIds);

        //ExecutionInfo SetExecutionParameters(ParameterValue[] parameters, string parameterLanguage);
    }
}