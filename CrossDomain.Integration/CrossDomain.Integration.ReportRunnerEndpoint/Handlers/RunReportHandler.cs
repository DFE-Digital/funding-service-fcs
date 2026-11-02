namespace CrossDomain.Integration.ReportRunnerEndpoint
{
    using System;
    using System.Threading.Tasks;
    using NServiceBus;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class RunReportHandler : IHandleMessages<RunReportCommand>
    {
        public IReportRunner ReportRunner { get; set; }

        public ILogger Logger { get; set; }

        public IArchiveReportService ArchiveReportService { get; set; }

        public async Task Handle(RunReportCommand command, IMessageHandlerContext context)
        {
            Logger.LogInformation(CommonLoggingEventId.RunReportBatchStart, "Beginning run report process for file: {0}.", command.FileName);

            await Task.Factory.StartNew(() =>
            {
                try
                {
                    bool isReportSuccessfullyCreated = ReportRunner.RunReport(command);

                    if (isReportSuccessfullyCreated && !string.IsNullOrEmpty(command.ArchiveChildFolderName))
                    {
                        Logger.LogInformation(CommonLoggingEventId.AboutToArchiveReport, $"About to Archive Report: {command.FileName} to child archive folder {command.ArchiveChildFolderName}");

                        ArchiveReportService.WriteFileToArchiveFolder(command.FileName, command.ArchiveChildFolderName);

                        Logger.LogInformation(CommonLoggingEventId.ArchiveReportComplete, $"Archive Report Complete: {command.FileName} to child archive folder {command.ArchiveChildFolderName}");
                    }
                }
                catch (Exception ex)
                {
                    Logger.LogError(CommonLoggingEventId.ReportAsyncCallFailed, ex.Message, "Async call to load report {0} failed .", command.FileName);
                }
            }).ConfigureAwait(false);

            Logger.LogInformation(CommonLoggingEventId.RunReportBatchEnd, "Completed run report process for file: {0}.", command.FileName);
        }
    }
}
