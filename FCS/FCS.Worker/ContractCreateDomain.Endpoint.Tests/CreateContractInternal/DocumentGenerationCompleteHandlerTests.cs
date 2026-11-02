namespace ContractCreateDomain.Endpoint.Tests.CreateContractInternal
{
    using System.Collections.Generic;
    using System.Linq;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Endpoint.CreateContractInternal;
    using Endpoint.Infrastructure;
    using Endpoint.Infrastructure.DTOs;
    using Endpoint.Infrastructure.Extensions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.Messages.Messages;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class DocumentGenerationCompleteHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void DocumentGenerationCompleteHandler_ShouldResolve()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstallerForSagas(new LoggerFactory()))
                .Register(Component.For<DocumentGenerationCompleteHandler>());

            container.BeginScope();

            // act
            container.Resolve<DocumentGenerationCompleteHandler>();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DocumentGenerationCompleteHandler_WhenSagaIntentIsNew_ShouldSendCreateContractCommand()
        {
            // arrange
            Mock<ISagaDataStorage> sagaDataStorageMock = new Mock<ISagaDataStorage>();
            sagaDataStorageMock
                .Setup(m => m.GetSagaData<SagaStorageValue>(It.IsAny<string>()))
                .Returns(new SagaStorageValue(new CreateContractSagaData
                {
                    ExtendedContractType = new ExtendedContractType
                    {
                        contracts = new List<ExtendedContractType>
                        {
                            new ExtendedContractType()
                        }
                    }.ConvertObjectToByteArray(),
                    ContractRequestContract = new contractRequestType().ConvertObjectToByteArray()

                }, Intent.New));

            DocumentGenerationCompleteHandler handler = new DocumentGenerationCompleteHandler(
                sagaDataStorageMock.Object,
                Mock.Of<ILogger>(),
                Mock.Of<IFundingTypeFundingPeriodQueryRepository>(),
                Mock.Of<IFundingTypePeriodService>(),
                Mock.Of<ISessionConnectionFactory>());

            DocumentGenerationComplete command = new DocumentGenerationComplete
            {
                ContractNumber = "MAIN-1234"
            };

            TestableMessageHandlerContext context = new TestableMessageHandlerContext();

            // act
            handler.Handle(command, context).Wait();

            // assert
            Assert.AreEqual(1, context.SentMessages.Length);
            Assert.AreEqual(1, context.SentMessages.Select(sm => sm.Message).OfType<CreateContractCommand>().Count());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DocumentGenerationCompleteHandler_WhenSagaIntentIsRevisedNew_ShouldSendCreateNewAmendedContractCommand()
        {
            // arrange
            Mock<ISagaDataStorage> sagaDataStorageMock = new Mock<ISagaDataStorage>();
            sagaDataStorageMock
                .Setup(m => m.GetSagaData<SagaStorageValue>(It.IsAny<string>()))
                .Returns(new SagaStorageValue(new CreateContractSagaData
                {
                    ExtendedContractType = new ExtendedContractType
                    {
                        contracts = new List<ExtendedContractType>
                        {
                            new ExtendedContractType()
                        }
                    }.ConvertObjectToByteArray(),
                    ContractRequestContract = new contractRequestType().ConvertObjectToByteArray()

                }, Intent.RevisedNew));

            DocumentGenerationCompleteHandler handler = new DocumentGenerationCompleteHandler(
                sagaDataStorageMock.Object,
                Mock.Of<ILogger>(),
                Mock.Of<IFundingTypeFundingPeriodQueryRepository>(),
                Mock.Of<IFundingTypePeriodService>(),
                Mock.Of<ISessionConnectionFactory>());

            DocumentGenerationComplete command = new DocumentGenerationComplete
            {
                ContractNumber = "MAIN-1234"
            };

            TestableMessageHandlerContext context = new TestableMessageHandlerContext();

            // act
            handler.Handle(command, context).Wait();

            // assert
            Assert.AreEqual(1, context.SentMessages.Length);
            Assert.AreEqual(1, context.SentMessages.Select(sm => sm.Message).OfType<CreateNewAmendedContractCommand>().Count());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DocumentGenerationCompleteHandler_WhenSagaIntentIsNewAmendment_ShouldSendCreateNewAmendedContractCommand()
        {
            // arrange
            Mock<ISagaDataStorage> sagaDataStorageMock = new Mock<ISagaDataStorage>();
            sagaDataStorageMock
                .Setup(m => m.GetSagaData<SagaStorageValue>(It.IsAny<string>()))
                .Returns(new SagaStorageValue(new CreateContractSagaData
                {
                    ExtendedContractType = new ExtendedContractType
                    {
                        contracts = new List<ExtendedContractType>
                        {
                            new ExtendedContractType()
                        }
                    }.ConvertObjectToByteArray(),
                    ContractRequestContract = new contractRequestType().ConvertObjectToByteArray()

                }, Intent.NewAmendment));

            DocumentGenerationCompleteHandler handler = new DocumentGenerationCompleteHandler(
                sagaDataStorageMock.Object,
                Mock.Of<ILogger>(),
                Mock.Of<IFundingTypeFundingPeriodQueryRepository>(),
                Mock.Of<IFundingTypePeriodService>(),
                Mock.Of<ISessionConnectionFactory>());

            DocumentGenerationComplete command = new DocumentGenerationComplete
            {
                ContractNumber = "MAIN-1234"
            };

            TestableMessageHandlerContext context = new TestableMessageHandlerContext();

            // act
            handler.Handle(command, context).Wait();

            // assert
            Assert.AreEqual(1, context.SentMessages.Length);
            Assert.AreEqual(1, context.SentMessages.Select(sm => sm.Message).OfType<CreateNewAmendedContractCommand>().Count());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DocumentGenerationCompleteHandler_WhenSagaIntentIsAmendment_ShouldSendAmendContractCommand()
        {
            // arrange
            Mock<ISagaDataStorage> sagaDataStorageMock = new Mock<ISagaDataStorage>();
            sagaDataStorageMock
                .Setup(m => m.GetSagaData<SagaStorageValue>(It.IsAny<string>()))
                .Returns(new SagaStorageValue(new ModifyContractSagaData
                {
                    ExtendedCorporateContract = new ExtendedContractType
                    {
                        contracts = new List<ExtendedContractType>
                        {
                            new ExtendedContractType()
                        }
                    }.ConvertObjectToByteArray(),
                    ContractsToProcessHashSet = new HashSet<ContractCorrelationData>
                    {
                        new ContractCorrelationData("MAIN-1234")
                    }.ConvertObjectToByteArray()
                }, Intent.Amendment));

            DocumentGenerationCompleteHandler handler = new DocumentGenerationCompleteHandler(
                sagaDataStorageMock.Object,
                Mock.Of<ILogger>(),
                Mock.Of<IFundingTypeFundingPeriodQueryRepository>(),
                Mock.Of<IFundingTypePeriodService>(),
                Mock.Of<ISessionConnectionFactory>());

            DocumentGenerationComplete command = new DocumentGenerationComplete
            {
                ContractNumber = "MAIN-1234"
            };

            TestableMessageHandlerContext context = new TestableMessageHandlerContext();

            // act
            handler.Handle(command, context).Wait();

            // assert
            Assert.AreEqual(1, context.SentMessages.Length);
            Assert.AreEqual(1, context.SentMessages.Select(sm => sm.Message).OfType<AmendContractCommand>().Count());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DocumentGenerationCompleteHandler_WhenSagaIntentIsUpdate_ShouldSendUpdateContractCommand()
        {
            // arrange
            Mock<ISagaDataStorage> sagaDataStorageMock = new Mock<ISagaDataStorage>();
            sagaDataStorageMock
                .Setup(m => m.GetSagaData<SagaStorageValue>(It.IsAny<string>()))
                .Returns(new SagaStorageValue(new ModifyContractSagaData
                {
                    ExtendedCorporateContract = new ExtendedContractType
                    {
                        contracts = new List<ExtendedContractType>
                        {
                            new ExtendedContractType()
                        }
                    }.ConvertObjectToByteArray(),
                    ContractsToProcessHashSet = new HashSet<ContractCorrelationData>
                    {
                        new ContractCorrelationData("MAIN-1234")
                    }.ConvertObjectToByteArray()
                }, Intent.Update));

            DocumentGenerationCompleteHandler handler = new DocumentGenerationCompleteHandler(
                sagaDataStorageMock.Object,
                Mock.Of<ILogger>(),
                Mock.Of<IFundingTypeFundingPeriodQueryRepository>(),
                Mock.Of<IFundingTypePeriodService>(),
                Mock.Of<ISessionConnectionFactory>());

            DocumentGenerationComplete command = new DocumentGenerationComplete
            {
                ContractNumber = "MAIN-1234"
            };

            TestableMessageHandlerContext context = new TestableMessageHandlerContext();

            // act
            handler.Handle(command, context).Wait();

            // assert
            Assert.AreEqual(1, context.SentMessages.Length);
            Assert.AreEqual(1, context.SentMessages.Select(sm => sm.Message).OfType<UpdateContractCommand>().Count());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void DocumentGenerationCompleteHandler_WhenSagaIntentIsUpdateAmendment_ShouldSendUpdateContractCommand()
        {
            // arrange
            Mock<ISagaDataStorage> sagaDataStorageMock = new Mock<ISagaDataStorage>();
            sagaDataStorageMock
                .Setup(m => m.GetSagaData<SagaStorageValue>(It.IsAny<string>()))
                .Returns(new SagaStorageValue(new ModifyContractSagaData
                {
                    ExtendedCorporateContract = new ExtendedContractType
                    {
                        contracts = new List<ExtendedContractType>
                        {
                            new ExtendedContractType()
                        }
                    }.ConvertObjectToByteArray(),
                    ContractsToProcessHashSet = new HashSet<ContractCorrelationData>
                    {
                        new ContractCorrelationData("MAIN-1234")
                    }.ConvertObjectToByteArray()
                }, Intent.UpdateAmendment));

            DocumentGenerationCompleteHandler handler = new DocumentGenerationCompleteHandler(
                sagaDataStorageMock.Object,
                Mock.Of<ILogger>(),
                Mock.Of<IFundingTypeFundingPeriodQueryRepository>(),
                Mock.Of<IFundingTypePeriodService>(),
                Mock.Of<ISessionConnectionFactory>());

            DocumentGenerationComplete command = new DocumentGenerationComplete
            {
                ContractNumber = "MAIN-1234"
            };

            TestableMessageHandlerContext context = new TestableMessageHandlerContext();

            // act
            handler.Handle(command, context).Wait();

            // assert
            Assert.AreEqual(1, context.SentMessages.Length);
            Assert.AreEqual(1, context.SentMessages.Select(sm => sm.Message).OfType<UpdateContractCommand>().Count());
        }
    }
}
