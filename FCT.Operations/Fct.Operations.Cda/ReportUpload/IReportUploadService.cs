namespace FCT.Operations.Cda.ReportUpload
{
    using Dtos;

    public interface IReportUploadService
    {
        void UploadReportToSharePoint(Report report);
        void WriteFileToArchiveFolder(string fileName, string archiveChildFolderName);
    }
}