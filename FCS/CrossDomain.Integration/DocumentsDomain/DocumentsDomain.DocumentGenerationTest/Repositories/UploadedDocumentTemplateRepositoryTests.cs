namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Tests.Repositories
{
    using System;
    using System.Linq;
    using DataStore;
    using DataStore.Models;
    using DocumentGeneration.Repositories;
    using Extensions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class UploadedDocumentTemplateRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void UploadedDocumentTemplateRepository_GetDateUploaded_ShouldReturnTheCorrectDate()
        {
            // arrange
            const string templateName = "TestTemplateName";
            DateTime date = DateTime.Now;
            DeleteTemplateFromTable(templateName);
            InsertUploadedDocumentTemplate(templateName, date);

            using (var context = new DocumentsDomainDbContext())
            {
                UploadedDocumentTemplateRepository repository = new UploadedDocumentTemplateRepository(context);

                // act
                var dateUploaded = repository.GetDateUploaded(templateName);
                // assert
                Assert.AreEqual(date.ToDateTimeWithoutMilliseconds(), dateUploaded.ToDateTimeWithoutMilliseconds());
            }
        }

        private void InsertUploadedDocumentTemplate(string templateName, DateTime date)
        {
            using (var context = new DocumentsDomainDbContext())
            {
                context.UploadedDocumentTemplates.Add(new UploadedDocumentTemplate(templateName, new byte[0], date));
                context.SaveChanges();
            }
        }

        private void DeleteTemplateFromTable(string templateName)
        {
            using (var context = new DocumentsDomainDbContext())
            {
                context.UploadedDocumentTemplates.Where(d => d.TemplateName == templateName)
                    .ToList()
                    .ForEach(d => context.UploadedDocumentTemplates.Remove(d));

                context.SaveChanges();
            }
        }
    }
}
