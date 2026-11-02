namespace CrossDomain.Integration.ReportRunnerEndpoint
{
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;

    public interface IReportRunner
    {
        bool RunReport(RunReportCommand command);
    }
}
