namespace AllocationsEventsLoader.Loaders
{
    using System;
    using System.Collections.Generic;
    using System.Data.Entity;
    using System.Linq;
    using ADMonitoringDomain.DataStore;
    using ADMonitoringDomain.Endpoint;
    using ADMonitoringDomain.Endpoint.BusinessLogic;
    using AllocationDeliveryDomain.Endpoint;
    using AllocationDeliveryDomain.Endpoint.BusinessLogic;
    using AllocationDeliveryDomain.Endpoint.BusinessLogic.Mapper;
    using AllocationDeliveryDomain.Endpoint.Commands;
    using AllocationDeliveryDomain.Endpoint.Deds;
    using AllocationDeliveryDomain.Endpoint.Handlers;
    using AllocationDeliveryDomain.Endpoint.Services;
    using Castle.MicroKernel.Lifestyle;
    using Castle.Windsor;
    using Helpers;
    using Moq;
    using NServiceBus;
    using PaymentGenerationDomain.BusinessLogic;
    using PaymentGenerationDomain.Integration.DataStore;
    using SFA.FCT.AllocationDelivery.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Cache;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.Common.Commands;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.AllocationDeliveryDomain.Endpoint.BusinessLogic.Validator;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.AllocationActuals;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.PaymentManagementDomain.BusinessLogic;
    using SFA.FCT.PaymentManagementDomain.Integration.PaymentAggregation.Handlers;
    using SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Handlers;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;
    using SFA.FCT.PMD.PaymentManagment.DataStore;
    using SFA.FCT.PMD.PaymentManagment.DataStore.Model;

    public class ContractAllocationsActualsVerifiedItemLoader
    {
        private static readonly Mock<IBus> BusMock;
        private static readonly Mock<IDate> DateMock;
        private static readonly Mock<ILogger> LoggerMock;
        private static readonly Mock<IPaymentManagementDBContext> PaymentManagementDbContextMock;
        private static readonly Mock<IMonitoringDeliverableStore> MonitoringDeliverableStoreMock;
        private static readonly IMonitoringDeliverablesDbContext MonitoringDeliverablesDbContext;
        private static readonly IAllocationDeliveryDbContext AllocationDeliveryDbContext;
        private static readonly IAllocationDeliveryMonitoringDbContext AllocationDeliveryMonitoringDbContext;
        private static readonly IPaymentSchedulePolicyContext PaymentSchedulePolicyContext;
        private static readonly IPaymentManagementPolicyContext PaymentManagementPolicyContext;
        private static readonly SFA.FCT.PaymentManagementDomain.Integration.RulesEngine.IRulesEngine RulesEngine;

        static ContractAllocationsActualsVerifiedItemLoader()
        {
            BusMock = new Mock<IBus>();
            DateMock = new Mock<IDate>();
            DateMock
                .Setup(m => m.GetCalculationDate())
                .Returns(GetLastClosedCollectionTime());
            LoggerMock = new Mock<ILogger>();
            PaymentManagementDbContextMock = new Mock<IPaymentManagementDBContext>();
            PaymentManagementDbContextMock
                .Setup(m => m.PaymentScheduleIds)
                .Returns(EfHelper.GetQueryableMockDbSet<PaymentScheduleId>());
            MonitoringDeliverableStoreMock = new Mock<IMonitoringDeliverableStore>();
            MonitoringDeliverablesDbContext = new MonitoringDeliverablesDbContext();
            AllocationDeliveryDbContext = new AllocationDeliveryDbContext();
            AllocationDeliveryMonitoringDbContext = new AllocationDeliveryMonitoringDbContext();
            PaymentSchedulePolicyContext = new PaymentSchedulePolicyContext();
            PaymentManagementPolicyContext = new PaymentManagementPolicyContext();
            RulesEngine = new SFA.FCT.PaymentManagementDomain.Integration.RulesEngine.RulesEngine();
        }

        private static DateTime GetLastClosedCollectionTime()
        {
            using (var container = new WindsorContainer().Install(new AllocationDeliveryDomain.Endpoint.IoC.WindsorInstaller(new LoggerFactory())))
            {
                return
                    container.Resolve<IAzureRepository<ClosedCollectionHistory>>()
                    .GetRows()
                    .OrderByDescending(c => c.LastClosedTime)
                    .First()
                    .LastClosedTime;
            }
        }

        public void LoadItems()
        {
            ProcessActualsVerifiedCommands();
        }

        public static ContractAllocationsAtomFeedGenerationHandler CreateContractAllocationsAtomFeedGenerationHandler()
        {
            IAtomItemCreator atomItemCreator = new AtomItemCreator(PaymentSchedulePolicyContext, MonitoringDeliverablesDbContext, AllocationDeliveryMonitoringDbContext, new DataAccessManager() { Context = new PaymentGenerationDbContext()});
            IRulesEngine rulesEngine = new RulesEngine(PaymentSchedulePolicyContext, PaymentManagementPolicyContext);
            IAtomGenerator atomGenerator = new AtomGenerator(atomItemCreator, AllocationDeliveryDbContext, DateMock.Object);
            IADMonitoringDeliveryEventStore monitoringDeliveryEventStore = new ADMonitoringDeliveryEventStore(AllocationDeliveryMonitoringDbContext);

            var contractAllocationsAtomFeedGenerationHandler = new ContractAllocationsAtomFeedGenerationHandler(rulesEngine, atomGenerator, monitoringDeliveryEventStore)
            {
                Logger = LoggerMock.Object
            };
            return contractAllocationsAtomFeedGenerationHandler;
        }

        private void ProcessActualsVerifiedCommands()
        {
            using (var container = new WindsorContainer().Install(new AllocationDeliveryDomain.Endpoint.IoC.WindsorInstaller(new LoggerFactory())))
            {
                var reportedActualsLoadedCommands = new List<ReportedActualsLoadedCommand>();

                foreach (ActualsCollectionTypeSummary collectionTypeSummary in GetMostRecentActualsCollectionTypeSummaries())
                {
                    Console.WriteLine("Getting reported {0} actuals for period {1} ...",
                        collectionTypeSummary.PartitionKey,
                        collectionTypeSummary.RowKey);
                    reportedActualsLoadedCommands.AddRange(GetReportedActualsLoadedCommandMessages(
                        container, collectionTypeSummary.PartitionKey, collectionTypeSummary.RowKey));
                }

                var allocationActualVerifiedMessages = new List<AllocationActualsVerified>();
                var paymentScheduleEvents = new List<PaymentScheduleEvent>();
                var paymentAggregatedEvents = new List<PaymentAggregatedEvent>();

                Console.WriteLine("Publishing {0} Reported Actuals Loaded commands via the mocked ServiceBus", reportedActualsLoadedCommands.Count);
                foreach (var reportedActualsLoadedCommand in reportedActualsLoadedCommands)
                {
                    allocationActualVerifiedMessages.AddRange(PublishReportedActualsLoadedCommandMessage(container, reportedActualsLoadedCommand));
                }

                Console.WriteLine("Publishing {0} Allocation Actual Verified messages via the mocked ServiceBus", allocationActualVerifiedMessages.Count);
                foreach (var allocationActualVerifiedMessage in allocationActualVerifiedMessages)
                {
                    paymentScheduleEvents.AddRange(PublishAllocationActualsVerifiedMessage(container, allocationActualVerifiedMessage));
                }

                Console.WriteLine("Publishing {0} Payment Schedule Event messages via the mocked ServiceBus", paymentScheduleEvents.Count);
                foreach (var paymentScheduleEvent in paymentScheduleEvents)
                {
                    paymentAggregatedEvents.AddRange(PublishPaymentScheduleEventMessage(container, paymentScheduleEvent));
                }

                Console.WriteLine("Sending {0} Payment Aggregated Event messages to the ContractAllocationsAtomFeedGenerationHandler", paymentAggregatedEvents.Count);
                paymentAggregatedEvents.ForEach(RunContractAllocationsAtomFeedGenerationHandler);
            }
        }

        private static IEnumerable<ActualsCollectionTypeSummary> GetMostRecentActualsCollectionTypeSummaries()
        {
            using (var container = new WindsorContainer().Install(new AllocationDeliveryDomain.Endpoint.IoC.WindsorInstaller(new LoggerFactory())))
            {
                return
                    container.Resolve<IAzureRepository<ActualsCollectionTypeSummary>>()
                    .GetRows()
                    .GroupBy(acts => acts.PartitionKey) // collection type
                    .Select(grp => grp
                        .OrderByDescending(acts => acts.RowKey) // collection return code
                        .First());}
        }

        private IEnumerable<ReportedActualsLoadedCommand> GetReportedActualsLoadedCommandMessages(
            IWindsorContainer container, string collectionType, string collectionReturnCode)
        {
            using (container.BeginScope())
            {
                var reportedActualsLoadedCommandMessages = new List<ReportedActualsLoadedCommand>();

                BusMock.Setup(m => m.Send(It.IsAny<ReportedActualsLoadedCommand>()))
                    .Callback<object>(m => reportedActualsLoadedCommandMessages.Add((ReportedActualsLoadedCommand)m));

                var dedsPoller = new DedsPoller(
                    new Mock<IDedsService>().Object,
                    container.Resolve<IAzureRepository<ReportedActual>>(),
                    BusMock.Object,
                    new Mock<ILogger>().Object,
                    container.Resolve<IAzureRepository<ActualsCollectionTypeSummary>>(),
                    container.Resolve<IAzureRepository<ActualAllocationGroupKeyEntity>>(),
                    container.Resolve<IAzureRepository<ClosedCollectionHistory>>(),
                    container.Resolve<IDedsPollerContext>());

                dedsPoller.Handle(new SendReportedActualsLoadedCommand
                {
                    CollectionType = collectionType,
                    CollectionReturnCode = collectionReturnCode
                });

                return reportedActualsLoadedCommandMessages;
            }
        }
        
        private IEnumerable<AllocationActualsVerified> PublishReportedActualsLoadedCommandMessage(IWindsorContainer container, ReportedActualsLoadedCommand command)
        {
            Console.WriteLine("Processing partition {0}", command.PartitionKey);
            using (container.BeginScope())
            {
                var allocationActualVerifiedEvents = new List<AllocationActualsVerified>();

                BusMock.Setup(m => m.Publish(It.IsAny<AllocationActualsVerified>()))
                    .Callback<object>(m => allocationActualVerifiedEvents.Add((AllocationActualsVerified)m));

                using (var monitoringDeliverablesDbContext = new MonitoringDeliverablesDbContext())
                {
                    IFundingStreamConfigurationStore fundingStreamConfigurationStore = new FundingStreamConfigurationStore
                    {
                        DbContext = monitoringDeliverablesDbContext,
                        FundingStreamPeriodCache = container.Resolve<IFundingStreamPeriodCache>()
                    };

                    IMonitoringDeliverableStore monitoringDeliverableStore =
                    new MonitoringDeliverableStore(monitoringDeliverablesDbContext, new Mock<ILogger>().Object);

                    var reportedActualsLoadedHandler = new ReportedActualsLoadedHandler(
                        new ActualEnricher
                        {
                            DeliverableStore = monitoringDeliverableStore
                        },
                        new ActualValidator
                        {
                            Date = DateMock.Object,
                            Logger = LoggerMock.Object,
                            Store = fundingStreamConfigurationStore
                        },
                        container.Resolve<IAzureRepository<ReportedActual>>(),
                        LoggerMock.Object,
                        container.Resolve<IMapper<EnrichedReportedActual, ContractAllocationActualsType>>(),
                        new ActualsAuditMapper(fundingStreamConfigurationStore, DateMock.Object),
                        MonitoringDeliverableStoreMock.Object,
                        new CurrentViewActualsComponent(fundingStreamConfigurationStore, monitoringDeliverableStore))
                    {
                        Bus = BusMock.Object
                    };

                    reportedActualsLoadedHandler.Handle(command);
                }
                
                return allocationActualVerifiedEvents;
            }
        }

        private IEnumerable<PaymentScheduleEvent> PublishAllocationActualsVerifiedMessage(IWindsorContainer container, IAllocationActualsVerified message)
        {
            Console.WriteLine("Processing Allocation {0} with Funding Stream Period Code {1}",
                message.AllocationActuals.ContractAllocationNumber, message.AllocationActuals.FundingStreamPeriodCode);
            using (container.BeginScope())
            {
                var paymentScheduleEvents = new List<PaymentScheduleEvent>();
                var dbSetMock = SetupFakeAllocationIdData();

                BusMock.Setup(m => m.CurrentMessageContext.Headers[It.IsAny<string>()]).Returns(Guid.NewGuid().ToString);
                BusMock.Setup(m => m.Publish(It.IsAny<PaymentScheduleEvent>()))
                    .Callback<object>(m => paymentScheduleEvents.Add((PaymentScheduleEvent)m));

                PaymentManagementDbContextMock.Setup(m => m.AllocationActualsIds).Returns(dbSetMock.Object);

                //send message to AllocationActualsVerifiedHandler to generate PaymentScheduleEvents
                using (var paymentManagementPolicyContext = new PaymentManagementPolicyContext())
                using (var paymentSchedulePolicyContext = new PaymentSchedulePolicyContext())
                {
                    var allocationActualsVerifiedHandler = new AllocationActualsVerifiedHandler
                    {
                        Bus = BusMock.Object,
                        PaymentManager = new PaymentManager
                        {
                            DateManager = DateMock.Object,
                            PaymentManagementPolicyContext = paymentManagementPolicyContext,
                            PaymentSchedulePolicyContext = paymentSchedulePolicyContext,
                            RulesEngine = RulesEngine,
                            Logger = LoggerMock.Object

                        },
                        PaymentManagementDbContext = PaymentManagementDbContextMock.Object,
                        Logger = LoggerMock.Object
                    };

                    allocationActualsVerifiedHandler.Handle(message);
                }
                
                RunContractAllocationsAtomFeedGenerationHandler(message);
                return paymentScheduleEvents;
            }
        }

        private IEnumerable<PaymentAggregatedEvent> PublishPaymentScheduleEventMessage(IWindsorContainer container, PaymentScheduleEvent message)
        {
            Console.WriteLine("Processing Allocation {0}, Version {1} with Funding Stream Period Code {2}",
                message.PaymentScheduleAllocation.AllocationNumber, message.PaymentScheduleAllocation.VersionNumber, message.PaymentScheduleAllocation.FundingStreamPeriodCode);
            using (container.BeginScope())
            {
                var paymentAggregatedEvents = new List<PaymentAggregatedEvent>();

                BusMock.Setup(m => m.CurrentMessageContext.Headers[It.IsAny<string>()]).Returns(Guid.NewGuid().ToString);
                BusMock.Setup(m => m.Publish(It.IsAny<PaymentAggregatedEvent>()))
                    .Callback<object>(m => paymentAggregatedEvents.Add((PaymentAggregatedEvent)m));

                using (var paymentManagementPolicyContext = new PaymentManagementPolicyContext())
                {
                    //send message to PaymentScheduleHandler to generate PaymentAggregatedEvents
                    var paymentScheduleHandler = new PaymentScheduleHandler
                    {
                        Bus = BusMock.Object,
                        PaymentManager = new PaymentManager
                        {
                            DateManager = DateMock.Object,
                            PaymentManagementPolicyContext = paymentManagementPolicyContext,
                            PaymentSchedulePolicyContext = PaymentSchedulePolicyContext,
                            RulesEngine = RulesEngine,
                            Logger = LoggerMock.Object
                        },
                        PaymentManagementDbContext = PaymentManagementDbContextMock.Object,
                        PaymentManagementPolicyContext = paymentManagementPolicyContext,
                        Logger = LoggerMock.Object
                    };

                    paymentScheduleHandler.Handle(message);
                }
                
                RunContractAllocationsAtomFeedGenerationHandler(message);

                return paymentAggregatedEvents;
            }
        }

        private static void RunContractAllocationsAtomFeedGenerationHandler(object message)
        {
            var messageType = message.GetType().ToString();
            var contractAllocationsAtomFeedGenerationHandler = CreateContractAllocationsAtomFeedGenerationHandler();

            switch (messageType)
            {
                case "SFA.FCT.CrossDomain.Integration.Events.AllocationActualsVerified":
                    var actualVerifiedMessage = (AllocationActualsVerified)message;
                    Console.WriteLine("Sending AllocationActualsVerified message for Allocation {0} with Funding Stream Period Code {1} to the Atom Feed Handler",
                        actualVerifiedMessage.AllocationActuals.ContractAllocationNumber, actualVerifiedMessage.AllocationActuals.FundingStreamPeriodCode);
                    contractAllocationsAtomFeedGenerationHandler.Handle(actualVerifiedMessage);
                    break;

                case "SFA.FCT.CrossDomain.Integration.Events.PaymentScheduleEvent":
                    var paymentScheduledMessage = (PaymentScheduleEvent)message;
                    Console.WriteLine("Sending PaymentScheduleEvent message for Allocation {0}, Version {1} with Funding Stream Period Code {2} to the Atom Feed Handler",
                       paymentScheduledMessage.PaymentScheduleAllocation.AllocationNumber, paymentScheduledMessage.PaymentScheduleAllocation.VersionNumber, paymentScheduledMessage.PaymentScheduleAllocation.FundingStreamPeriodCode);
                    contractAllocationsAtomFeedGenerationHandler.Handle(paymentScheduledMessage);
                    break;

                case "SFA.FCT.CrossDomain.Integration.Events.PaymentAggregatedEvent":
                    var paymentAggregatedMessage = (PaymentAggregatedEvent)message;
                    Console.WriteLine("Sending PaymentAggregatedEvent message for Allocation {0}, Version {1} with Funding Stream Period Code {2} to the Atom Feed Handler",
                      paymentAggregatedMessage.Allocation.AllocationNumber, paymentAggregatedMessage.Allocation.VersionNumber, paymentAggregatedMessage.Allocation.FundingStreamPeriodCode);
                    contractAllocationsAtomFeedGenerationHandler.Handle(paymentAggregatedMessage);
                    break;
            }
        }

        private Mock<IDbSet<AllocationActualsId>> SetupFakeAllocationIdData()
        {
            var data = new List<AllocationActualsId>             
                { 
                    new AllocationActualsId { CorrelationId = Guid.NewGuid(), CreatedDate = DateTime.Now },
                    new AllocationActualsId { CorrelationId = Guid.NewGuid(), CreatedDate = DateTime.Now.AddSeconds(10) }         
                }.AsQueryable();

            var dbSetMock = new Mock<IDbSet<AllocationActualsId>>();
            dbSetMock.Setup(m => m.Provider).Returns(data.Provider);
            dbSetMock.Setup(m => m.Expression).Returns(data.Expression);
            dbSetMock.Setup(m => m.ElementType).Returns(data.ElementType);
            dbSetMock.Setup(m => m.GetEnumerator()).Returns(data.GetEnumerator());

            return dbSetMock;
        }

        private class ReadOnlyPaymentSchedulePolicyContext : PaymentSchedulePolicyContext
        {
            public override int SaveChanges()
            {
                return 0;
            }
        }
    }
}
