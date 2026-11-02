namespace SFA.FCT.ContractRequestDomain.BusinessLogic.Services
{
    using System;
    using System.Collections.Generic;
    using System.Text;
    using CrossDomain.Integration.Common;
    using CrossDomain.Integration.Common.Storage;
    using Interfaces;

    public class Office365FileAccess : IBulkUploadFileAccess
    {
        private readonly IOffice365Adapter _office365Adapter;

        public Office365FileAccess(IOffice365Adapter office365Adapter)
        {
            _office365Adapter = office365Adapter;
        }

        public IList<string> GetNewFiles()
        {
            var files = _office365Adapter.GetAllFiles(CommonUtil.InputFolderName);

            return files;
        }

        public DateTime GetFileTimestamp(string file)
        {
            return _office365Adapter.GetFileTimestamp(file, CommonUtil.InputFolderName);
        }

        public byte[] GetBulkUploadFileContents(string file)
        {
            return _office365Adapter.GetFileContents(file, CommonUtil.InputFolderName);
        }

        public void MarkFileAsRetrieved(string file)
        {
            // changeFileName ?
            _office365Adapter.MoveFile(file, CommonUtil.InputFolderName, CommonUtil.ProcessingFolderName);
        }

        public void UnmarkFileAsRetrieved(string file)
        {
            _office365Adapter.MoveFile(file, CommonUtil.ProcessingFolderName, CommonUtil.InputFolderName);
        }

        public byte[] GetProcessingFileContents(string file)
        {
            return _office365Adapter.GetFileContents(file, CommonUtil.ProcessingFolderName);
        }

        public void MoveRejectedFileFromProcessing(string originalFileName, string rejectedFilename)
        {
            rejectedFilename += ".xlsx";
            _office365Adapter.MoveFileWithRename(originalFileName, CommonUtil.ProcessingFolderName, CommonUtil.ProcessedFolderName, rejectedFilename);
        }

        public void MoveRejectedFileFromProcessingToProcessed(string originalFileName, FileRejectionReason reason)
        {
            MoveRejectedFileFromFolder(CommonUtil.ProcessingFolderName, originalFileName, reason);
        }

        public void MoveRejectedFileFromInputToProcessed(string originalFileName, FileRejectionReason reason)
        {
            MoveRejectedFileFromFolder(CommonUtil.InputFolderName, originalFileName, reason);
        }

        public void CreateSyntaxReport(string originalFile, string contents)
        {
            string syntaxFilename = originalFile + ".Syntax Report.txt";

            _office365Adapter.DeleteFile(syntaxFilename, CommonUtil.ReportsFolderName);
            _office365Adapter.UploadFile(syntaxFilename, Encoding.UTF8.GetBytes(contents), CommonUtil.ReportsFolderName);
        }

        public string CreateResultsReport(string originalFile, byte[] contents)
        {
            string reportFilename = originalFile + ".Results Report.xlsx";

            _office365Adapter.UploadFile(reportFilename, contents, CommonUtil.ReportsFolderName);
            _office365Adapter.MoveFile(originalFile, CommonUtil.ProcessingFolderName, CommonUtil.ProcessedFolderName);
            return reportFilename;
        }

        public bool DoesFileExistInProcessing(string fileName)
        {
            return _office365Adapter.DoesFileExist(CommonUtil.ProcessingFolderName, fileName);
        }

        public bool DoesFileExistInProcessedFolder(string fileName)
        {
            return _office365Adapter.DoesFileExist(CommonUtil.ProcessedFolderName, fileName);
        }

        public bool DoesFileExistInInputFolder(string fileName)
        {
            return _office365Adapter.DoesFileExist(CommonUtil.InputFolderName, fileName);
        }

        private void MoveRejectedFileFromFolder(string folderName, string originalFileName, FileRejectionReason reason)
        {
            string rejectedFileName = $"{originalFileName}.{reason}-{DateTime.UtcNow.ToString("ddMMyyyyhhmmss")}.xlsx";
            _office365Adapter.MoveFileWithRename(originalFileName, folderName,
                CommonUtil.ProcessedFolderName, rejectedFileName);
        }
    }
}
