namespace SFA.FCT.CrossDomain.Integration.Common.Reporting
{
    using System.Configuration;
    using System.Linq;
    using System.Net;

    public class ReportingServicesClient// : IReportingServicesClient
    {
        //    private const string DevInfo = @"<DeviceInfo><Toolbar>False</Toolbar></DeviceInfo>";

        //    public static string Username
        //    {
        //        get { return ConfigurationManager.AppSettings["ReportDelivery.Username"]; }
        //    }

        //    public static string Password
        //    {
        //        get { return ConfigurationManager.AppSettings["ReportDelivery.Password"]; }
        //    }

        //    public IReportExecutionService ReportService { get; set; }

        //    public byte[] RenderReportWs(string reportName, string outputFormat, string[][] reportParams, string reportPath)
        //    {
        //        ReportService.Timeout = int.Parse(ConfigurationManager.AppSettings["ReportDelivery.Timeout"]);

        //        ReportService.Credentials = new NetworkCredential(Username, Password);

        //        var execHeader = new ExecutionHeader();

        //        ReportService.ExecutionHeaderValue = execHeader;

        //        ReportService.LoadReport(reportPath + reportName, null);

        //        ReportService.SetExecutionParameters(reportParams.Select(item => new ParameterValue { Name = item[0], Value = item[1] }).ToArray(), "en-GB");

        //        string sessionId = ReportService.ExecutionHeaderValue.ExecutionID;

        //        string extension;
        //        string mimetype;
        //        string encoding;
        //        Warning[] warnings;
        //        string[] streamIds;
        //        var result = ReportService.Render(outputFormat, DevInfo, out extension, out mimetype, out encoding, out warnings, out streamIds);

        //        return result;
        //    }                
        //}
    }
}
