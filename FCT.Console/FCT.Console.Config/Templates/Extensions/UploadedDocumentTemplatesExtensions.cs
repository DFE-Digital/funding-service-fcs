namespace FCT.Console.Config.Templates.Extensions
{
    using SFA.FCT.DocumentsDomain.DataStore.Models;
    using System.Collections.Generic;
    using System.Linq;

    public static class UploadedDocumentTemplatesExtensions
    {
        public static byte[] GetExistingTemplateDocumentCheckSum(this 
            IEnumerable<UploadedDocumentTemplate> uploadedDocumentTemplates, string templateFilename)
        {
            return uploadedDocumentTemplates.SingleOrDefault(udt => udt.TemplateName == templateFilename)
                ?.Checksum;
        }

        public static IEnumerable<string> GetFilenamesToRemove(this IEnumerable<UploadedDocumentTemplate> uploadedDocumentTemplates,
            IReadOnlyCollection<string> templateFileNamesToUpload)
        {
            return uploadedDocumentTemplates.Select(udt => udt.TemplateName)
                .ToList()
                .Where(uploadedDocumentTemplateFilename => !templateFileNamesToUpload.Contains(uploadedDocumentTemplateFilename))
                .ToList();
        }
    }
}