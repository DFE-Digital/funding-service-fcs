namespace SFA.FCT.CrossDomain.Integration.Common.Storage
{
    using System;
    using System.Collections.Generic;

    public interface IOffice365Adapter
    {
        List<string> GetAllFiles(string listName);

        IList<string> GetFilenamesByFileNameStartText(string libraryName, string fileNameStartText);

        Dictionary<string, byte[]> GetFilesByFileNameStartText(string libraryName, string fileNameStartText);

        int GetFileVersionCount(string fileName, string listName);

        DateTime GetFileTimestamp(string fileName, string listName);

        byte[] GetFileContents(string fileName, string listName);

        byte[] GetFileContents(string listName, string folderName, string fileName);

        void MoveFile(string originalFileName, string sourceListName, string targetListName);

        void UploadFile(string fileName, byte[] content, string targetListName);

        void UploadFileWithOverwrite(string fileName, byte[] content, string targetListName);

        void UploadFile(string fileName, byte[] content, string listName, string targetListName);

        void DeleteFile(string fileName, string listName);

        void DeleteFile(string fileName, string listName, string folderName);

        void RemoveOldFilesFromFolder(string listName, int offsetFromToday);

        void RenameFile(string sourceFileName, string targetFileName, string listName, string folderName);

        void RenameFile(string sourceFileName, string targetFileName, string listName);

        bool DoesFileExist(string listName, string folderName, string fileName);

        bool DoesFileExist(string listName, string fileName);

        bool DoesFolderExist(string listName, string folderName);

        bool DoesLibraryExist(string folderName);

        void MoveFileWithRename(string originalFileName, string sourceListName, string targetListName, string newFileName);

        void CreateLibrary(string folderName);

        void CreateFolder(string listName, string folderName);

        void CreateFolder(string rootListName, string listName, string folderName);

        void UploadFileToFolderWithOverwrite(string rootFolder, string childFolder, byte[] content, string fileName);

        void UploadFileToFolderWithOverwrite(string rootFolder, string childFolder, string childOfChildFolder, byte[] content, string fileName);

        void UploadFilesToFolderWithOverwrite(string rootFolder, string childFolder, IReadOnlyCollection<Office365FileInfo> files);

        void UpsertFile(string fileName, byte[] content, string targetListName);
    }
}
