namespace ContractCreateDomain.Endpoint.Tests.UpdateContract
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using ContractManagement.DataStore.Model;
    using Endpoint.Infrastructure;
    using Endpoint.Services;
    using Endpoint.UpdateContract;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus;
    using SFA.FCT.ContractCreateDomain.BusinessLogic;
    using SFA.FCT.ContractCreateDomain.Common.Messages.Commands;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.CrossDomain.Integration.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;
    using ContractRequest = SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

    [TestClass]
    public class UpdateContractFromFundingHandlerBehaviourTests
    {
        private const string ContractNumber = "ESF-1000";

        private Mock<IContractsManager> _contractsManager;
        private Mock<IContractStorage> _contractStorage;
        private Mock<IContractTypeTransformer> _transformer;
        private Mock<IContractDeliverableEnricher> _enricher;
        private Mock<IContractValueAggregator> _aggregator;
        private Mock<IFundingTypeFundingPeriodQueryRepository> _fundingRepository;
        private Mock<ISessionConnectionFactory> _sessionFactory;
        private Mock<IFundingTypePeriodService> _fundingTypePeriodService;
        private Mock<IValueVariationService> _valueVariationService;
        private Mock<ILastApprovedContractCreationDateService> _lastApprovedService;
        private Mock<ICheckForContractChangeService> _changeService;
        private Mock<IMessageHandlerContext> _context;
        private UpdateContractFromFundingHandler _handler;
        private Contract _master;
        private Contract _corpChild;
        private object _sentMessage;
        private ExtendedContractType _extended;

        [TestInitialize]
        public void Setup()
        {
            _contractsManager = new Mock<IContractsManager>();
            _contractStorage = new Mock<IContractStorage>();
            _transformer = new Mock<IContractTypeTransformer>();
            _enricher = new Mock<IContractDeliverableEnricher>();
            _aggregator = new Mock<IContractValueAggregator>();
            _fundingRepository = new Mock<IFundingTypeFundingPeriodQueryRepository>();
            _sessionFactory = new Mock<ISessionConnectionFactory>();
            _fundingTypePeriodService = new Mock<IFundingTypePeriodService>();
            _valueVariationService = new Mock<IValueVariationService>();
            _lastApprovedService = new Mock<ILastApprovedContractCreationDateService>();
            _changeService = new Mock<ICheckForContractChangeService>();
            _context = new Mock<IMessageHandlerContext>();

            var child = new contractType
            {
                contractNumber = ContractNumber,
                startDate = new DateTime(2020, 8, 1, 13, 30, 0),
                endDate = new DateTime(2021, 7, 31, 9, 15, 0),
                contractor = new Contractor { ukprn = 100 },
                fundingType = new fundingType { fundingTypeCode = "ESF" },
                period = new Period { period1 = "2021" },
                contractAllocations = new List<contractAllocationsContractAllocation>(),
                CrmContractId = Guid.NewGuid()
            };
            child.contractAllocations.Add(new contractAllocationsContractAllocation
            {
                contractAllocationNumber = "A-1",
                startDate = new DateTime(2020, 8, 1, 10, 0, 0),
                endDate = new DateTime(2021, 7, 31, 11, 0, 0),
                contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>()
            });
            _master = new Contract { contractNumber = ContractNumber, contracts = new List<contractType> { child } };
            _corpChild = new Contract { contractNumber = ContractNumber, amendmentType = "Variation" };
            _extended = new ExtendedContractType { contractNumber = ContractNumber };

            _contractsManager.Setup(m => m.GetCorporateContractForSpecificVersion(ContractNumber, 3, 2)).Returns(_master);
            _sessionFactory.Setup(f => f.GetConnection(It.IsAny<IMessageHandlerContext>())).Returns(ConnectionInfo.CreateDefault());
            _contractStorage.Setup(s => s.GetKey(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<int>())).Returns("storage-key");
            _transformer.Setup(t => t.TransformContractTypeToExtendedContractType(It.IsAny<contractType>())).Returns(_extended);
            _transformer.Setup(t => t.TransformContractTypeToContract(It.IsAny<contractType>())).Returns(_corpChild);
            _transformer.Setup(t => t.TransformCorpContractToContractRequest(It.IsAny<contractType>())).Returns(new ContractRequest.contractType());
            _fundingRepository.Setup(r => r.Get("ESF", It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(new FundingTypeFundingPeriod());
            _lastApprovedService.Setup(s => s.GetLatestCreatedDateForNonNotificationApprovedContract(ContractNumber, It.IsAny<ConnectionInfo>()))
                .Returns(Task.FromResult<DateTime?>(new DateTime(2020, 1, 1)));
            _context.Setup(c => c.Send(It.IsAny<object>(), It.IsAny<SendOptions>()))
                .Callback<object, SendOptions>((m, o) => _sentMessage = m)
                .Returns(Task.FromResult(0));

            _handler = new UpdateContractFromFundingHandler(
                Mock.Of<ILogger>(), _contractsManager.Object, _contractStorage.Object, _transformer.Object, _enricher.Object,
                _aggregator.Object, _fundingRepository.Object, _sessionFactory.Object, _fundingTypePeriodService.Object,
                _valueVariationService.Object, _lastApprovedService.Object, _changeService.Object);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_UpdateDraft_MergesAllocationsStoresContractAndSendsForDocumentation()
        {
            var newAllocation = new ExtendedContractAllocation
            {
                contractAllocationNumber = "A-2",
                startDate = new DateTime(2020, 9, 1, 8, 0, 0),
                contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>()
            };
            var command = new UpdateContractFromFundingCommand(
                new CrmContractIdentity(ContractNumber, 3, 2, Guid.NewGuid().ToString()), new[] { newAllocation },
                "reply-endpoint", ContractIntent.UpdateDraft, "Variation", 9, false);

            _handler.Handle(command, _context.Object).Wait();

            var child = _master.contracts.First();
            Assert.AreEqual(3, child.contractVersionNumber);
            Assert.AreEqual(3, child.contractSubVersionNumber);
            Assert.AreEqual(child.CrmContractId, child.PreviousVersionId);
            Assert.AreEqual(2, child.contractAllocations.Count);
            Assert.AreEqual(new DateTime(2020, 8, 1), child.startDate);
            Assert.AreEqual(new DateTime(2021, 7, 31), child.endDate);
            Assert.AreEqual("Variation", child.amendmentType);
            _enricher.Verify(e => e.Enrich(It.IsAny<contractType>()), Times.Once());
            _aggregator.Verify(a => a.Aggregate(It.IsAny<contractType>()), Times.Once());
            _contractStorage.Verify(s => s.UploadContract("storage-key", It.Is<ExtendedContractTypeAndIntent>(i => i.Intent == ContractIntent.UpdateDraft)), Times.Once());
            _fundingTypePeriodService.Verify(s => s.EnrichContract(_extended, It.IsAny<FundingTypeFundingPeriod>()), Times.Once());
            _valueVariationService.Verify(s => s.UpdateValueVariation(It.IsAny<ExtendedContractType>()), Times.Never());
            _changeService.Verify(s => s.UpdateAllocationsThatHaveBeenAddedOrChangedService(It.IsAny<ContractRequest.contractType>()), Times.Never());

            var sent = (EnrichContractForDocumentationCommand)_sentMessage;
            Assert.AreSame(_corpChild, sent.Contract);
            Assert.AreEqual(ContractNumber, sent.MasterContractNumber);
            Assert.AreEqual("reply-endpoint", sent.ReplyToEndpointName);
            Assert.IsTrue(sent.Contract.DocumentationRequired.Value);
            Assert.IsTrue(sent.Contract.IsNewRevisedNewOrUpdateDraft);
            Assert.IsTrue(sent.Contract.IsVariation);
            Assert.AreEqual(new DateTime(2020, 1, 1), sent.Contract.LatestCreatedDateForNonNotificationApprovedContract);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_Amendment_UpdatesValueVariationAndChecksForContractChanges()
        {
            var command = new UpdateContractFromFundingCommand(
                new CrmContractIdentity(ContractNumber, 3, 2, Guid.NewGuid().ToString()), new List<ExtendedContractAllocation>(),
                "reply-endpoint", ContractIntent.Amendment, "Other", 9, true);
            _master.contracts.First().IsAmendment = true;
            _corpChild.amendmentType = "Other";

            _handler.Handle(command, _context.Object).Wait();

            var child = _master.contracts.First();
            Assert.AreEqual(10, child.contractVersionNumber);
            Assert.AreEqual(0, child.contractSubVersionNumber);
            _valueVariationService.Verify(s => s.UpdateValueVariation(_extended), Times.Once());
            _changeService.Verify(s => s.UpdateAllocationsThatHaveBeenAddedOrChangedService(It.Is<ContractRequest.contractType>(c => c.contracts.Count == 1)), Times.Once());
            _changeService.Verify(s => s.UpdateCorpContractAllocations(_corpChild, It.IsAny<ContractRequest.contractType>()), Times.Once());
            var sent = (EnrichContractForDocumentationCommand)_sentMessage;
            Assert.IsFalse(sent.Contract.IsNewRevisedNewOrUpdateDraft);
            Assert.IsFalse(sent.Contract.IsVariation);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Handle_UpdateDraftAmendment_ChecksForContractChangesWithoutNewVersion()
        {
            var command = new UpdateContractFromFundingCommand(
                new CrmContractIdentity(ContractNumber, 3, 2, Guid.NewGuid().ToString()), new List<ExtendedContractAllocation>(),
                "reply-endpoint", ContractIntent.UpdateDraftAmendment, "Variation", 9, false);

            _handler.Handle(command, _context.Object).Wait();

            Assert.AreEqual(3, _master.contracts.First().contractVersionNumber);
            _changeService.Verify(s => s.UpdateCorpContractAllocations(_corpChild, It.IsAny<ContractRequest.contractType>()), Times.Once());
            Assert.IsFalse(((EnrichContractForDocumentationCommand)_sentMessage).Contract.IsNewRevisedNewOrUpdateDraft);
        }
    }
}
