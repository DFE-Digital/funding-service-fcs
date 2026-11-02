namespace FCT.Operations.Cda.ReportUpload
{
    public interface IArchiveReportService
    {
        void WriteFileToArchiveFolder(string fileName, string archiveChildFolderName);
    }
}