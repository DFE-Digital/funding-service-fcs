namespace SFA.FCT.DocumentsDomain.Integration
{
    using System.Collections.Generic;
    using Common.Models;

    public interface IDocumentRepository
    {
        byte[] GetDocument(FctFile sourceFile);

        ////byte[][] GetDocuments(List<FctSourceFile> sourceFiles);

        void CopyDocument(FctFile file, FctFile targetFile);

        void SaveDocument(FctFile file, byte[] document);

        bool FileExists(FctFile file);

        void DeleteFile(FctFile file);
    }
}
