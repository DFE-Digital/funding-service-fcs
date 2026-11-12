namespace PaymentManagementDomain.PaymentSchedule.Xrm.Tests.Handlers
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using NServiceBus.Testing;
    using PaymentManagementDomain.PaymentSchedule.DeliverableAggregation;
    using PaymentManagementDomain.PaymentSchedule.PaymentScheduleXrm;
    using PaymentManagementDomain.PaymentSchedule.Xrm.Infrastructure;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Dtos;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Repositories;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.Xrm.Integration.Repositories;
    using ConnectionInfo = SFA.FCT.CrossDomain.Integration.Entities.Data.ConnectionInfo;
    using IPaymentScheduleService = PaymentManagementDomain.PaymentSchedule.PaymentScheduleXrm.Services.IPaymentScheduleService;

    [TestClass]
    public class PaymentScheduleHandlerFlowTests
    {
        private readonly TestableMessageHandlerContext _context = new TestableMessageHandlerContext();
        private readonly ConnectionInfo _connectionInfo = new ConnectionInfo(null, null);

        [TestMethod, TestCategory("UnitTest")]
        public async Task AggregateDeliverables_UpdatesCrmWithAggregatedDeliverables()
        {
            var service = new Mock<IAggregateDeliverablesService>();
            var connectionFactory = new Mock<ISessionConnectionFactory>();
            var crmRepository = new Mock<ICrmDeliverableRepository>();
            connectionFactory.Setup(f => f.GetConnection(_context)).Returns(_connectionInfo);
            IReadOnlyCollection<DeliverableActual> actuals = new List<DeliverableActual> { new DeliverableActual(1, 10m, 2) };
            service
                .Setup(s => s.GetAggregatedDeliverablesForAllocation("ALLOC1", 3, "FSP1", _connectionInfo))
                .Returns(actuals);
            var handler = new AggregateDeliverablesHandler(Mock.Of<ILogger>(), service.Object, connectionFactory.Object, crmRepository.Object);

            await handler.Handle(
                new AggregateDeliverablesCommand { AllocationNumber = "ALLOC1", ContractVersionNumber = 3, SubVersionNumber = 4, FundingStreamPeriodCode = "FSP1" },
                _context);

            crmRepository.Verify(r => r.UpdateDeliverablesInCrmForAllocation("ALLOC1", 3, 4, actuals), Times.Once());
        }

        private static PaymentScheduleEvent CreateEvent()
        {
            return new PaymentScheduleEvent
            {
                PaymentScheduleAllocation = new Allocation
                {
                    AllocationNumber = "ALLOC1",
                    ContractVersionNumber = 3,
                    FundingStreamPeriodCode = "FSP1",
                    AllocationDeliverables = new List<AllocationDeliverable>
                    {
                        new AllocationDeliverable
                        {
                            DeliverableCode = 7,
                            ScheduledPayments = new List<ScheduledPayment>
                            {
                                new ScheduledPayment { Period = "201708" },
                                new ScheduledPayment { Period = "201709" }
                            }
                        }
                    }
                }
            };
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task PaymentSchedule_WhenMessageNotProcessedBefore_SyncsDeliverablesAndSendsAggregateCommand()
        {
            var allocationRepository = new Mock<ICrmAllocationRepository>();
            var periodRepository = new Mock<ICrmDeliverablePeriodRepository>();
            var processedMessages = new Mock<IProcessedMessageRepository>();
            var connectionFactory = new Mock<ISessionConnectionFactory>();
            var paymentScheduleService = new Mock<IPaymentScheduleService>();
            var allocationInfo = new AllocationInfo(System.Guid.NewGuid(), new System.DateTime(2017, 8, 1), null, 5, System.Guid.NewGuid(), "ALLOC1");
            var existingPeriod = new DeliverablePeriodYear(8, "201708", 2017, "7");
            IReadOnlyCollection<DeliverablePeriodYear> periodsInCrm = new List<DeliverablePeriodYear> { existingPeriod };
            IReadOnlyCollection<DeliverablePeriodYear> missing = null;
            connectionFactory.Setup(f => f.GetConnection(_context)).Returns(_connectionInfo);
            processedMessages.Setup(r => r.Add(_context.MessageId, _connectionInfo)).Returns(true);
            allocationRepository.Setup(r => r.GetAllocationInfoFromCrm("ALLOC1", 3)).Returns(allocationInfo);
            allocationRepository
                .Setup(r => r.GetContractDeliverablesForAllocation(allocationInfo.AllocationId))
                .Returns(new List<DeliverableInfo>());
            periodRepository.Setup(r => r.GetDeliverablePeriodYears(allocationInfo.AllocationId)).Returns(periodsInCrm);
            paymentScheduleService
                .Setup(s => s.CreateMissingDeliverablesAndTheirPeriods(It.IsAny<IReadOnlyCollection<DeliverableInfo>>(), allocationInfo, "FSP1", It.IsAny<IReadOnlyCollection<DeliverablePeriodYear>>()))
                .Callback<IReadOnlyCollection<DeliverableInfo>, AllocationInfo, string, IReadOnlyCollection<DeliverablePeriodYear>>((d, a, f, m) => missing = m);
            var handler = new PaymentScheduleEventHandler(
                Mock.Of<ILogger>(), allocationRepository.Object, periodRepository.Object, processedMessages.Object, connectionFactory.Object, paymentScheduleService.Object);

            await handler.Handle(CreateEvent(), _context);

            Assert.AreEqual(1, missing.Count);
            Assert.AreEqual("201709", missing.Single().PeriodName);
            paymentScheduleService.Verify(
                s => s.UpdateExistingDeliverablesAndTheirPeriods(It.IsAny<IReadOnlyCollection<DeliverableInfo>>(), allocationInfo, "FSP1", periodsInCrm, It.Is<IReadOnlyCollection<DeliverablePeriodYear>>(p => p.Count == 2)),
                Times.Once());
            var sent = _context.SentMessages.Select(m => m.Message).OfType<AggregateDeliverablesCommand>().Single();
            Assert.AreEqual("ALLOC1", sent.AllocationNumber);
            Assert.AreEqual(3, sent.ContractVersionNumber);
            Assert.AreEqual(5, sent.SubVersionNumber);
            Assert.AreEqual("FSP1", sent.FundingStreamPeriodCode);
        }

        [TestMethod, TestCategory("UnitTest")]
        public async Task PaymentSchedule_WhenMessageAlreadyProcessed_DoesNothing()
        {
            var allocationRepository = new Mock<ICrmAllocationRepository>();
            var processedMessages = new Mock<IProcessedMessageRepository>();
            var connectionFactory = new Mock<ISessionConnectionFactory>();
            var paymentScheduleService = new Mock<IPaymentScheduleService>();
            connectionFactory.Setup(f => f.GetConnection(_context)).Returns(_connectionInfo);
            processedMessages.Setup(r => r.Add(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(false);
            var handler = new PaymentScheduleEventHandler(
                Mock.Of<ILogger>(), allocationRepository.Object, Mock.Of<ICrmDeliverablePeriodRepository>(), processedMessages.Object, connectionFactory.Object, paymentScheduleService.Object);

            await handler.Handle(CreateEvent(), _context);

            allocationRepository.Verify(r => r.GetAllocationInfoFromCrm(It.IsAny<string>(), It.IsAny<int>()), Times.Never());
            paymentScheduleService.Verify(s => s.CreateMissingDeliverablesAndTheirPeriods(It.IsAny<IReadOnlyCollection<DeliverableInfo>>(), It.IsAny<AllocationInfo>(), It.IsAny<string>(), It.IsAny<IReadOnlyCollection<DeliverablePeriodYear>>()), Times.Never());
            Assert.AreEqual(0, _context.SentMessages.Length);
        }
    }
}
