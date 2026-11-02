namespace FCT.Operations.Cda.Infrastructure
{
    public interface IOffice365StorageWrapper
    {
        bool DoesFolderExist(string folderName);
        bool DoesFolderExist(string listName, string folderName);
        bool DoesFileExist(string listName, string fileName);
        void CreateFolder(string folderName);
        void CreateFolder(string rootListName, string listName, string folderName);
        void CreateFolder(string listName, string folderName);
        void UpsertFile(string fileName, byte[] content, string targetListName);
        byte[] GetFileContents(string fileName, string listName);
        void UploadFileWithOverwrite(string fileName, byte[] content, string targetListName);

        void UploadFileToFolderWithOverwrite(string rootFolder, string childFolder, string childOfChildFolder,
            byte[] content, string fileName);
    }
}