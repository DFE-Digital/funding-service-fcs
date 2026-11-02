namespace FCT.Operations.Cda.ReportUpload
{
    using Dtos;

    public interface IClosedReportService
    {
        void UploadReportToSharePointIfNecessary(Report closedReport);
    }
}