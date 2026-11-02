namespace FCT.Console.Config.Templates.Repositories
{
    public interface ITemplateStorageRepository
    {
        void AddDocumentTemplate(string filename, byte[] stream);

        void RemoveDocumentTemplate(string filename);
    }
}