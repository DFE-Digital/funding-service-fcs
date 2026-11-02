namespace FCT.Console.Config.Tests.Repositories.Repositories
{
    using System.Linq;
    using FCT.Console.Config.Templates.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.DocumentsDomain.DataStore;
    using System;
    using SFA.FCT.DocumentsDomain.DataStore.Models;
    using System.Text;

    [TestClass]
    public class UploadedDocumentTemplateRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void UploadedDocumentTemplateRepository_GetUploadedDocumentTemplates_ShouldReturnRows()
        {
            // arrange
            const string templateNamePrefix = "DocumentTemplate_a_";
            var arrangeTemplateNames = Enumerable.Range(1, 2).Select(suffix => templateNamePrefix + suffix).ToList();

            arrangeTemplateNames.ForEach(RemoveUploadedDocumentTemplate);
            arrangeTemplateNames.ForEach(tn => AddUploadedDocumentTemplate(tn, new byte[16]));

            var uploadedDocumentTemplateRepository = new UploadedDocumentTemplateRepository();

            // act
            var assertUploadedDocumentTemplates = 
                uploadedDocumentTemplateRepository.GetUploadedDocumentTemplates();

            // assert
            Assert.IsTrue(assertUploadedDocumentTemplates.Count >= 2, "Incorrect number or Document templates returned");

            var assertUploadedTemplateNames = assertUploadedDocumentTemplates.Select(adt => adt.TemplateName).ToList();

            arrangeTemplateNames.ForEach(arrangeTemplateName => 
                Assert.IsTrue(assertUploadedTemplateNames.Contains(arrangeTemplateName), $"'{arrangeTemplateName}' template name not returned"));

            arrangeTemplateNames.ForEach(RemoveUploadedDocumentTemplate);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void UploadedDocumentTemplateRepository_UpsertUploadedDocumentTemplate_ShouldAddRow()
        {
            // arrange
            const string templateName = "DocumentTemplate_b";
            RemoveUploadedDocumentTemplate(templateName);

            var uploadedDocumentTemplateRepository = new UploadedDocumentTemplateRepository();
            
            // act
            uploadedDocumentTemplateRepository.UpsertUploadedDocumentTemplate(templateName, new byte[16]);

            using (var context = new DocumentsDomainDbContext())
            {
                 // assert
                 var assertUploadedDocumentTemplate = context.UploadedDocumentTemplates.SingleOrDefault(udt => udt.TemplateName == templateName);

                 Assert.IsNotNull(assertUploadedDocumentTemplate, "UploadedDocumentTemplate was not added");
            }

            RemoveUploadedDocumentTemplate(templateName);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void UploadedDocumentTemplateRepository_UpsertUploadedDocumentTemplate_ShouldUpdateRow()
        {
            // arrange
            const string templateName = "DocumentTemplate_c";
            var checksumBefore = Encoding.ASCII.GetBytes("before");
            var checksumAfter = Encoding.ASCII.GetBytes("after");

            RemoveUploadedDocumentTemplate(templateName);
            AddUploadedDocumentTemplate(templateName, checksumBefore);

            var uploadedDocumentTemplateRepository = new UploadedDocumentTemplateRepository();

            // act
            uploadedDocumentTemplateRepository.UpsertUploadedDocumentTemplate(templateName, checksumAfter);

            using (var context = new DocumentsDomainDbContext())
            {
                // assert
                var assertUploadedDocumentTemplate = context.UploadedDocumentTemplates.SingleOrDefault(udt => udt.TemplateName == templateName);
                Assert.IsTrue(checksumAfter.SequenceEqual(assertUploadedDocumentTemplate.Checksum), $"Document template {templateName} not updated");
            }
            
            RemoveUploadedDocumentTemplate(templateName);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void UploadedDocumentTemplateRepository_RemoveUploadedDocumentTemplate_ShouldRemoveRow()
        {
            // arrange
            const string templateName = "DocumentTemplate_d";

            RemoveUploadedDocumentTemplate(templateName);
            AddUploadedDocumentTemplate(templateName, new byte[16]);

            var uploadedDocumentTemplateRepository = new UploadedDocumentTemplateRepository();

            // act
            uploadedDocumentTemplateRepository.RemoveUploadedDocumentTemplate(templateName);

            using (var context = new DocumentsDomainDbContext())
            {
                // assert
                var assertUploadedDocumentTemplates = context.UploadedDocumentTemplates.Where(udt => udt.TemplateName == templateName).ToList();
                Assert.AreEqual(0, assertUploadedDocumentTemplates.Count, $"Document template {templateName} was not moved");
            }

            RemoveUploadedDocumentTemplate(templateName);
        }

        private static void RemoveUploadedDocumentTemplate(string templateName)
        {
            using (var context = new DocumentsDomainDbContext())
            {
                context.UploadedDocumentTemplates
                    .Where(dt => dt.TemplateName == templateName).ToList()
                    .ForEach(dt => context.UploadedDocumentTemplates.Remove(dt));

                context.SaveChanges();
            }
        }

        private static void AddUploadedDocumentTemplate(string templateName, byte[] checksum)
        {
            using (var context = new DocumentsDomainDbContext())
            {
                context.UploadedDocumentTemplates.Add(
                    new UploadedDocumentTemplate(templateName, checksum, DateTime.Now));

                context.SaveChanges();
            }
        }
    }
}