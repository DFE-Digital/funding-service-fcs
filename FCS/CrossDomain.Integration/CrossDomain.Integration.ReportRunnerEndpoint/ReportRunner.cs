namespace CrossDomain.Integration.ReportRunnerEndpoint
{
    using System;
    using System.Configuration;
    using Polly;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Common.Reporting;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;

    public class ReportRunner : IReportRunner
    {
        public static string O365Folder
        {
            get { return ConfigurationManager.AppSettings["ReportDelivery.CdaO365Folder"]; }
        }

        public IOffice365Adapter Office365Adapter { get; set; }

        public ILogger Logger { get; set; }

        public IReportingServicesClient Client { get; set; }

        public virtual bool RunReport(RunReportCommand command)
        {
            try
            {
                RetryWhenExceptionOccurs(action: () =>
                {
                    Logger.LogInformation(CommonLoggingEventId.RenderReportStart, "Beginning to render {0} report.", command.FileName);

                    var bytes = Client.RenderReportWs(command.ReportName, command.ReportFormat, command.ReportParameters,
                        command.ReportPath);

                    Logger.LogInformation(CommonLoggingEventId.UploadToO365Start,
                        "Beginning to upload {0} report to Office 365.", command.FileName);

                    Office365Adapter.UploadFileWithOverwrite(command.FileName, bytes, O365Folder);
                }, 
                numRetries: 5);

                Logger.LogInformation(CommonLoggingEventId.UploadReportToO365End, "Report {0} completed succesfully run and loaded to Office365.", command.FileName);
                return true;
            }
            catch (Exception ex)
            {
                Logger.LogError(CommonLoggingEventId.RenderReportFailed, ex.Message, "Report {0} failed to run and load to Office365.", command.FileName);
                return false;
            }
        }

        private static void RetryWhenExceptionOccurs(Action action, int numRetries)
        {
            //Retry a specified number of times, using a function to
            // calculate the duration to wait between retries based on 
            // the current retry attempt (allows for exponential backoff),
            // calling an action on each retry 
            // In this case will wait for
            //  1 ^ 3 = 3 seconds then
            //  2 ^ 3 = 9 seconds then
            //  3 ^ 3 = 27 seconds then
            //  4 ^ 3 = 81 seconds then
            //  5 ^ 3 = 243 seconds about 4 minutes

            Policy.Handle<Exception>()
                .WaitAndRetry(numRetries, retryAttempt =>TimeSpan.FromSeconds(Math.Pow(3, retryAttempt)))
                .Execute(action);
        }

      
    }
}
