namespace ContractManagementDomain.Endpoint.Tests.ConfirmPublicationToProvider
{
    using System;
    using System.Linq;
    using Endpoint.ConfirmPublicationToProvider;
    using Endpoint.Services;
    using Infrastructure;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractApproval;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Services;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class ConfirmPublicationToProviderHandlerFlowTests
    {
        private const string ChildNumber = "CON-1";
        private const string MasterNumber = "MAS-1";

        private Mock<IContractsManager> _contractsManager;
        private Mock<IFundingTypeFundingPeriodService> _fundingService;
        private Mock<IDateProvider> _dateProvider;
        private Mock<IXrmManager> _xrmManager;
        private TestableMessageHandlerContext _context;
        private ConfirmPublicationToProviderHandler _handler;

        [TestInitialize]
        public void Setup()
        {
            _contractsManager = new Mock<IContractsManager>();
            _fundingService = new Mock<IFundingTypeFundingPeriodService>();
            _dateProvider = new Mock<IDateProvider>();
            _xrmManager = new Mock<IXrmManager>();
            _context = new TestableMessageHandlerContext();
            _handler = new ConfirmPublicationToProviderHandler(
                Mock.Of<ILogger>(),
                Mock.Of<ISessionConnectionFactory>(),
                _dateProvider.Object,
                _contractsManager.Object,
                _fundingService.Object,
                _xrmManager.Object);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_WhenContractNumberMissing_ShouldDoNothing()
        {
            AssertNothingHappens(null, MasterNumber);
            AssertNothingHappens(string.Empty, MasterNumber);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_WhenMasterContractNumberMissing_ShouldDoNothing()
        {
            AssertNothingHappens(ChildNumber, null);
            AssertNothingHappens(ChildNumber, string.Empty);
        }

        private void AssertNothingHappens(string contractNumber, string masterContractNumber)
        {
            _handler.Handle(Command(contractNumber, masterContractNumber), _context).Wait();

            _contractsManager.Verify(
                m => m.GetCorporateContract(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<bool>()),
                Times.Never);
            Assert.AreEqual(0, _context.SentMessages.Length);
            Assert.AreEqual(0, _context.PublishedMessages.Length);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_WhenCrmReturnsNoContract_ShouldNotSendOrPublish()
        {
            SetupContract(null);

            _handler.Handle(Command(), _context).Wait();

            Assert.AreEqual(0, _context.SentMessages.Length);
            Assert.AreEqual(0, _context.PublishedMessages.Length);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_WhenMasterContractHasNoChildContracts_ShouldNotSendOrPublish()
        {
            SetupContract(new contract { contractNumber = MasterNumber });

            _handler.Handle(Command(), _context).Wait();

            Assert.AreEqual(0, _context.SentMessages.Length);
            Assert.AreEqual(0, _context.PublishedMessages.Length);
            _xrmManager.Verify(
                x => x.UpdateContractPublishedToProviderFailed(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>(), It.IsAny<string>()),
                Times.Never);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_WhenDocumentationNotRequired_ShouldMarkPublishedToProviderAndPublishReadyEvent()
        {
            DateTime publishedDate = new DateTime(2024, 5, 17, 9, 30, 0);
            contract master = CreateMaster("AGE", documentationRequired: false);
            SetupContract(master);
            _dateProvider.Setup(d => d.GetDate(It.IsAny<ConnectionInfo>())).Returns(publishedDate);
            _fundingService
                .Setup(s => s.GetApprovalType("AGE", "FY1516"))
                .Returns(ContractApprovalType.Electronic);

            _handler.Handle(Command(), _context).Wait();

            ContractReadyToPublishEvent published = _context.PublishedMessages
                .Select(m => m.Message)
                .OfType<ContractReadyToPublishEvent>()
                .Single();
            Assert.AreSame(master, published.CorporateContract);
            Assert.AreEqual(ContractApprovalType.Electronic, published.ContractApprovalType);
            Assert.AreEqual("PublishedToProvider", master.contracts.Single().contractStatus.status);
            Assert.AreEqual(publishedDate, master.contracts.Single().StatusLastUpdatedDate);
            Assert.AreEqual(0, _context.SentMessages.Length);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_WhenDocumentationRequiredIsNull_ShouldPublishReadyEventRatherThanMoveDocuments()
        {
            contract master = CreateMaster("AGE", documentationRequired: null);
            SetupContract(master);

            _handler.Handle(Command(), _context).Wait();

            Assert.AreEqual(1, _context.PublishedMessages.Count(m => m.Message is ContractReadyToPublishEvent));
            Assert.AreEqual(0, _context.SentMessages.Count(m => m.Message is DocumentMoveCommand));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_WhenLevyContractIsVersionOne_ShouldNotCheckAllocationSync()
        {
            SetupContract(CreateMaster("LEVY", documentationRequired: false, versionNumber: 1));

            _handler.Handle(Command(), _context).Wait();

            _fundingService.Verify(
                s => s.IsLEVYAllocationSynced(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>(), It.IsAny<int>()),
                Times.Never);
            Assert.AreEqual(1, _context.PublishedMessages.Count(m => m.Message is ContractReadyToPublishEvent));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_WhenLevyAmendmentAllocationsAreSynced_ShouldPublishWithoutRetrying()
        {
            SetupContract(CreateMaster("LEVY", documentationRequired: false, versionNumber: 2));
            _fundingService
                .Setup(s => s.IsLEVYAllocationSynced(ChildNumber, 2, 0, 0))
                .Returns(true);

            _handler.Handle(Command(), _context).Wait();

            _contractsManager.Verify(
                m => m.GetCorporateContract(ChildNumber, MasterNumber, false),
                Times.Once);
            Assert.AreEqual(1, _context.PublishedMessages.Count(m => m.Message is ContractReadyToPublishEvent));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_WhenContractingActivityHasClosed_ShouldFailPublicationInCrmAndNotPublish()
        {
            SetupContract(CreateMaster("AGE", documentationRequired: false));
            _fundingService
                .Setup(s => s.IsProcessDateAfterFundingTypeContractingActivityCloseDate("AGE", "FY1516", It.IsAny<ConnectionInfo>()))
                .Returns(true);

            _handler.Handle(Command(), _context).Wait();

            _xrmManager.Verify(
                x => x.UpdateContractPublishedToProviderFailed(
                    ChildNumber,
                    1,
                    0,
                    It.Is<string>(r => r.Contains("12345678") && r.Contains(ChildNumber) && r.Contains("1516"))),
                Times.Once);
            Assert.AreEqual(0, _context.PublishedMessages.Length);
            Assert.AreEqual(0, _context.SentMessages.Length);
        }

        private static ConfirmPublicationToProviderCommand Command(string contractNumber = ChildNumber, string masterContractNumber = MasterNumber)
        {
            return new ConfirmPublicationToProviderCommand
            {
                ContractNumber = contractNumber,
                MasterContractNumber = masterContractNumber
            };
        }

        private void SetupContract(contract master)
        {
            _contractsManager
                .Setup(m => m.GetCorporateContract(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<bool>()))
                .Returns(master);
        }

        private static contract CreateMaster(string fundingTypeCode, bool? documentationRequired, int versionNumber = 1)
        {
            return new contract
            {
                contractNumber = MasterNumber,
                contracts =
                {
                    new contract
                    {
                        contractNumber = ChildNumber,
                        contractVersionNumber = versionNumber,
                        contractor = new contractor { ukprn = 12345678 },
                        contractStatus = new contractStatusType(),
                        fundingType = new fundingType { fundingTypeCode = fundingTypeCode, fundingTypeName = fundingTypeCode },
                        period = new period
                        {
                            period1 = "1516",
                            periodType = new periodTypeType { periodTypeCode = periodTypeCodeType.FY }
                        },
                        DocumentationRequired = documentationRequired
                    }
                }
            };
        }
    }
}
