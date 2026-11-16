namespace AllocationDeliveryDomain.Endpoint.Tests.PaymentInstructionValidation
{
    using System;
    using System.Collections.Generic;
    using System.Data;
    using System.Linq;
    using AllocationDelivery.Messages.Commands;
    using AllocationDelivery.Messages.DTOs;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;
    using AllocationDeliveryDomain.Endpoint.PaymentInstructionValidation;
    using Endpoint.Infrastructure;
    using Endpoint.PaymentInstructionValidation.Repositories;
    using Endpoint.PaymentInstructionValidation.Services;
    using NServiceBus.Testing;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class ReportedPaymentInstructionsLoadedCommandHandlerTests
    {
        private readonly TestableMessageHandlerContext _testableContext = new TestableMessageHandlerContext();
        private Mock<IPaymentInstructionAuditRepository> _paymentInstructionAuditRepository;
        private Mock<IReportedPaymentEnricher> _reportedPaymentEnricherMock;
        private Mock<IPaymentInstructionValidator> _paymentInstructionValidatorMock;
        private ReportedPaymentInstructionsLoadedCommandHandler _handler;

        [TestInitialize]
        public void TestInitialize()
        {
            EnrichedReportedActual[] enrichedReportedActuals =
            {
                new EnrichedReportedActual
                {
                    CollectionType = "APPS",
                    CollectionReturnCode = "APPS01",
                    OrganisationId = "ORG000123456",
                    PeriodTypeCode = "CM",
                    Period = "201705",
                    FundingStreamPeriodCode = "LEVY1799",
                    ContractAllocationNumber = "LEVY-1000",
                    EnrichedDeliverableCode = "5",
                    ActualVolume = 0,
                    ActualValue = 1234.56,
                    Ukprn = "123456",
                    ContractNumber = "APPLEVY-1000",
                    ContractVersion = 1,
                    ContractSubVersion = 2,
                    AllocationStartDate = new DateTime(2017, 05, 01)
                },
                new EnrichedReportedActual
                {
                    CollectionType = "APPS",
                    CollectionReturnCode = "APPS01",
                    OrganisationId = "ORG000654321",
                    PeriodTypeCode = "CM",
                    Period = "201705",
                    FundingStreamPeriodCode = "LEVY1799",
                    ContractAllocationNumber = "LEVY-1001",
                    EnrichedDeliverableCode = "6",
                    ActualVolume = 0,
                    ActualValue = 6543.21,
                    Ukprn = "654321",
                    ContractNumber = "APPLEVY-1000",
                    ContractVersion = 1,
                    ContractSubVersion = 2,
                    AllocationStartDate = new DateTime(2017, 05, 01)
                }
            };

            Mock<IMultiSourceActualRepository> multiSourceRepositoryMock = new Mock<IMultiSourceActualRepository>();
            multiSourceRepositoryMock
                .Setup(m => m.GetReportedActuals(It.IsAny<string>(), It.IsAny<SummarisedActualOrgFspGroupKey>(), It.IsAny<ConnectionInfo>()))
                .ReturnsAsync(new List<ReportedActual>(enrichedReportedActuals));

            _reportedPaymentEnricherMock = new Mock<IReportedPaymentEnricher>();
            _reportedPaymentEnricherMock
                .Setup(m => m.Enrich(It.IsAny<ConnectionInfo>(), It.IsAny<IReadOnlyCollection<ReportedActual>>()))
                .Returns(new List<EnrichedReportedActual>(enrichedReportedActuals));

            _paymentInstructionValidatorMock = new Mock<IPaymentInstructionValidator>();
            _paymentInstructionValidatorMock
                .Setup(m => m.Validate(It.IsAny<EnrichedReportedActual>()))
                .Callback<EnrichedReportedActual>(era => era.IsValid = true);

            _paymentInstructionAuditRepository = new Mock<IPaymentInstructionAuditRepository>();

            Mock<ConnectionInfo> mockConnectionInfo = new Mock<ConnectionInfo>(null, Mock.Of<IDbConnection>());
            Mock<ISessionConnectionFactory> mockSessionConnectionFactory = new Mock<ISessionConnectionFactory>();

            mockSessionConnectionFactory
                .Setup(s => s.GetConnection(It.IsAny<IMessageHandlerContext>()))
                .Returns(mockConnectionInfo.Object);

            _handler = new ReportedPaymentInstructionsLoadedCommandHandler(
                Mock.Of<ILogger>(),
                multiSourceRepositoryMock.Object,
                _reportedPaymentEnricherMock.Object,
                _paymentInstructionValidatorMock.Object,
                _paymentInstructionAuditRepository.Object,
                new SystemDate(),
                Mock.Of<IMonitoringDeliverablesForAllocationService>(),
                mockSessionConnectionFactory.Object);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ReportedPaymentInstructionsLoadedCommandHandler_ShouldResolveAllDependenciesFromEndpointContainer()
        {
            // arrange
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<ReportedPaymentInstructionsLoadedCommandHandler>().ImplementedBy<ReportedPaymentInstructionsLoadedCommandHandler>());

            container.BeginScope();

            // act, assert
            container.Resolve<ReportedPaymentInstructionsLoadedCommandHandler>();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ReportedPaymentInstructionsLoadedCommandHandler_ShouldStorePaymentInstructionAuditsWithCorrectlyTransformedPaymentInstructions()
        {
            // arrange
            List<PaymentInstructionAudit> storedAudits = new List<PaymentInstructionAudit>();

            _paymentInstructionAuditRepository
                .Setup(m => m.CreatePaymentInstructionAudits(It.IsAny<IEnumerable<PaymentInstructionAudit>>(), It.IsAny<ConnectionInfo>()))
                .Callback<IEnumerable<PaymentInstructionAudit>, ConnectionInfo>((audits, ci) => storedAudits.AddRange(audits));

            // act
            _handler.Handle(new ReportedPaymentInstructionsLoadedCommand
            {
                PartitionKey = "TEST"
            }, _testableContext).Wait();

            // assert
            Assert.AreEqual(2, storedAudits.Count, "Incorrect number of audit records stored.");

            PaymentInstructionAudit storedAudit = storedAudits.Single(sa => sa.ContractAllocationNumber == "LEVY-1000");
            Assert.AreEqual("APPS", storedAudit.CollectionType, "Incorrect CollectionType stored.");
            Assert.AreEqual("APPS01", storedAudit.CollectionReturnCode, "Incorrect CollectionReturnCode stored.");
            Assert.AreEqual("ORG000123456", storedAudit.OrganisationId, "Incorrect OrganisationId stored.");
            Assert.AreEqual("201705", storedAudit.Period, "Incorrect Period stored.");
            Assert.AreEqual("LEVY1799", storedAudit.FundingStreamPeriodCode, "Incorrect FundingStreamPeriodCode stored.");
            Assert.AreEqual("LEVY-1000", storedAudit.ContractAllocationNumber, "Incorrect ContractAllocationNumber stored.");
            Assert.AreEqual(5, storedAudit.DeliverableCode, "Incorrect DeliverableCode stored.");
            Assert.AreEqual(1234.56M, storedAudit.PaymentValue, "Incorrect PaymentValue stored.");
            Assert.AreEqual("123456", storedAudit.Ukprn, "Incorrect Ukprn stored.");
            Assert.AreEqual("APPLEVY-1000", storedAudit.ContractNumber, "Incorrect ContractNumber stored.");
            Assert.AreEqual(1, storedAudit.ContractVersion, "Incorrect ContractVersion stored.");
            Assert.AreEqual(2, storedAudit.ContractSubVersion, "Incorrect ContractSubVersion stored.");
            Assert.AreEqual(new DateTime(2017, 05, 01), storedAudit.AllocationStartDate, "Incorrect AllocationStartDate stored.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ReportedPaymentInstructionsLoadedCommandHandler_ShouldPublishAllocationPaymentInstructionReceivedEvents()
        {
            // act
            _handler.Handle(new ReportedPaymentInstructionsLoadedCommand
            {
                PartitionKey = "TEST"
            }, _testableContext).Wait();

            // assert
            Assert.AreEqual(2, _testableContext.PublishedMessages.Count(m => m.Message is IAllocationPaymentInstructionReceivedEvent), 
                $"{nameof(IAllocationPaymentInstructionReceivedEvent)} was not published");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ReportedPaymentInstructionsLoadedCommandHandler_ShouldHandleEnricherReturningNoPaymentInstructions()
        {
            // arrange
            List<PaymentInstructionAudit> storedAudits = new List<PaymentInstructionAudit>();

            _paymentInstructionAuditRepository
                .Setup(m => m.CreatePaymentInstructionAudits(It.IsAny<IEnumerable<PaymentInstructionAudit>>(), It.IsAny<ConnectionInfo>()))
                .Callback<IEnumerable<PaymentInstructionAudit>, ConnectionInfo>((audits, ci) => storedAudits.AddRange(audits));

            // no valid reported payments
            _reportedPaymentEnricherMock.Setup(m => m.Enrich(It.IsAny<ConnectionInfo>(), It.IsAny<IReadOnlyCollection<ReportedActual>>()))
                .Returns(new List<EnrichedReportedActual>());

            // act
            _handler.Handle(new ReportedPaymentInstructionsLoadedCommand
            {
                PartitionKey = "TEST"
            }, _testableContext).Wait();

            // assert
            Assert.AreEqual(0, storedAudits.Count, "Incorrect number of audit records stored.");

            _paymentInstructionValidatorMock.Verify(m => m.Validate(It.IsAny<EnrichedReportedActual>()), Times.Never, "Validate was called");

            Assert.AreEqual(0, _testableContext.PublishedMessages.Count(m => m.Message is IAllocationPaymentInstructionReceivedEvent),
                $"{nameof(IAllocationPaymentInstructionReceivedEvent)} was published");
        }
    }
}