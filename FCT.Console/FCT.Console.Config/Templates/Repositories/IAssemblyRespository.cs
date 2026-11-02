namespace FCT.Console.Config.Templates.Repositories
{
    using System.Collections.Generic;

    public interface IAssemblyRepository
    {
        IEnumerable<string> GetFilenamesToUpload();

        byte[] GetTemplateDocumentToUpload(string fileName);
    }
}