namespace AllocationDeliveryDomain.Endpoint.Tests.Unit
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using AllocationDelivery.Messages.Commands;
    using AllocationDelivery.Messages.DTOs;
    using AllocationDeliveryDomain.Endpoint.BusinessLogic;
    using AllocationDeliveryDomain.Endpoint.BusinessLogic.Enricher;
    using AllocationDeliveryDomain.Endpoint.BusinessLogic.Mapper;
    using AllocationDeliveryDomain.Endpoint.Infrastructure;
    using AllocationDeliveryDomain.Endpoint.Repositories;
    using AllocationDeliveryDomain.Endpoint.Routing;
    using AllocationDeliveryDomain.Endpoint.Validation;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using Optional;
    using SFA.FCT.AllocationDelivery.DataStore.Repositories;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.AllocationDeliveryDomain.Endpoint.BusinessLogic.Validator;
    using SFA.FCT.CrossDomain.Integration.Entities.AllocationActuals;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class ReportedActualsHandlerFlowTests
    {
        private static readonly ConnectionInfo Connection = new ConnectionInfo(null, new Mock<System.Data.IDbConnection>().Object);

        [TestClass]
        public class LoadedHandler
        {
            private Mock<IActualEnricher> _enricher;
            private Mock<IActualValidator> _validator;
            private Mock<IMultiSourceActualRepository> _actuals;
            private Mock<IMapper<EnrichedReportedActual, ContractAllocationActualsType>> _mapper;
            private Mock<IActualsAuditMapper> _auditMapper;
            private Mock<IMonitoringDeliverableStore> _store;
            private Mock<ICurrentViewActualsComponent> _currentView;
            private Mock<IGenericSubmissionEnricher> _zeroiser;
            private Mock<IFundingStreamConfigurationStore> _fspStore;
            private Mock<IProcessedMessageRepository> _processed;
            private FundingStreamPeriod _fsp;
            private ReportedActualsLoadedHandler _handler;
            private TestableMessageHandlerContext _context;

            [TestInitialize]
            public void Init()
            {
                _enricher = new Mock<IActualEnricher>();
                _validator = new Mock<IActualValidator>();
                _actuals = new Mock<IMultiSourceActualRepository>();
                _mapper = new Mock<IMapper<EnrichedReportedActual, ContractAllocationActualsType>>();
                _auditMapper = new Mock<IActualsAuditMapper>();
                _store = new Mock<IMonitoringDeliverableStore>();
                _currentView = new Mock<ICurrentViewActualsComponent>();
                _zeroiser = new Mock<IGenericSubmissionEnricher>();
                _fspStore = new Mock<IFundingStreamConfigurationStore>();
                _processed = new Mock<IProcessedMessageRepository>();
                var connections = new Mock<ISessionConnectionFactory>();
                connections.Setup(c => c.GetConnection(It.IsAny<NServiceBus.IMessageHandlerContext>())).Returns(Connection);

                _fsp = new FundingStreamPeriod { Code = "FSP1" };
                _fspStore.Setup(s => s.GetFundingStreamPeriod("FSP1", Connection)).Returns(_fsp);
                _processed.Setup(p => p.Add(It.IsAny<string>(), Connection)).Returns(true);
                _actuals.Setup(a => a.GetReportedActuals(It.IsAny<string[]>(), It.IsAny<SummarisedActualOrgFspGroupKey[]>(), Connection))
                    .Returns(new List<ReportedActual> { new ReportedActual { ActualValue = 5 } });
                _validator.Setup(v => v.IsCalcDateAfterFspActivityCloseDate("FSP1", Connection)).Returns(false);
                _validator.Setup(v => v.GetValidActuals(It.IsAny<List<EnrichedReportedActual>>(), Connection))
                    .Returns((List<EnrichedReportedActual> l, ConnectionInfo c) => l);
                _auditMapper.Setup(m => m.Map(It.IsAny<IEnumerable<EnrichedReportedActual>>(), Connection))
                    .Returns(new List<AllocationDeliverablePeriodActualAudit>());
                _mapper.Setup(m => m.Map(It.IsAny<IEnumerable<EnrichedReportedActual>>()))
                    .Returns(new List<ContractAllocationActualsType>
                    {
                        new ContractAllocationActualsType { ContractAllocationNumber = "A1" },
                        new ContractAllocationActualsType { ContractAllocationNumber = "A2" }
                    });

                _handler = new ReportedActualsLoadedHandler(
                    _enricher.Object, _validator.Object, _actuals.Object, new Mock<ILogger>().Object, _mapper.Object,
                    _auditMapper.Object, _store.Object, _currentView.Object, _zeroiser.Object, _fspStore.Object,
                    _processed.Object, connections.Object);
                _context = new TestableMessageHandlerContext { MessageId = "m1" };
            }

            private static ReportedActualsLoadedCommand Command() => new ReportedActualsLoadedCommand
            {
                FundingStreamPeriodCode = "FSP1",
                PartitionKeys = new[] { "PK1" },
                SummarisedActualOrgFspGroupKeys = new SummarisedActualOrgFspGroupKey[0]
            };

            private void EnrichReturnsOne()
            {
                _enricher.Setup(e => e.Enrich(It.IsAny<IEnumerable<ReportedActual>>(), Connection))
                    .Returns(new[] { new EnrichedReportedActual { ActualValue = 5 } });
            }

            [TestMethod, TestCategory("UnitTest")]
            public async Task DuplicateMessage_DoesNothing()
            {
                _processed.Setup(p => p.Add("m1", Connection)).Returns(false);

                await _handler.Handle(Command(), _context);

                _actuals.Verify(a => a.GetReportedActuals(It.IsAny<string[]>(), It.IsAny<SummarisedActualOrgFspGroupKey[]>(), It.IsAny<ConnectionInfo>()), Times.Never());
                Assert.AreEqual(0, _context.PublishedMessages.Length);
            }

            [TestMethod, TestCategory("UnitTest")]
            public async Task AfterActivityCloseDate_StopsBeforeEnriching()
            {
                _validator.Setup(v => v.IsCalcDateAfterFspActivityCloseDate("FSP1", Connection)).Returns(true);

                await _handler.Handle(Command(), _context);

                _enricher.Verify(e => e.Enrich(It.IsAny<IEnumerable<ReportedActual>>(), It.IsAny<ConnectionInfo>()), Times.Never());
                Assert.AreEqual(0, _context.PublishedMessages.Length);
            }

            [TestMethod, TestCategory("UnitTest")]
            public async Task NoEnrichedActuals_PublishesNothing()
            {
                _enricher.Setup(e => e.Enrich(It.IsAny<IEnumerable<ReportedActual>>(), Connection))
                    .Returns(new EnrichedReportedActual[0]);

                await _handler.Handle(Command(), _context);

                _validator.Verify(v => v.GetValidActuals(It.IsAny<List<EnrichedReportedActual>>(), It.IsAny<ConnectionInfo>()), Times.Never());
                Assert.AreEqual(0, _context.PublishedMessages.Length);
            }

            [TestMethod, TestCategory("UnitTest")]
            public async Task ValidActuals_AuditedAndOneEventPublishedPerAllocation()
            {
                EnrichReturnsOne();

                await _handler.Handle(Command(), _context);

                _store.Verify(s => s.StoreActualsAudit(It.IsAny<IEnumerable<AllocationDeliverablePeriodActualAudit>>(), Connection), Times.Once());
                var published = _context.PublishedMessages.Select(m => m.Message).OfType<AllocationActualsVerified>().ToList();
                CollectionAssert.AreEqual(new[] { "A1", "A2" }, published.Select(p => p.AllocationActuals.ContractAllocationNumber).ToArray());
                _zeroiser.Verify(z => z.AddMissingActualsWithZeroValues(It.IsAny<IReadOnlyCollection<EnrichedReportedActual>>(), It.IsAny<FundingStreamZeroisationBehaviour>(), It.IsAny<ConnectionInfo>()), Times.Never());
                _currentView.Verify(c => c.UpdateCurrentViewActualsReturningFullSetOfEnrichedActuals(It.IsAny<List<EnrichedReportedActual>>(), It.IsAny<ConnectionInfo>()), Times.Never());
            }

            [TestMethod, TestCategory("UnitTest")]
            public async Task NoValidActuals_StillCompletesWithoutError()
            {
                EnrichReturnsOne();
                _validator.Setup(v => v.GetValidActuals(It.IsAny<List<EnrichedReportedActual>>(), Connection))
                    .Returns(new List<EnrichedReportedActual>());
                _mapper.Setup(m => m.Map(It.IsAny<IEnumerable<EnrichedReportedActual>>()))
                    .Returns(new List<ContractAllocationActualsType>());

                await _handler.Handle(Command(), _context);

                Assert.AreEqual(0, _context.PublishedMessages.Length);
            }

            [TestMethod, TestCategory("UnitTest")]
            public async Task ZeroiseMissingActuals_AddsMissingActuals()
            {
                _fsp.ZeroiseMissingActuals = true;
                EnrichReturnsOne();
                var zeroed = new List<EnrichedReportedActual> { new EnrichedReportedActual() };
                _zeroiser.Setup(z => z.AddMissingActualsWithZeroValues(It.IsAny<IReadOnlyCollection<EnrichedReportedActual>>(), FundingStreamZeroisationBehaviour.ZeroiseMissingActuals, Connection))
                    .Returns(zeroed);

                await _handler.Handle(Command(), _context);

                _zeroiser.VerifyAll();
                _mapper.Verify(m => m.Map(zeroed), Times.Once());
            }

            [TestMethod, TestCategory("UnitTest")]
            public async Task PersistCurrentActualsState_UsesFullSetFromCurrentView()
            {
                _fsp.ZeroiseMissingActuals = true;
                _fsp.PersistCurrentActualsState = true;
                EnrichReturnsOne();
                _zeroiser.Setup(z => z.AddMissingActualsWithZeroValues(It.IsAny<IReadOnlyCollection<EnrichedReportedActual>>(), It.IsAny<FundingStreamZeroisationBehaviour>(), Connection))
                    .Returns((IReadOnlyCollection<EnrichedReportedActual> l, FundingStreamZeroisationBehaviour b, ConnectionInfo c) => l.ToList());
                var full = new List<EnrichedReportedActual> { new EnrichedReportedActual(), new EnrichedReportedActual() };
                _currentView.Setup(c => c.UpdateCurrentViewActualsReturningFullSetOfEnrichedActuals(It.IsAny<List<EnrichedReportedActual>>(), Connection))
                    .Returns(full);

                await _handler.Handle(Command(), _context);

                _mapper.Verify(m => m.Map(full), Times.Once());
            }
        }

        [TestClass]
        public class RoutingHandler
        {
            private Mock<IAzureRepository<ReportedActual>> _reported;
            private Mock<IFundingStreamPeriodRepository> _fsps;
            private Mock<IHeldReportedActualGroupCommandRepository> _held;
            private ReportedActualsRoutingCommandHandler _handler;
            private TestableMessageHandlerContext _context;

            [TestInitialize]
            public void Init()
            {
                _reported = new Mock<IAzureRepository<ReportedActual>>();
                _fsps = new Mock<IFundingStreamPeriodRepository>();
                _held = new Mock<IHeldReportedActualGroupCommandRepository>();
                var connections = new Mock<ISessionConnectionFactory>();
                connections.Setup(c => c.GetConnection(It.IsAny<NServiceBus.IMessageHandlerContext>())).Returns(Connection);
                _handler = new ReportedActualsRoutingCommandHandler(_reported.Object, _fsps.Object, new Mock<ILogger>().Object, _held.Object, connections.Object);
                _context = new TestableMessageHandlerContext();
            }

            private static SummarisedActualOrgFspGroupKey Key(string collectionType = "ILR") => new SummarisedActualOrgFspGroupKey
            {
                CollectionType = collectionType,
                CollectionReturnCode = "R01",
                OrganisationId = "ORG",
                FundingStreamPeriodCode = "FSP1",
                UopCode = "UOP"
            };

            private void FspIs(FundingStreamPeriod fsp)
            {
                _fsps.Setup(f => f.GetFundingStreamPeriod("FSP1", Connection)).Returns(fsp.Some());
            }

            [TestMethod, TestCategory("UnitTest")]
            public async Task PayOnActuals_SendsReportedActualsLoaded()
            {
                FspIs(new FundingStreamPeriod { Code = "FSP1", PaymentMethod = FundingStreamPeriodPaymentMethod.PayOnActuals });
                var message = new ReportedActualsRoutingCommand { SummarisedActualOrgFspGroupKey = Key() };

                await _handler.Handle(message, _context);

                var sent = _context.SentMessages.Select(m => m.Message).OfType<ReportedActualsLoadedCommand>().Single();
                Assert.AreEqual("FSP1", sent.FundingStreamPeriodCode);
                Assert.AreEqual(1, sent.SummarisedActualOrgFspGroupKeys.Length);
            }

            [TestMethod, TestCategory("UnitTest")]
            public async Task PayOnInstruction_SendsPaymentInstructionsLoaded()
            {
                FspIs(new FundingStreamPeriod { Code = "FSP1", PaymentMethod = FundingStreamPeriodPaymentMethod.PayOnInstruction });

                await _handler.Handle(new ReportedActualsRoutingCommand { SummarisedActualOrgFspGroupKey = Key() }, _context);

                Assert.AreEqual(1, _context.SentMessages.Select(m => m.Message).OfType<ReportedPaymentInstructionsLoadedCommand>().Count());
            }

            [TestMethod, TestCategory("UnitTest")]
            public async Task MultiCollectionReturns_AddsToHeldTableAndSendsNothing()
            {
                FspIs(new FundingStreamPeriod { Code = "FSP1", MultiCollectionReturns = true });

                await _handler.Handle(new ReportedActualsRoutingCommand { SummarisedActualOrgFspGroupKey = Key() }, _context);

                _held.Verify(h => h.Add(It.Is<HeldReportedActualGroup>(g => g.FundingStreamPeriodCode == "FSP1" && g.OrganisationIdentifier == "ORG" && g.CollectionReturnCode == "R01"), Connection), Times.Once());
                Assert.AreEqual(0, _context.SentMessages.Length);
            }

            [TestMethod, TestCategory("UnitTest")]
            public async Task AzureTableStorage_DerivesKeyFromFirstReportedActual()
            {
                _reported.Setup(r => r.GetRows("PK1")).Returns(new List<ReportedActual>
                {
                    new ReportedActual { FundingStreamPeriodCode = "FSP1", CollectionType = "ILR", OrganisationId = "ORG", CollectionReturnCode = "R01", UoPCode = "UOP" }
                });
                FspIs(new FundingStreamPeriod { Code = "FSP1" });

                await _handler.Handle(new ReportedActualsRoutingCommand { PartitionKey = "PK1" }, _context);

                var sent = _context.SentMessages.Select(m => m.Message).OfType<ReportedActualsLoadedCommand>().Single();
                CollectionAssert.AreEqual(new[] { "PK1" }, sent.PartitionKeys);
            }

            [TestMethod, TestCategory("UnitTest")]
            public async Task AzureTableStorage_NoRowsAndNoKey_LogsAndSendsNothing()
            {
                _reported.Setup(r => r.GetRows("PK1")).Returns(new List<ReportedActual>());

                await _handler.Handle(new ReportedActualsRoutingCommand { PartitionKey = "PK1" }, _context);

                Assert.AreEqual(0, _context.SentMessages.Length);
                _fsps.Verify(f => f.GetFundingStreamPeriod(It.IsAny<string>(), It.IsAny<ConnectionInfo>()), Times.Never());
            }

            [TestMethod, TestCategory("UnitTest")]
            public async Task UnknownFsp_AllowedCollectionType_IsIgnored()
            {
                _fsps.Setup(f => f.GetFundingStreamPeriod("FSP1", Connection)).Returns(Option.None<FundingStreamPeriod>());

                await _handler.Handle(new ReportedActualsRoutingCommand { SummarisedActualOrgFspGroupKey = Key("ALLF") }, _context);

                Assert.AreEqual(0, _context.SentMessages.Length);
            }

            [TestMethod, TestCategory("UnitTest")]
            public async Task UnknownFsp_OtherCollectionType_Throws()
            {
                _fsps.Setup(f => f.GetFundingStreamPeriod("FSP1", Connection)).Returns(Option.None<FundingStreamPeriod>());

                try
                {
                    await _handler.Handle(new ReportedActualsRoutingCommand { SummarisedActualOrgFspGroupKey = Key("ILR") }, _context);
                    Assert.Fail("Expected ArgumentException");
                }
                catch (ArgumentException ex)
                {
                    StringAssert.Contains(ex.Message, "FSP1");
                }
            }
        }
    }
}
