namespace SFA.FCT.ContractRequestDomain.BusinessLogic.Interfaces
{
    using System;
    using System.Collections.Generic;

    public interface IBulkUploadFileAccess
    {
        IList<string> GetNewFiles();

        DateTime GetFileTimestamp(string file);
 
        byte[] GetBulkUploadFileContents(string file);

        void MarkFileAsRetrieved(string file);

        void UnmarkFileAsRetrieved(string file);

        byte[] GetProcessingFileContents(string file);

        void CreateSyntaxReport(string originalFile, string contents);

        void MoveRejectedFileFromProcessing(string originalFileName, string rejectedFileName);

        void MoveRejectedFileFromProcessingToProcessed(string originalFileName, FileRejectionReason reason);

        void MoveRejectedFileFromInputToProcessed(string originalFileName, FileRejectionReason reason);

        string CreateResultsReport(string originalFile, byte[] contents);

        bool DoesFileExistInProcessing(string fileName);

        bool DoesFileExistInProcessedFolder(string fileName);

        bool DoesFileExistInInputFolder(string fileName);
    }
}
