namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System.Linq;
    using CrossDomain.Integration.Common.Storage;
    using CrossDomain.Integration.Common.Storage.Office365Helpers;

    public static class SharepointDocumentRepository
    {
        public static void DeleteFileIfExists(string listName, string fileName)
        {
            var storageWrapper = new Office365StorageWrapper();

            bool doesFileExist = storageWrapper.DoesFileExist(listName: listName, fileName: fileName);
            if (doesFileExist)
            {
                storageWrapper.DeleteFile(fileName: fileName, listName: listName);
            }
        }

        public static bool DoesFileWithPrefixExistInFolder(string filePrefix, string folderName)
        {
            // Use the wrapper’s Graph-backed prefix search (starts-with on name)
            var storageWrapper = new Office365StorageWrapper();
            var matches = storageWrapper.GetFilenamesByFileNameStartText(libraryName: folderName, fileNameStartText: filePrefix);
            return matches != null && matches.Any();
        }

        public static byte[] GetDocumentBytes(string folderName, string fileName)
        {
            return new Office365StorageWrapper().GetFileContents(fileName: fileName, listName: folderName);
        }
    }
}
