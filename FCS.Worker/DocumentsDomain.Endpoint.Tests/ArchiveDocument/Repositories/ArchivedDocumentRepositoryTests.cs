namespace DocumentsDomain.Endpoint.Tests.ArchiveDocument.Repositories
{
    using System;
    using System.Linq;
    using Endpoint.ArchiveDocument.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.DocumentsDomain.DataStore;
    using SFA.FCT.DocumentsDomain.DataStore.Models;
    using System.Threading.Tasks;
    using Moq;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class ArchivedDocumentRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public async Task ArchivedDocumentRepository_ShouldAdd()
        {
            // arrange
            Guid assertGuid = new Guid("6400A2B1-1E74-436E-B56F-AD1522306073");

            using (var context = new DocumentsDomainDbContext())
            {
                var archivedDocumentsToRemove = context.ArchivedDocuments.Where(ad => ad.Key == assertGuid).ToList();

                archivedDocumentsToRemove.ForEach(ad => context.ArchivedDocuments.Remove(ad));

                context.SaveChanges();
            }

            using (var context = new DocumentsDomainDbContext())
            {
                ArchivedDocumentRepository repository = new ArchivedDocumentRepository(Mock.Of<ILogger>());

                var archivedDocument = new ArchivedDocument(key: assertGuid,
                    fileName: "Filename-Repository",
                    eventType: EventType.Approval,
                    folderOrigin: "FolderOrigin-Repository");

                // act
                await repository.Add(archivedDocument, new ConnectionInfo(null, context.Database.Connection));
            }

            // assert
            using (var context = new DocumentsDomainDbContext())
            {
                var assertArchivedDocuments = context.ArchivedDocuments.Where(ad => ad.Key == assertGuid).ToList();
                Assert.AreEqual(assertArchivedDocuments.Count, 1, "ArchivedDocument record was not added");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ArchivedDocumentRepository_ShouldNotThrowAnExceptionIfTheKeyIsPresent()
        {
            // arrange
            Guid assertGuid = new Guid("6400A2B1-1E74-436E-B56F-AD1522306073");

            using (var context = new DocumentsDomainDbContext())
            {
                var archivedDocumentsToRemove = context.ArchivedDocuments.Where(ad => ad.Key == assertGuid).ToList();

                archivedDocumentsToRemove.ForEach(ad => context.ArchivedDocuments.Remove(ad));

                context.SaveChanges();
            }

            using (var context = new DocumentsDomainDbContext())
            {
                ArchivedDocumentRepository repository = new ArchivedDocumentRepository(Mock.Of<ILogger>());

                var archivedDocument = new ArchivedDocument(key: assertGuid,
                    fileName: "Filename-Repository",
                    eventType: EventType.Approval,
                    folderOrigin: "FolderOrigin-Repository");

                repository.Add(archivedDocument, new ConnectionInfo(null, context.Database.Connection)).Wait();
            }

            bool isExceptionThrown = false;
            using (var context = new DocumentsDomainDbContext())
            {
                ArchivedDocumentRepository repository = new ArchivedDocumentRepository(Mock.Of<ILogger>());

                var archivedDocument = new ArchivedDocument(key: assertGuid,
                    fileName: "Filename-Repository",
                    eventType: EventType.Approval,
                    folderOrigin: "FolderOrigin-Repository");
                try
                {
                    // act
                    repository.Add(archivedDocument, new ConnectionInfo(null, context.Database.Connection)).Wait();
                }
                catch (Exception)
                {
                    isExceptionThrown = true;
                }
               
                // assert
                Assert.IsFalse(isExceptionThrown, "An exception has been thrown");
            }
        }
    }
}