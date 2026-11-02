using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore;

namespace AllocationsEventsLoader.Loaders
{
    using System;
    using System.Collections.Generic;
    using System.Data.Entity;
    using System.Linq;
    using ADMonitoringDomain.DataStore;
    using ADMonitoringDomain.Endpoint;
    using ADMonitoringDomain.Endpoint.BusinessLogic;
    using Moq;
    using NServiceBus;
    using PaymentGenerationDomain.BusinessLogic;
    using PaymentGenerationDomain.BusinessLogic.Mappers;
    using PaymentGenerationDomain.Integration.DataStore;
    using PaymentGenerationDomain.Integration.DataStore.Model;
    using PaymentGenerationDomain.Integration.PaymentGenerationEndpoint.ProcessPaymentRunCompleteEndpoint;
    using SFA.FCT.AllocationDelivery.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;

    public class ContractAllocationsPaymentPostedItemLoader
    {
        private static readonly Mock<IBus> BusMock = new Mock<IBus>();
        private static readonly Mock<ILogger> LoggerMock = new Mock<ILogger>();
        private static readonly Mock<IDataAccessManager> DataAccessManagerMock = new Mock<IDataAccessManager>();

        private readonly PaymentGenerationDbContext _paymentGenerationDbContext = new PaymentGenerationDbContext();
        private readonly List<ProcessPaymentRunCompleteCommand> _processPaymentRunCompleteCommands = new List<ProcessPaymentRunCompleteCommand>();
        private readonly List<IPaymentPostedEvent> _paymentPostedEvents = new List<IPaymentPostedEvent>();

        public void LoadItems()
        {
            Console.WriteLine("Retrieving completed payments...");
            CreateProcessPaymentRunCompleteCommands();
            Console.WriteLine("{0} payment items found", _processPaymentRunCompleteCommands.Count);
            var processPaymentRunCompleteHandler = CreateProcessPaymentRunCompleteHandler();

            foreach (var processPaymentRunCompleteCommand in _processPaymentRunCompleteCommands)
            {
                Console.WriteLine("Processing payment for fsp code: {0} and census end date: {1}", processPaymentRunCompleteCommand.FundingStreamPeriodCode, processPaymentRunCompleteCommand.CensusEndDate);
                var paymentGenerationDbContext = new PaymentGenerationDbContext();
                var cmd = processPaymentRunCompleteCommand;
                var calendarPeriod = GetCalendarPeriodForPaymentTimetableFspAndCensusEndDate(
                    paymentGenerationDbContext, cmd.FundingStreamPeriodCode, cmd.CensusEndDate);

                DataAccessManagerMock.Setup(m => 
                    m.GetCalendarPeriodForPaymentTimetableFspAndCensusEndDate(cmd.FundingStreamPeriodCode,cmd.CensusEndDate))
                    .Returns(calendarPeriod);

                DataAccessManagerMock.Setup(m =>
                    m.UpdatePaymentsToPostedForPaymentRun(cmd.FundingStreamPeriodCode, calendarPeriod))
                    .Returns(GetSubnominalAggregates(paymentGenerationDbContext, cmd.FundingStreamPeriodCode, calendarPeriod));

                DataAccessManagerMock.SetupGet(m => m.Context).Returns(() => paymentGenerationDbContext);

                DataAccessManagerMock.Object.Context = paymentGenerationDbContext;
                processPaymentRunCompleteHandler.Handle(processPaymentRunCompleteCommand);
            }

            Console.WriteLine("Sending payment posted events to the Atom Feed Handler");
    
            foreach (var paymentPostedEvent in _paymentPostedEvents)
            {
                using (var allocationDeliveryContext = new AllocationDeliveryDbContext())
                using (var paymentSchedulePolicyContext = new PaymentSchedulePolicyContext())
                using (var monitoringDeliverablesDbContext = new MonitoringDeliverablesDbContext())
                using (var allocationDeliveryMonitoringDbContext = new AllocationDeliveryMonitoringDbContext())
                using (var paymentManagementPolicyContext = new PaymentManagementPolicyContext())
                {
                    var contractAllocationsAtomFeedGenerationHandler =
                        CreateContractAllocationsAtomFeedGenerationHandler(allocationDeliveryContext, allocationDeliveryMonitoringDbContext, paymentSchedulePolicyContext, monitoringDeliverablesDbContext, paymentManagementPolicyContext);

                    contractAllocationsAtomFeedGenerationHandler.Handle(paymentPostedEvent);
                    Console.WriteLine("Sent payment posted event for Allocation {0}, Version {1} for fsp code {2}",
                        paymentPostedEvent.Allocation.AllocationNumber, paymentPostedEvent.Allocation.VersionNumber, paymentPostedEvent.Allocation.FundingStreamPeriodCode);
                }
            }
        }

        public static ContractAllocationsAtomFeedGenerationHandler CreateContractAllocationsAtomFeedGenerationHandler(
            AllocationDeliveryDbContext allocationDeliveryDbContext,
            AllocationDeliveryMonitoringDbContext allocationDeliveryMonitoringDbContext,
            PaymentSchedulePolicyContext paymentSchedulePolicyContext,
            MonitoringDeliverablesDbContext monitoringDeliverablesDbContext,
            PaymentManagementPolicyContext paymentManagementPolicyContext)
        {
            IAtomItemCreator atomItemCreator = new AtomItemCreator(paymentSchedulePolicyContext, monitoringDeliverablesDbContext, allocationDeliveryMonitoringDbContext, new DataAccessManager() { Context = new PaymentGenerationDbContext() });
            IRulesEngine rulesEngine = new RulesEngine(paymentSchedulePolicyContext, paymentManagementPolicyContext);
            IAtomGenerator atomGenerator = new AtomGenerator(atomItemCreator, allocationDeliveryDbContext, new SystemDate());
            IADMonitoringDeliveryEventStore monitoringDeliveryEventStore = new ADMonitoringDeliveryEventStore(allocationDeliveryMonitoringDbContext);

            var contractAllocationsAtomFeedGenerationHandler = new ContractAllocationsAtomFeedGenerationHandler(rulesEngine, atomGenerator, monitoringDeliveryEventStore)
            {
                Logger = LoggerMock.Object
            };
            return contractAllocationsAtomFeedGenerationHandler;
        }

        private void CreateProcessPaymentRunCompleteCommands()
        {
            IEnumerable<PaymentTimetable> paymentTimeTables = GetCompletedPaymentTimeTables();
            foreach (var paymentTimeTable in paymentTimeTables)
            {
                var processPaymentRunCompleteCommand = new ProcessPaymentRunCompleteCommand
                {
                    CensusEndDate = paymentTimeTable.CensusEndDate,
                    FundingStreamPeriodCode = paymentTimeTable.FundingStreamPeriodCode,
                    FundingStreamPeriodStartDate = paymentTimeTable.PeriodStartDate,
                    FundingStreamPeriodEndDate = paymentTimeTable.PeriodEndDate
                };
                _processPaymentRunCompleteCommands.Add(processPaymentRunCompleteCommand);
            }
        }

        private IEnumerable<PaymentTimetable> GetCompletedPaymentTimeTables()
        {
            const string statusCompleted = "Completed";

            return _paymentGenerationDbContext.PaymentTimetables.Where(x => x.CensusEndDate <= DateTime.Now && x.Status == statusCompleted)
                 .Include(pt => pt.FundingStreamPeriod);
        }

        private ProcessPaymentRunCompleteHandler CreateProcessPaymentRunCompleteHandler()
        {
            BusMock.Setup(m => m.Publish(It.IsAny<PaymentPostedEvent>()))
                .Callback<object>((m => _paymentPostedEvents.Add((IPaymentPostedEvent)m)));

            var processPaymentRunCompleteHandler = new ProcessPaymentRunCompleteHandler
            {
                DataManager = DataAccessManagerMock.Object,
                Logger = LoggerMock.Object,
                Mapper = new AggregatedPaymentMapper()
                {
                    PaymentSchedulePolicyContext = new PaymentSchedulePolicyContext()
                },
                Bus = BusMock.Object
            };
            return processPaymentRunCompleteHandler;
        }

        private string GetCalendarPeriodForPaymentTimetableFspAndCensusEndDate(PaymentGenerationDbContext context, string fspCode, DateTime censusEndDate)
        {
            return context.PaymentTimetables.Single(
                x => x.FundingStreamPeriodCode == fspCode && x.CensusEndDate == censusEndDate).CalendarPeriod;
        }

        private IQueryable<SubnominalAggregation> GetSubnominalAggregates(PaymentGenerationDbContext context, string fspCode, string calendarPeriod)
        {
            return context.SubnominalAggregations.Where(x => x.FundingStreamPeriodCode == fspCode
                && x.Period == calendarPeriod
                && x.AggregatedValue != 0
                && x.IsSelectedForPayment)   
                .Include(sa => sa.FundingStreamPeriod)    
                .Include(sa => sa.FundingStreamPeriod.FundingStream)    
                .Include(sa => sa.Subnominal);
        }
    }
}
