namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System;
    using System.Linq;
    using System.Reflection;
    using DocumentsDomain.DataStore;
    using DocumentsDomain.DataStore.Models;

    public static class UploadedDocumentTemplateRepository
    {
        public static void Insert(string templateName, DateTime dateUploaded)
        {
            using (var context = new DocumentsDomainDbContext())
            {
                context.UploadedDocumentTemplates.Add(new UploadedDocumentTemplate(templateName, new byte[0],
                    dateUploaded));

                context.SaveChanges();
            }
        }

        public static void UpSert(string templateName, DateTime dateUploaded)
        {
            using (var context = new DocumentsDomainDbContext())
            {
                var row = context.UploadedDocumentTemplates.SingleOrDefault(t => t.TemplateName == templateName);

                if (row == null)
                {
                    Insert(templateName, dateUploaded);
                }
                else
                {
                    PropertyInfo property = typeof(UploadedDocumentTemplate).GetProperty("DateUpLoaded");
                    property.DeclaringType.GetProperty("DateUpLoaded");
                    property.GetSetMethod(true).Invoke(row, new object[] { dateUploaded });

                    context.SaveChanges();
                }
            }
        }
    }
}
