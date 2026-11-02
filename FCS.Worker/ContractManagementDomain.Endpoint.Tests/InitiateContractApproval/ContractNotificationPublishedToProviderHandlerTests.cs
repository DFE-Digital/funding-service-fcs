namespace ContractManagementDomain.Endpoint.Tests.InitiateContractApproval
{
    using System.Configuration;
    using System.Linq;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using ContractManagement.DataStore.Repositories;
    using Endpoint.InitiateContractApproval;
    using Endpoint.Services;
    using Infrastructure;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;
    using CorporateSchema = SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract;

    [TestClass]
    public class ContractNotificationPublishedToProviderHandlerTests
    {
        private Mock<IMonthEndHistoryRepository> _monthEndHistoryRepository;
        private Mock<IFundingTypeFundingPeriodService> _fundingTypeFundingPeriodServiceMock;
        private Mock<IXrmManager> _xrmManagerMock;
        private Mock<IContractsManager> _contractsManagerMock;
        private ContractNotificationPublishedToProviderHandler _handler;
        private TestableMessageHandlerContext _messageHandlerContext;

        [TestInitialize]
        public void TestInitialize()
        {
            _monthEndHistoryRepository = new Mock<IMonthEndHistoryRepository>();
            _fundingTypeFundingPeriodServiceMock = new Mock<IFundingTypeFundingPeriodService>();
            _xrmManagerMock = new Mock<IXrmManager>();
            _contractsManagerMock = new Mock<IContractsManager>();
            _messageHandlerContext = new TestableMessageHandlerContext();
            _handler = new ContractNotificationPublishedToProviderHandler(
                Mock.Of<ILogger>(),
                Mock.Of<ISessionConnectionFactory>(),
                _monthEndHistoryRepository.Object,
                _fundingTypeFundingPeriodServiceMock.Object,
                _xrmManagerMock.Object,
                _contractsManagerMock.Object);

            ConfigurationManager.AppSettings["ContractManagement.DeferMinutes"] = "10";
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractNotificationPublishedToProviderHandler_ShouldResolve()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<ContractNotificationPublishedToProviderHandler>().LifestyleScoped());

            container.BeginScope();

            // act
            container.Resolve<ContractNotificationPublishedToProviderHandler>();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractNotificationPublishedToProviderHandler_GetCorporateContractReturnsNotification_SendsMessageOnBus()
        {
            // arrange
            contract corpContract = ReturnPopulatedCorporateContract("11", "1", "Published To Provider", CorporateSchema.contractStatusTypeParentStatus.Draft.ToString(), 1);
            corpContract.contracts[0].amendmentType = "Notification";

            _contractsManagerMock
                .Setup(x => x.GetCorporateContractForSpecificVersion("1", "11", 1))
                .Returns(corpContract);

            ContractNotificationPublishedToProviderEvent testMessage = new ContractNotificationPublishedToProviderEvent
            {
                CorporateContract = corpContract
            };

            _fundingTypeFundingPeriodServiceMock
                .Setup(s => s.IsProcessDateAfterFundingTypeContractingActivityCloseDate(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(false);

            // act
            _handler.Handle(testMessage, _messageHandlerContext).Wait();

            // assert
            _xrmManagerMock.Verify(x => x.UpdateContractForNotificationApproval(corpContract.contracts.First()));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractNotificationPublishedToProviderHandler_ContractNotificationPublishedToProviderEventHandle_WhenContractVersionIsMoreThanOneAndAMonthEndIsInProgress_ShouldDeferMesssage()
        {
            // arrange
            _monthEndHistoryRepository
                .Setup(m => m.IsMonthEndInProgress(It.IsAny<ConnectionInfo>()))
                .Returns(true);
            contract corpContract = ReturnPopulatedCorporateContract("11", "1", "Published To Provider", CorporateSchema.contractStatusTypeParentStatus.Draft.ToString(), 2);
            corpContract.contracts[0].amendmentType = "Notification";

            _contractsManagerMock
                .Setup(x => x.GetCorporateContractForSpecificVersion("1", "11", 1))
                .Returns(corpContract);

            ContractNotificationPublishedToProviderEvent testMessage = new ContractNotificationPublishedToProviderEvent
            {
                CorporateContract = corpContract
            };

            _fundingTypeFundingPeriodServiceMock
                .Setup(s => s.IsProcessDateAfterFundingTypeContractingActivityCloseDate(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(false);

            // act
            _handler.Handle(testMessage, _messageHandlerContext).Wait();

            // assert
            _xrmManagerMock.Verify(x => x.UpdateContractForNotificationApproval(It.IsAny<contractType>()), Times.Never,
                "XrmManager method UpdateContractForNotificationApproval called unexpectedly");
            Assert.AreEqual(1, _messageHandlerContext.SentMessages.Select(sm => sm.Message).OfType<ContractNotificationPublishedToProviderEvent>().Count());
        }

        private static contract ReturnPopulatedCorporateContract(string masterContractNumber, string contractNumber, string contractStatus, string contractParentStatus, int version)
        {
            return new contract
            {
                contractNumber = masterContractNumber,
                contracts =
                {
                    new contract
                    {
                        contractNumber = contractNumber,
                        contractStatus = new contractStatusType
                        {
                            status =contractStatus,
                            parentStatus = contractParentStatus
                        },
                        contractVersionNumber = version
                    }
                }
            };
        }
    }
}
