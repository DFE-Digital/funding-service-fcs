namespace DocumentsDomain.Endpoint.ArchiveDocument
{
    using System;
    using System.Security.Cryptography;
    using System.Text;
    using SFA.FCT.DocumentsDomain.Common;

    public enum FileAction
    {
        NotSet,
        Delete,
        Archive
    }

    public class FileInfo
    {
        public FileInfo(string filename, string folderName, FileAction fileAction, ContractAmendmentType amendmentType)
        {
            Filename = filename;
            FolderName = folderName;
            FileAction = fileAction;
            AmendmentType = amendmentType;
        }

        public string Filename { get; }

        public string FolderName { get; }

        public FileAction FileAction { get; }

        public ContractAmendmentType AmendmentType { get; }

        public Guid GetGuid()
        {
            string input = $"{Filename}{FolderName}{FileAction}{AmendmentType}";
            using (MD5 md5 = MD5.Create())
            {
                byte[] hash = md5.ComputeHash(Encoding.Default.GetBytes(input));
                return new Guid(hash);
            }
        }
    }
}
