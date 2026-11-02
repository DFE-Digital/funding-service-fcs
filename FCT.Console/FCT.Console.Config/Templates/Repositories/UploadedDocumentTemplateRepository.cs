namespace FCT.Console.Config.Templates.Repositories
{
    using Dapper;
    using SFA.FCT.DocumentsDomain.DataStore.Models;
    using System.Collections.Generic;
    using System.Linq;
    using SFA.FCT.DocumentsDomain.DataStore;

    public class UploadedDocumentTemplateRepository : IUploadedDocumentTemplateRepository
    {
        public IReadOnlyCollection<UploadedDocumentTemplate> GetUploadedDocumentTemplates()
        {
            const string sql = @"SELECT TemplateName
                                       ,[Checksum]
                                       ,DateUpLoaded
                                       ,CreatedDate
                                 FROM DocumentsDomain.UploadedDocumentTemplate";

            using (var context = new DocumentsDomainDbContext())
            {
                return context.Database.Connection.Query<UploadedDocumentTemplate>(sql).ToList();
            }
        }

        public void UpsertUploadedDocumentTemplate(string templateName, byte[] checksum)
        {
            using (var context = new DocumentsDomainDbContext())
            {
                context.Database.Connection.Execute("sp_DocumentsDomain_UpsertDocumentTemplate @templateName, @checksum", new { templateName, checksum });
            }
        }

        public void RemoveUploadedDocumentTemplate(string templateName)
        {
            using (var context = new DocumentsDomainDbContext())
            {
                context.UploadedDocumentTemplates.Where(udt => udt.TemplateName == templateName).ToList().ForEach(r => context.UploadedDocumentTemplates.Remove(r));
                context.SaveChanges();

            }
        }
    }
}