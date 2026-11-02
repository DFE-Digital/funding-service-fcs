namespace FCT.Console.Config.Templates.Repositories
{
    using System.Configuration;
    using AzureStorage;

    public class TemplateStorageRepository : ITemplateStorageRepository
    {
        private static string FileContainer => ConfigurationManager.AppSettings["DocumentGeneration.TemplateContainer"];

        public void AddDocumentTemplate(string filename, byte[] stream)
        {
            var fctFile = new FctFile(FileContainer, filename);

            AzureStorageWrapper.PutBlockBlob(fctFile, stream);
        }

        public void RemoveDocumentTemplate(string filename)
        {
            var fctFile = new FctFile(FileContainer, filename);

            AzureStorageWrapper.DeleteBlockBlob(fctFile);
        }
    }
}