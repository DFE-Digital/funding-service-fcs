namespace FCT.Console.Config.Tests.Templates
{
    using FCT.Console.Config.Templates;
    using FCT.Console.Config.Templates.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using System;
    using System.Collections.Generic;
    using SFA.FCT.DocumentsDomain.DataStore.Models;

    [TestClass]
    public class TemplatesUpdaterTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void TemplatesUpdater_Update_ShouldRemoveFile()
        {
            // arrange
            var uploadedDocumentTemplateRepositoryMock = new Mock<IUploadedDocumentTemplateRepository>();
            uploadedDocumentTemplateRepositoryMock.Setup(udtr => udtr.GetUploadedDocumentTemplates())
                .Returns(new List<UploadedDocumentTemplate> { 
                    new UploadedDocumentTemplate("TemplateToBeRemoved_1",new byte[16], DateTime.Now),
                    new UploadedDocumentTemplate("TemplateToBeRemoved_2",new byte[16], DateTime.Now)
                });

            var templateStorageRepositoryMock = new Mock<ITemplateStorageRepository>();
            var assemblyRepositoryMock = new Mock<IAssemblyRepository>();

            var templatesUpdater = new TemplatesUpdater(uploadedDocumentTemplateRepositoryMock.Object,
                templateStorageRepositoryMock.Object,
                assemblyRepositoryMock.Object);

            // act
            templatesUpdater.Update();

            // assert
            templateStorageRepositoryMock.Verify(r => 
                r.RemoveDocumentTemplate(It.IsAny<string>()), Times.Exactly(2), 
                "RemoveDocumentTemplate was not called");

            uploadedDocumentTemplateRepositoryMock.Verify(r =>
                r.RemoveUploadedDocumentTemplate(It.IsAny<string>()), Times.Exactly(2),
                "RemoveUploadedDocumentTemplate was not called");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TemplatesUpdater_Update_ShouldAddFile()
        {
            // arrange
            const string templateName = "TemplateToBeAdded";

            var uploadedDocumentTemplateRepositoryMock = new Mock<IUploadedDocumentTemplateRepository>();
            uploadedDocumentTemplateRepositoryMock.Setup(udtr => udtr.GetUploadedDocumentTemplates())
                .Returns(new List<UploadedDocumentTemplate> {
                    new UploadedDocumentTemplate("TemplateToBeAdded",new byte[16], DateTime.Now)
                });

            var templateStorageRepositoryMock = new Mock<ITemplateStorageRepository>();
            var assemblyRepositoryMock = new Mock<IAssemblyRepository>();
            assemblyRepositoryMock.Setup(ar => ar.GetFilenamesToUpload())
                .Returns(new List<string> {templateName});

            var templatesUpdater = new TemplatesUpdater(uploadedDocumentTemplateRepositoryMock.Object,
                templateStorageRepositoryMock.Object,
                assemblyRepositoryMock.Object);

            // act
            templatesUpdater.Update();

            // assert
            templateStorageRepositoryMock.Verify(r =>
                r.AddDocumentTemplate(It.IsAny<string>(), It.IsAny<byte[]>()), Times.Once, 
                "AddDocumentTemplate was not called");

            uploadedDocumentTemplateRepositoryMock.Verify(r =>
                r.UpsertUploadedDocumentTemplate(It.IsAny<string>(), It.IsAny<byte[]>()), Times.Once, 
                "UpsertUploadedDocumentTemplate was not called");

            templateStorageRepositoryMock.Verify(r =>
                r.RemoveDocumentTemplate( It.IsAny<string>()), Times.Never,
                "RemoveUploadedDocumentTemplate was not called");

            uploadedDocumentTemplateRepositoryMock.Verify(r =>
                r.RemoveUploadedDocumentTemplate(It.IsAny<string>()), Times.Never,
                "RemoveUploadedDocumentTemplate was not called");

        }
    }
}