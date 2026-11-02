namespace FCT.Console.Config.Templates.Repositories
{
    using SFA.FCT.DocumentsDomain.DataStore.Models;
    using System.Collections.Generic;

    public interface IUploadedDocumentTemplateRepository
    {
        IReadOnlyCollection<UploadedDocumentTemplate> GetUploadedDocumentTemplates();

        void UpsertUploadedDocumentTemplate(string templateName, byte[] checksum);

        void RemoveUploadedDocumentTemplate(string templateName);
    }
}