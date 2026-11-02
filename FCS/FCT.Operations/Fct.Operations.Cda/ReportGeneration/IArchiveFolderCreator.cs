namespace FCT.Operations.Cda.ReportGeneration
{
    public interface IArchiveFolderCreator
    {
        void CreateArchiveRootFolderAndChildFolder(string archiveChildFolderName);

        string GenerateArchiveChildFolderName();
    }
}