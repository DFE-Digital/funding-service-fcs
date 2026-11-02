namespace DocumentsDomain.Endpoint.Tests.ArchiveDocument
{
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Endpoint.ArchiveDocument;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.Framework.Logging;
    using System;
    using System.Linq;
    using Endpoint.ArchiveDocument.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.DocumentsDomain.DataStore;
    using Infrastructure;
    using Moq;
    using SFA.FCT.Framework.Logging.Interfaces;
    using NServiceBus.Testing;
    using SFA.FCT.DocumentsDomain.Common.Commands;
    using ContractAmendmentType = SFA.FCT.DocumentsDomain.Common.ContractAmendmentType;
    using EventType = SFA.FCT.DocumentsDomain.Common.Commands.EventType;
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Common.Storage;

    [TestClass]
    public class ArchiveDocumentHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void RecordArchiveHandler_ShouldResolve()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<ArchiveDocumentHandler>());
            container.BeginScope();

            // act
            container.Resolve<ArchiveDocumentHandler>();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void RecordArchiveHandler_ShouldAddArchivedDocumentRecordAndSendMessage()
        {
            // arrange
            Guid assertGuid = new Guid("0801FFAC-8230-42F5-BCB0-6CC944A4EF75");
            using (var context = new DocumentsDomainDbContext())
            {
                var archivedDocumentsToRemove = context.ArchivedDocuments.Where(ad => ad.Key == assertGuid).ToList();

                archivedDocumentsToRemove.ForEach(ad => context.ArchivedDocuments.Remove(ad));

                context.SaveChanges();
            }

            using (var context = new DocumentsDomainDbContext())
            {
                var archivedDocumentRepository = new ArchivedDocumentRepository(Mock.Of<ILogger>());

                Mock<ISessionConnectionFactory> sessionConnectionFactoryMock = new Mock<ISessionConnectionFactory>();
                sessionConnectionFactoryMock.Setup(s => s.GetConnection(It.IsAny<IMessageHandlerContext>()))
                    .Returns(new ConnectionInfo(null, context.Database.Connection));

                var recordArchiveHandler = new ArchiveDocumentHandler(Mock.Of<ILogger>(), archivedDocumentRepository, sessionConnectionFactoryMock.Object, Mock.Of<IOffice365Adapter>());

                var message = new ArchiveDocumentCommand
                {
                    Key = assertGuid,
                    FileName = "FileName-Handler",
                    AmendmentType = ContractAmendmentType.Variation,
                    EventType = EventType.Withdrawal,
                    FolderOrigin = "FolderOrigin-Handler"
                };

                var messageHandlerContext = new TestableMessageHandlerContext();

                // act
                recordArchiveHandler.Handle(message, messageHandlerContext).Wait();

                // assert
                Assert.AreEqual(1, messageHandlerContext.SentMessages.Length, "A message was not sent");
                Assert.IsTrue(messageHandlerContext.SentMessages[0].Message is DocumentDeleteCommand, "The sent message is the wrong type");
            }

            using (var context = new DocumentsDomainDbContext())
            {
                var assertArchivedDocuments = context.ArchivedDocuments.Where(ad => ad.Key == assertGuid).ToList();
                Assert.AreEqual(assertArchivedDocuments.Count, 1, "ArchivedDocument record was not added");
            }
        }
    }
}