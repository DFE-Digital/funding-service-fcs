namespace FCT.Operations.Infrastructure
{
    public interface IOffice365StorageWrapper
    {
        bool DoesFolderExist(string folderName);
        void CreateFolder(string folderName);
        void UpsertFile(string fileName, byte[] content, string targetListName);
    }
}