namespace SFA.FCT.CrossDomain.Integration.Common.Reporting
{
    using System;
    using System.Configuration;
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using SFA.FCT.Framework.Logging.Interfaces;
//    using SFA.FCT.CrossDomain.Integration.Messages.Commands;

    public class ReportRunner : IReportRunner
    {
        public static string O365Folder
        {
            get { return ConfigurationManager.AppSettings["ReportDelivery.CdaO365Folder"]; }
        }

        public IOffice365Adapter Office365Adapter { get; set; }

        public ILogger Logger { get; set; }

        public IReportingServicesClient Client { get; set; }
        
        ////public virtual bool RunReport(RunReportCommand command)
        //{
        //    try
        //    {
        //        Logger.LogInformation(CommonLoggingEventId.RenderReportStart, "Beginning to render {0} report.", command.FileName);

        //        var bytes = Client.RenderReportWs(command.ReportName, command.ReportFormat, command.ReportParameters, command.ReportPath);

        //        Logger.LogInformation(CommonLoggingEventId.UploadToO365Start, "Beginning to upload {0} report to Office 365.", command.FileName);

        //        Office365Adapter.UploadFileWithOverwrite(command.FileName, bytes, O365Folder);

        //        Logger.LogInformation(CommonLoggingEventId.UploadReportToO365End, "Report {0} completed succesfully run and loaded to Office365.", command.FileName);
        //        return true;
        //    }
        //    catch (Exception ex)
        //    {
        //        Logger.LogError(CommonLoggingEventId.RenderReportFailed, ex.Message, "Report {0} failed to run and load to Office365.", command.FileName);
        //        return false;
        //    }
        //}
    }
}
