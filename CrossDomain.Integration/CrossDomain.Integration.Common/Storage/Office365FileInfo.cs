namespace SFA.FCT.CrossDomain.Integration.Common.Storage
{
    public class Office365FileInfo
    {
        public Office365FileInfo(string fileName, byte[] content)
        {
            FileName = fileName;
            Content = content;
        }

        public string FileName { get; }

        public byte[] Content { get; }
    }
}
