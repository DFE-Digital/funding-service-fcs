namespace FCT.Console.Config.AzureStorage
{
    using System;

    public class BlobInfo
    {
        public BlobInfo(string name, DateTime? lastModified)
        {
            Name = RemoveExtension(name);
            LastModified = lastModified;
        }

        public string Name { get; }

        public DateTime? LastModified { get; }

        private string RemoveExtension(string fileName)
        {
            int indexOfSeparator = fileName.IndexOf(".", StringComparison.Ordinal);
            if (indexOfSeparator != -1)
            {
                return fileName.Substring(0, indexOfSeparator);
            }

            return fileName;
        }
    }
}