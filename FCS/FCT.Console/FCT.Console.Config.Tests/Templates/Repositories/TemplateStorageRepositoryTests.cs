namespace FCT.Console.Config.Tests.Repositories.Repositories
{
    using AzureStorage;
    using FCT.Console.Config.Templates.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using System.Configuration;

    [TestClass]
    public class TemplateStorageRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void TemplateStorageRepository_AddDocumentTemplate_ShouldAddFile()
        {
            // arrange
            const string templateName = "DocumentTemplate_add";
            RemoveDocumentTemplate(templateName);

            var templateStorageRepository = new TemplateStorageRepository();    

            // act
            templateStorageRepository.AddDocumentTemplate(templateName, new byte[100]);

            // assert
            Assert.IsTrue(DocumentTemplateExists(templateName), "Document template was not added to storage");

            RemoveDocumentTemplate(templateName);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void TemplateStorageRepository_RemoveDocumentTemplate_ShouldRemoveFile()
        {
            // arrange
            const string templateName = "DocumentTemplate_remove";
            AddDocumentTemplate(templateName, new byte[100]);

            var templateStorageRepository = new TemplateStorageRepository();

            // act
            templateStorageRepository.RemoveDocumentTemplate(templateName);

            // assert
            Assert.IsFalse(DocumentTemplateExists(templateName), "Document template was not removed from storage");
        }

        private static void RemoveDocumentTemplate(string filename)
        {
            var fileContainer = ConfigurationManager.AppSettings["DocumentGeneration.TemplateContainer"];

            var fctFile = new FctFile(fileContainer, filename);
            AzureStorageWrapper.DeleteBlockBlob(fctFile);
        }

        private static void AddDocumentTemplate(string filename, byte[] stream)
        {
            var fileContainer = ConfigurationManager.AppSettings["DocumentGeneration.TemplateContainer"];

            var fctFile = new FctFile(fileContainer, filename);
            AzureStorageWrapper.PutBlockBlob(fctFile, stream);
        }

        private static bool DocumentTemplateExists( string filename)
        {
            var fileContainer = ConfigurationManager.AppSettings["DocumentGeneration.TemplateContainer"];

            var fctFile = new FctFile(fileContainer, filename);
            return AzureStorageWrapper.DoesBlockBlobExist(fctFile);
        }
    }
}