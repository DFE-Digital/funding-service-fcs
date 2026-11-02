namespace ContractCreateDomain.IncrementContractVersionEndpoint.Tests.Handlers
{
    using System;
    using System.Collections.Generic;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Infrastructure;
    using ContractManagement.DataStore;
    using IncrementContractVersionEndpoint.Handlers;
    using IoC;
    using IncrementContractVersionEndpoint.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using SFA.FCT.ContractCreateDomain.BusinessLogic;
    using SFA.FCT.ContractManagementService.Common;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;
    using System.Linq;
    using IncrementContractVersionEndpoint.Repositories;
    using Optional;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class IncrementContractVersionHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void IncrementContractVersionHandler_ShouldSendDocumentGenerationCommand()
        {
            // arrange
            const string childContractNumber = "SFA-123";
            const string masterContractNumber = "MASTERCONTRACT1";
        
            var incrementServiceMock = new Mock<IContractVersionIncrementService>();
            incrementServiceMock.Setup(
                s =>
                    s.CreateAmendedContractVersionIfNotAlreadyCreated(It.IsAny<ContractIdentifier>(),
                        It.IsAny<AmendmentType>(), It.IsAny<bool>())).Returns(new ExtendedContractType
                        {
                            contractNumber = masterContractNumber,
                            contracts = new List<ExtendedContractType>
                            {
                                new ExtendedContractType { contractNumber = childContractNumber, contractVersionNumber = 1}
                            }
                        });

            var contractRequestTransformerMock = new Mock<IContractRequestTransformer>();
            contractRequestTransformerMock.Setup(
                t => t.TransformToCorpContract(It.IsAny<ExtendedContractType>())).Returns(new contract { contractNumber = childContractNumber });

            Mock<ICreatedContractRepository> createdContractRepositoryMock = new Mock<ICreatedContractRepository>();
            createdContractRepositoryMock
                .Setup(r => r.GetLatestCreatedDateForNonNotificationApprovedContract(It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(new Option<DateTime?>());

            var siblingApprovedContractServiceMock = new Mock<ISiblingApprovedContractService>();
            siblingApprovedContractServiceMock
                .Setup(m => m.GetSiblingApprovedContractsForDocumentGeneration(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(new List<ApprovedContractInfo>());

            TestableMessageHandlerContext messageHandlerContext = new TestableMessageHandlerContext();
            
            var handler = new IncrementContractVersionHandler(Mock.Of<ILogger>(),
                incrementServiceMock.Object, 
                contractRequestTransformerMock.Object, 
                Mock.Of<IContractStorage>(),
                siblingApprovedContractServiceMock.Object,
                Mock.Of<ILevyContractAllocationService>(),
                Mock.Of<ISessionConnectionFactory>(),
                createdContractRepositoryMock.Object,
                Mock.Of<IApprovedContractRepository>(),
                Mock.Of<ICrmContractRepository>());

                var message = new IncrementContractVersionCommand
                {
                    ContractNumber = childContractNumber,
                    VersionNumber = 1,
                    SubVersionNumber = 1,
                    AmendmentType = AmendmentType.Variation
                };

            // act
            handler.Handle(message, messageHandlerContext).Wait();

            // assert
            Assert.AreEqual(1, messageHandlerContext.SentMessages.Length, "Unexpected number of messages sent");
            Assert.AreEqual(1, messageHandlerContext.SentMessages.Count(m => m.Message is DocumentGenerationCommand), 
                "'DocumentGenerationCommand' message was not sent");

            DocumentGenerationCommand documentGenerationCommandMessage = (DocumentGenerationCommand) messageHandlerContext.SentMessages[0].Message;
            Assert.AreEqual(masterContractNumber, documentGenerationCommandMessage.MasterContractNumber, 
                "'DocumentGenerationCommand' message contains incorrect MasterContractNumber");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void IncrementContractVersionHandler_ShouldNotSendDocumentGenerationCommandIfContractHasAlreadyBeenCreated()
        {
            // arrange
            const string childContractNumber = "SFA-123";

            var incrementServiceMock = new Mock<IContractVersionIncrementService>();
            incrementServiceMock.Setup(
                s =>
                    s.CreateAmendedContractVersionIfNotAlreadyCreated(It.IsAny<ContractIdentifier>(),
                        It.IsAny<AmendmentType>(), It.IsAny<bool>())).Returns((ExtendedContractType)null);

            var contractRequestTransformerMock = new Mock<IContractRequestTransformer>();

            Mock<ICreatedContractRepository> createdContractRepositoryMock = new Mock<ICreatedContractRepository>();
            createdContractRepositoryMock
                .Setup(r => r.GetLatestCreatedDateForNonNotificationApprovedContract(It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(new Option<DateTime?>());

            TestableMessageHandlerContext messageHandlerContext = new TestableMessageHandlerContext();

            var handler = new IncrementContractVersionHandler(Mock.Of<ILogger>(),
                incrementServiceMock.Object,
                contractRequestTransformerMock.Object,
                Mock.Of<IContractStorage>(),
                Mock.Of<ISiblingApprovedContractService>(),
                Mock.Of<ILevyContractAllocationService>(),
                Mock.Of<ISessionConnectionFactory>(),
                createdContractRepositoryMock.Object,
                Mock.Of<IApprovedContractRepository>(),
                Mock.Of<ICrmContractRepository>());

            var message = new IncrementContractVersionCommand
            {
                ContractNumber = childContractNumber,
                VersionNumber = 1,
                SubVersionNumber = 1,
                AmendmentType = AmendmentType.Variation
            };

            // act
            handler.Handle(message, messageHandlerContext).Wait();

            // assert
            Assert.AreEqual(0, messageHandlerContext.SentMessages.Length, "Unexpected number of messages sent");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void IncrementContractVersionHandler_ShouldInvokeLevyContractAllocationServiceWhenShouldAddPayableNonLevyAllocationIsTrue()
        {
            Mock<IContractVersionIncrementService> contractVersionIncrementServiceMock = new Mock<IContractVersionIncrementService>();
            contractVersionIncrementServiceMock
                .Setup(m => m.CreateAmendedContractVersionIfNotAlreadyCreated(It.IsAny<ContractIdentifier>(),
                    It.IsAny<AmendmentType>(),
                    It.IsAny<bool>()))
                .Returns(new ExtendedContractType
                {
                    contracts = new List<ExtendedContractType> { new ExtendedContractType() }
                });

            Mock<IContractRequestTransformer> contractRequestTransformerMock = new Mock<IContractRequestTransformer>();
            contractRequestTransformerMock
                .Setup(m => m.TransformToCorpContract(It.IsAny<ExtendedContractType>()))
                .Returns(new contract());

            Mock<ILevyContractAllocationService> levyContractAllocationServiceMock = new Mock<ILevyContractAllocationService>();

            TestableMessageHandlerContext messageHandlerContext = new TestableMessageHandlerContext();

            Mock<ICreatedContractRepository> createdContractRepositoryMock = new Mock<ICreatedContractRepository>();
            createdContractRepositoryMock
                .Setup(r => r.GetLatestCreatedDateForNonNotificationApprovedContract(It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(new Option<DateTime?>());

            var siblingApprovedContractServiceMock = new Mock<ISiblingApprovedContractService>();
            siblingApprovedContractServiceMock
                .Setup(m => m.GetSiblingApprovedContractsForDocumentGeneration(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(new List<ApprovedContractInfo>());

            var handler = new IncrementContractVersionHandler(Mock.Of<ILogger>(),
                contractVersionIncrementServiceMock.Object,
                contractRequestTransformerMock.Object,
                Mock.Of<IContractStorage>(),
                siblingApprovedContractServiceMock.Object,
                levyContractAllocationServiceMock.Object,
                Mock.Of<ISessionConnectionFactory>(),
                createdContractRepositoryMock.Object,
                Mock.Of<IApprovedContractRepository>(),
                Mock.Of<ICrmContractRepository>());

            // act
            handler.Handle(new IncrementContractVersionCommand
            {
                ShouldAddPayableNonLevyAllocation = true
            }, messageHandlerContext).Wait();

            // assert
            levyContractAllocationServiceMock
                .Verify(m => m.AddPayableNonLevyContractAllocationIfNotPresent(It.IsAny<ExtendedContractType>(),
                        It.IsAny<ConnectionInfo>()), Times.Once,
                    "Failed to invoke the LevyContractAllocationService");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void IncrementContractVersionHandler_ShouldNotInvokeLevyContractAllocationServiceWhenShouldAddPayableNonLevyAllocationIsFalse()
        {
            Mock<IContractVersionIncrementService> contractVersionIncrementServiceMock = new Mock<IContractVersionIncrementService>();
            contractVersionIncrementServiceMock
                .Setup(m => m.CreateAmendedContractVersionIfNotAlreadyCreated(It.IsAny<ContractIdentifier>(),
                    It.IsAny<AmendmentType>(),
                    It.IsAny<bool>()))
                .Returns(new ExtendedContractType
                {
                    contracts = new List<ExtendedContractType> { new ExtendedContractType() }
                });

            Mock<IContractRequestTransformer> contractRequestTransformerMock = new Mock<IContractRequestTransformer>();
            contractRequestTransformerMock
                .Setup(m => m.TransformToCorpContract(It.IsAny<ExtendedContractType>()))
                .Returns(new contract());

            Mock<ILevyContractAllocationService> levyContractAllocationServiceMock = new Mock<ILevyContractAllocationService>();

            TestableMessageHandlerContext messageHandlerContext = new TestableMessageHandlerContext();

            Mock<ICreatedContractRepository> createdContractRepositoryMock = new Mock<ICreatedContractRepository>();
            createdContractRepositoryMock
                .Setup(r => r.GetLatestCreatedDateForNonNotificationApprovedContract(It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(new Option<DateTime?>());

            var siblingApprovedContractServiceMock = new Mock<ISiblingApprovedContractService>();
            siblingApprovedContractServiceMock
                .Setup(m => m.GetSiblingApprovedContractsForDocumentGeneration(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(new List<ApprovedContractInfo>());

            var handler = new IncrementContractVersionHandler(Mock.Of<ILogger>(),
                contractVersionIncrementServiceMock.Object,
                contractRequestTransformerMock.Object,
                Mock.Of<IContractStorage>(),
                siblingApprovedContractServiceMock.Object,
                levyContractAllocationServiceMock.Object,
                Mock.Of<ISessionConnectionFactory>(),
                createdContractRepositoryMock.Object,
                Mock.Of<IApprovedContractRepository>(),
                Mock.Of<ICrmContractRepository>());

            // act
            handler.Handle(new IncrementContractVersionCommand
            {
                ShouldAddPayableNonLevyAllocation = false
            }, messageHandlerContext).Wait();

            // assert
            levyContractAllocationServiceMock
                .Verify(m => m.AddPayableNonLevyContractAllocationIfNotPresent(It.IsAny<ExtendedContractType>(),
                        It.IsAny<ConnectionInfo>()), Times.Never, 
                    "Failed to invoke the LevyContractAllocationService");

        }

        [TestMethod, TestCategory("UnitTest")]
        public void IncrementContractVersionHandler_ShouldResolve()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<IncrementContractVersionHandler>())
                .Register(Component.For<IContractManagementDbContext>().ImplementedBy<ContractManagementDbContext>().LifestyleScoped().IsDefault());

            container.BeginScope();

            // act
            container.Resolve<IncrementContractVersionHandler>();
        }
    }
}