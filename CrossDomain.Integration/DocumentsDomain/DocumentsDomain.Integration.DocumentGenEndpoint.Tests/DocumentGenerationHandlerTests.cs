namespace SFA.FCT.DocumentsDomain.Integration.DocumentGenEndpoint.Tests
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using CrossDomain.Integration.Entities.Data;
    using Framework.Logging;
    using Framework.Logging.NullObjects;
    using SFA.FCT.CrossDomain.Integration.Messages.Messages;
    using SFA.FCT.DocumentsDomain.DocumentGeneration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.DocumentsDomain.Common.Commands;
    using SFA.FCT.DocumentsDomain.Integration.DocumentGenerationEndpoint;
    using SFA.FCT.Framework.Logging.Interfaces;
    using DataStore.Repositories;
    using DocumentGeneration.Infrastructure;
    using NHibernate;
    using NServiceBus.Persistence;
    using NServiceBus.Testing;

    [TestClass]
    public class DocumentGenerationHandlerTests
    {
        private Mock<ILogger> _logger;
        private Mock<IDocumentGenerator> _documentGenerator;

        [TestInitialize]
        public void Initialise()
        {
            _logger = new Mock<ILogger>();
            _documentGenerator = new Mock<IDocumentGenerator>();
        }
   
        [TestMethod, TestCategory("UnitTest")]
        public void Test_Handle_EnsureHandlerRejectsDocumentGenerationCommandContainingMasterContract()
        {
            // Arrange
            Mock<IProcessedMessageRepository> processedMessageRepositoryMock = new Mock<IProcessedMessageRepository>();
            processedMessageRepositoryMock.Setup(r => r.Add(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(true);

            DocumentGenerationHandler handler = new DocumentGenerationHandler(
                _documentGenerator.Object,
                _logger.Object,
                processedMessageRepositoryMock.Object,
                Mock.Of<ISessionConnectionFactory>());

            DocumentGenerationCommand command = new DocumentGenerationCommand
            {
                CorporateContract = new Contract()
                {
                    hierarchyType = hierarchyType.MASTERCONTRACT
                }
            };

            _documentGenerator.Setup(c => c.GenerateDocument(It.IsAny<string>(), It.IsAny<Contract>(), It.IsAny<string>())).Verifiable();

            bool expectedExceptionThrown = false;

            // Act
            try
            {
                handler.Handle(command, new TestableMessageHandlerContext()).Wait();
            }
            catch (AggregateException ex) when(ex.InnerException is ArgumentException)
            {
                expectedExceptionThrown = true;
            }

            // Assert
            Assert.IsTrue(expectedExceptionThrown, "The expected ArgumentException was not thrown.");
            _documentGenerator.Verify(c => c.GenerateDocument(It.IsAny<string>(), It.IsAny<Contract>(), It.IsAny<string>()), Times.Never);

        }

        [TestMethod, TestCategory("UnitTest")]
        public void Test_Handle_EnsureHandlerAcceptsDocumentGenerationCommandContainingContract()
        {
            // Arrange
            Mock<IProcessedMessageRepository> processedMessageRepositoryMock = new Mock<IProcessedMessageRepository>();
            processedMessageRepositoryMock.Setup(r => r.Add(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(true);

            DocumentGenerationHandler handler = new DocumentGenerationHandler(
                _documentGenerator.Object,
                _logger.Object,
                processedMessageRepositoryMock.Object,
                Mock.Of<ISessionConnectionFactory>());

            DocumentGenerationCommand command = new DocumentGenerationCommand
            {
                CorporateContract = new Contract()
                {
                    hierarchyType = hierarchyType.CONTRACT
                }
            };

            //var documentSaveCommand = new DocumentSaveCommand();
            var mockHeader = new Dictionary<string, string> {{"NServiceBus.RelatedTo", "Test"}};


            _documentGenerator.Setup(c => c.GenerateDocument(It.IsAny<string>(), It.IsAny<Contract>(), It.IsAny<string>())).Verifiable();

            // Act
            handler.Handle(command, new TestableMessageHandlerContext()).Wait();

            // Assert
            _documentGenerator.Verify(c => c.GenerateDocument(It.IsAny<string>(), It.IsAny<Contract>(), It.IsAny<string>()), Times.Once);

        }

        [TestMethod, TestCategory("UnitTest")]
        public void DocumentGenerationHandler_ShouldReplyWithContractNumber()
        {
            // arrange
            const string contractNumber = "ABC-123";

            Mock<IDocumentGenerator> docGenMock = new Mock<IDocumentGenerator>();
            docGenMock.Setup(m => m.GenerateDocument(It.IsAny<string>(), It.IsAny<Contract>(), It.IsAny<string>()))
                      .Returns((DocumentSaveCommand)null);

            Mock<IProcessedMessageRepository> processedMessageRepositoryMock = new Mock<IProcessedMessageRepository>();
            processedMessageRepositoryMock.Setup(r => r.Add(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(true);

            DocumentGenerationHandler handler = new DocumentGenerationHandler(docGenMock.Object, new LoggerNullObject(), processedMessageRepositoryMock.Object, Mock.Of<ISessionConnectionFactory>());

            DocumentGenerationCommand command = new DocumentGenerationCommand
            {
                CorrelationId = string.Empty,
                CorporateContract = new Contract
                {
                    hierarchyType = hierarchyType.CONTRACT,
                    contractAllocations = new List<contractAllocationsContractAllocation>(),
                    contractNumber = contractNumber
                }
            };

            var context = new TestableMessageHandlerContext();

            // act
            handler.Handle(command, context).Wait();

            // assert
            // replay as requested internally calls reply - verify this happens with the correct contract number
            
            Assert.AreEqual(1, context.RepliedMessages.Select(m => m.Message).OfType<DocumentGenerationComplete>().Count(dgc => dgc.ContractNumber == contractNumber));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DocumentGenerationHandler_ShouldResolve()
        {
            IWindsorContainer container = new WindsorContainer().Install(new SFA.FCT.DocumentsDomain.Integration.DocumentGenerationEndpoint.IoC.WindsorInstallerForDocumentGenerator(new LoggerFactory()));

            container.Register(Component.For<DocumentGenerationHandler>());
            
            container.BeginScope();

            // Act
            var handler = container.Resolve<DocumentGenerationHandler>();

            // Assert
            Assert.IsNotNull(handler);
        }
    }
}
