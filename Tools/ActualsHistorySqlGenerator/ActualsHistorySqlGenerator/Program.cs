namespace ActualsHistorySqlGenerator
{
    using System;
    using System.Collections.Generic;
    using AllocationDeliveryDomain.Endpoint;
    using AllocationDeliveryDomain.Endpoint.BusinessLogic;
    using AllocationDeliveryDomain.Endpoint.BusinessLogic.Mapper;
    using AllocationDeliveryDomain.Endpoint.Commands;
    using AllocationDeliveryDomain.Endpoint.Deds;
    using AllocationDeliveryDomain.Endpoint.Handlers;
    using AllocationDeliveryDomain.Endpoint.IoC;
    using AllocationDeliveryDomain.Endpoint.Services;
    using Castle.MicroKernel.Lifestyle;
    using Castle.Windsor;
    using Moq;
    using NServiceBus;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Cache;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.Common.Commands;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.AllocationDeliveryDomain.Endpoint.BusinessLogic.Validator;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.AllocationActuals;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;

    class Program
    {
        static void Main()
        {
            using (IWindsorContainer container = new WindsorContainer().Install(new WindsorInstaller(new LoggerFactory())))
            {
                List<ReportedActualsLoadedCommand> reportedActualsLoadedCommandMessages = new List<ReportedActualsLoadedCommand>();

                reportedActualsLoadedCommandMessages.AddRange(GetReportedActualsLoadedCommandMessages(container, "EOP1", "E01"));
                reportedActualsLoadedCommandMessages.AddRange(GetReportedActualsLoadedCommandMessages(container, "ILR1516", "R01"));

                reportedActualsLoadedCommandMessages.ForEach(cmd => RunReportedActualsLoadedCommandMessage(container, cmd));
            }

            Console.WriteLine("DONE.. press any key to exit");
            Console.ReadKey();
        }

        private static IEnumerable<ReportedActualsLoadedCommand> GetReportedActualsLoadedCommandMessages(
            IWindsorContainer container, string collectionType, string collectionReturnCode)
        {
            using (container.BeginScope())
            {
                List<ReportedActualsLoadedCommand> reportedActualsLoadedCommandMessages = new List<ReportedActualsLoadedCommand>();

                Mock<IBus> busMock = new Mock<IBus>();
                busMock
                    .Setup(m => m.Send(It.IsAny<ReportedActualsLoadedCommand>()))
                    .Callback<object>(o => reportedActualsLoadedCommandMessages.Add((ReportedActualsLoadedCommand) o));

                DedsPoller dedsPoller = new DedsPoller(
                    new Mock<IDedsService>().Object,
                    container.Resolve<IAzureRepository<ReportedActual>>(),
                    busMock.Object,
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

        private static void RunReportedActualsLoadedCommandMessage(IWindsorContainer container, ReportedActualsLoadedCommand command)
        {
            Console.WriteLine("Processing partition {0}", command.PartitionKey);

            using (container.BeginScope())
            {
                Mock<ILogger> loggerMock = new Mock<ILogger>();

                Mock<IDate> dateMock = new Mock<IDate>();
                dateMock
                    .Setup(m => m.GetCalculationDate())
                    .Returns(new DateTime(2015, 09, 05, 08, 00, 00, DateTimeKind.Utc));

                IMonitoringDeliverablesDbContext monitoringDeliverablesDbContext = new MonitoringDeliverablesDbContext();

                IFundingStreamConfigurationStore fundingStreamConfigurationStore = new FundingStreamConfigurationStore
                {
                    DbContext = monitoringDeliverablesDbContext,
                    FundingStreamPeriodCache = container.Resolve<IFundingStreamPeriodCache>()
                };

                IMonitoringDeliverableStore monitoringDeliverableStore = new MonitoringDeliverableStore(monitoringDeliverablesDbContext, new Mock<ILogger>().Object)
                {
                    Context = monitoringDeliverablesDbContext
                };

                ReportedActualsLoadedHandler reportedActualsLoadedHandler = new ReportedActualsLoadedHandler(
                    new ActualEnricher
                    {
                        DeliverableStore = monitoringDeliverableStore
                    },
                    new ActualValidator
                    {
                        Date = dateMock.Object,
                        Logger = loggerMock.Object,
                        Store = fundingStreamConfigurationStore
                    },
                    container.Resolve<IAzureRepository<ReportedActual>>(),
                    loggerMock.Object,
                    container.Resolve<IMapper<EnrichedReportedActual, ContractAllocationActualsType>>(),
                    new ActualsAuditMapper(fundingStreamConfigurationStore),
                    fundingStreamConfigurationStore,
                    monitoringDeliverableStore,
                    new CurrentViewActualsComponent(fundingStreamConfigurationStore, monitoringDeliverableStore))
                {
                    Bus = new Mock<IBus>().Object
                };

                reportedActualsLoadedHandler.Handle(command);
            }
        }
    }
}
