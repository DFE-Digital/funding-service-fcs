namespace CrossDomain.Integration.ReportRunnerEndpoint.Services
{
    public interface IArchiveReportService
    {
        void CreateArchiveRootFolderAndChildFolder(string archiveChildFolderName);

        string GenerateArchiveChildFolderName();

        void WriteFileToArchiveFolder(string fileName, string archiveChildFolderName);
    }
}