namespace Datafix.Tests
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Globalization;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Client;
    using Microsoft.Xrm.Client.Services;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using AllocationDeliveryDomain.Endpoint.BusinessLogic.Mapper;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using MoreLinq;
    using NServiceBus;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.AllocationActuals;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Handlers;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore;

    [TestClass]
    public class ReplayAllocationActualsVerifiedMessagesFix
    {
        private readonly IReadOnlyCollection<string> _fsps = new List<string>
            {
                "16-18NLA1617",
                "ANLA1617"
            };

        [TestMethod, TestCategory("TechnicalExploration")]
        public void ReplayEsf44CollectionFromActualsAuditIntoTestEnvironmentToTestMonthEndPerformance()
        {
            // pre-requisite: set override date to 2019-09-10 08:39 UTC and restart workers

            IList<EnrichedReportedActual> enrichedReportedActuals =
                GetEnrichedReportedActualsFromAuditTable(new[] { "ESF1420" }, "ESF44");

            IReadOnlyCollection<AllocationVersion> latestAllocationVersions = GetAllocationVersions(new[] { "ESF1420" });

            enrichedReportedActuals.ForEach(actual => UpdateWithLatestVersion(actual, latestAllocationVersions));

            EnrichedActualMapper enrichedActualMapper = new EnrichedActualMapper();
            IEnumerable<ContractAllocationActualsType> contractAllocationActuals = enrichedActualMapper.Map(enrichedReportedActuals);

            using (IBus bus = CreateBus())
            {
                foreach (ContractAllocationActualsType contractAllocationActual in contractAllocationActuals)
                {
                    bus.Publish(new AllocationActualsVerified { AllocationActuals = contractAllocationActual });
                }
            }
        }

        [TestMethod, TestCategory("DataFix_R32f")]
        public void Apps03ReplayMessages_ShouldSendApps03AllocationActualsVerifiedEvents()
        {
            IList<EnrichedReportedActual> actualAuditRowsApps03 = GetEnrichedReportedActualsFromAuditTable(_fsps, "APPS03");
            IList<EnrichedReportedActual> actualAuditRowsApps05 = GetEnrichedReportedActualsFromAuditTable(_fsps, "APPS05");

            var actualsNotInApps03 = actualAuditRowsApps05.Where(apps05 => !actualAuditRowsApps03.Contains(apps05)).ToList();
            actualsNotInApps03.ForEach(a => { a.ActualValue = 0;
                                                a.ActualVolume = 0;
                                                a.CollectionReturnCode = "APPS03";
            });

            actualsNotInApps03.ForEach(actualAuditRowsApps03.Add);

            var latestAllocationVersions = GetAllocationVersions(_fsps);

            actualAuditRowsApps03.ForEach(actual => UpdateWithLatestVersion(actual, latestAllocationVersions));

            EnrichedActualMapper enrichedActualMapper = new EnrichedActualMapper();
            IEnumerable<ContractAllocationActualsType> contractAllocationActuals = enrichedActualMapper.Map(actualAuditRowsApps03);

            using (var bus = CreateBus())
            {
                foreach (var contractAllocationActual in contractAllocationActuals)
                {
                    bus.Publish(new AllocationActualsVerified {AllocationActuals = contractAllocationActual});
                }
            }
        }

        [TestMethod, TestCategory("DataFix_R40B")]
        public void ReplayMessages_ShouldSendAllocationsForCollectionToPayCalc()
        {
            IList<EnrichedReportedActual> actualAuditRows = GetEnrichedReportedActualsFromAuditTable(new List<string> { "16-18NLA1718", "16-18NLAP2018", "ANLA1718", "ANLAP2018"}, "APPS09");
           
            EnrichedActualMapper enrichedActualMapper = new EnrichedActualMapper();
            IEnumerable<ContractAllocationActualsType> contractAllocationActuals = enrichedActualMapper.Map(actualAuditRows);

            using (var bus = CreateBus())
            {
                foreach (var contractAllocationActual in contractAllocationActuals)
                {
                    bus.Publish(new AllocationActualsVerified { AllocationActuals = contractAllocationActual });
                }
            }
        }

        [TestMethod, TestCategory("DataFix_R32f_IntegrityCheck")]
        public void Apps03ReplayMessages_ShouldHaveMatchingActualsAuditToCrm()
        {
            IList<EnrichedReportedActual> actualAuditRows = GetEnrichedReportedActualsFromAuditTable(_fsps, "APPS03");

            var latestAllocationVersions = GetAllocationVersions(_fsps);

            actualAuditRows.ForEach(actual => UpdateWithLatestVersion(actual, latestAllocationVersions));

            actualAuditRows.ForEach(aur =>
            {
                string period = TransformToPeriod(aur.Period);
                string allocationNumber = aur.ContractAllocationNumber;
                string deliverableCode = aur.DeliverableCode.ToString();
                int contractVersion = aur.ContractVersion;
                int contractSubVersion = aur.ContractSubVersion;

                ContractDeliverablePeriodInfo contractDeliverablePeriod =
                    GetContractDeliverablePeriodFromCrm(allocationNumber, period, deliverableCode, contractVersion, contractSubVersion);

                Assert.IsNotNull(contractDeliverablePeriod, $"No matching Contract Deliverable Period for {contractDeliverablePeriod}");
                Assert.AreEqual((decimal)aur.ActualValue, contractDeliverablePeriod.ActualValue, $"Actual Value mismatch for {contractDeliverablePeriod}");
            });
        }

        [TestMethod, TestCategory("DataFix_R54f")]
        public void N06ReplayMessages_ShouldRecreateAllocationActualsVerifiedAndGiveToPayCalc()
        {
            IReadOnlyCollection<string> fsps = new List<string>{ "NCS-C2018" };

            IList<EnrichedReportedActual> reportedActuals = GetEnrichedReportedActualsFromAuditTableForAllocations(GetAllocationNumbers("NCS-C2018"), "N06");

            var latestAllocationVersions = GetAllocationVersions(fsps);

            reportedActuals.ForEach(actual => UpdateWithLatestVersion(actual, latestAllocationVersions));

            EnrichedActualMapper enrichedActualMapper = new EnrichedActualMapper();
            IEnumerable<ContractAllocationActualsType> contractAllocationActuals = enrichedActualMapper.Map(reportedActuals);
            IReadOnlyCollection<AllocationActualsVerified> allocationActualsVerifiedMessages =
                contractAllocationActuals.Select(actuals => new AllocationActualsVerified
                {
                    AllocationActuals = actuals
                }).ToList();

            var container = GetContainerForPayCalc();

            var handler = container.Resolve<IHandleMessages<IAllocationActualsVerified>>();

            allocationActualsVerifiedMessages.ForEach(m => handler.Handle(m));
        }

        [TestMethod, TestCategory("DataFix_R54g")]
        public void N06ReplayMessages_ShouldRecreateAllocationActualsVerifiedAndGiveToPayCalc_R54g()
        {
            IReadOnlyCollection<string> fsps = new List<string> { "NCS-C2018" };

            IList<EnrichedReportedActual> reportedActuals = GetEnrichedReportedActualsFromAuditTableForAllocations(GetAllocationNumbers("NCS-C2018"), "N06");

            var latestAllocationVersions = GetAllocationVersions(fsps);

            reportedActuals.ForEach(actual => UpdateWithLatestVersion(actual, latestAllocationVersions));

            EnrichedActualMapper enrichedActualMapper = new EnrichedActualMapper();
            IEnumerable<ContractAllocationActualsType> contractAllocationActuals = enrichedActualMapper.Map(reportedActuals);
            IReadOnlyCollection<AllocationActualsVerified> allocationActualsVerifiedMessages =
                contractAllocationActuals.Select(actuals => new AllocationActualsVerified
                {
                    AllocationActuals = actuals
                }).ToList();

            var container = GetContainerForPayCalc();

            var handler = container.Resolve<IHandleMessages<IAllocationActualsVerified>>();

            allocationActualsVerifiedMessages.ForEach(m => handler.Handle(m));
        }

        private IWindsorContainer GetContainerForPayCalc()
        {
            ILoggerFactory factory = new LoggerFactory();

            IWindsorContainer container =
                new WindsorContainer().Install(
                    new SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.IoC.WindsorInstaller(factory));

            container.Register(Component.For<IBus>().Instance(CreateBusForPayCalc()));
                
            container.Register(Component.For<IHandleMessages<AllocationActualsVerified>>()
                .ImplementedBy<AllocationActualsVerifiedHandler>().LifestyleSingleton());

            container.Register(Component.For<IDate>()
                .ImplementedBy<YesterdayDateProvider>().LifestyleSingleton().IsDefault());
            container.BeginScope();

            return container;
        }

        private class YesterdayDateProvider : IDate
        {
            public DateTime GetCalculationDate()
            {
                return new DateTime(2018, 10, 11, 0,0,0, DateTimeKind.Utc);
            }

            public DateTime GetCalculationDateWithKey(string key)
            {
                return GetCalculationDate();
            }
        }

        private void UpdateWithLatestVersion(EnrichedReportedActual enrichedReportedActual, IReadOnlyCollection<AllocationVersion> allocationVersions)
        {
            var allocationVersion =
                allocationVersions.Single(a => a.AllocationNumber == enrichedReportedActual.ContractAllocationNumber);

            enrichedReportedActual.ContractVersion = allocationVersion.Version;
            enrichedReportedActual.ContractSubVersion = allocationVersion.SubVersion;
        }

        private IReadOnlyCollection<AllocationVersion> GetAllocationVersions(IReadOnlyCollection<string> fsps)
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {
                context.Database.CommandTimeout = 60;

                return
                    context.AllocationDeliverablePeriods.Where(a => fsps.Contains(a.FundingStreamPeriodCode))
                    .Select(a => new {a.ContractAllocationNumber, a.ContractVersionNumber, a.ContractSubVersionNumber})
                    .Distinct()
                    .AsEnumerable()
                    .Select(a => new AllocationVersion(a.ContractAllocationNumber, a.ContractVersionNumber, a.ContractSubVersionNumber)).ToList();
            }
        }

        private IReadOnlyCollection<string> GetAllocationNumbers(string fsp)
        {
            using (var context = new PaymentSchedulePolicyContext())
            {
                return
                    context.Allocations.Where(a => a.FundingStreamPeriodCode == fsp)
                        .Select(a => a.AllocationNumber)
                        .Distinct()
                        .ToList();
            }
        }

        private class AllocationVersion
        {
            public AllocationVersion(string allocationNumber, int version, int subVersion)
            {
                AllocationNumber = allocationNumber;
                Version = version;
                SubVersion = subVersion;
            }

            public string AllocationNumber { get; }

            public int Version { get; }

            public int SubVersion { get; }
        } 

        private static IBus CreateBus()
        {
            var configuration = new BusConfiguration();
            configuration.AssembliesToScan(
               AllAssemblies.Matching("CrossDomain.Integration.Events.dll")
                   .And("Microsoft.WindowsAzure.Configuration.dll")
                   .And("NServiceBus.Azure.Transports.WindowsAzureServiceBus.dll")
                   .And("CrossDomain.Integration.Messages.dll"));

            configuration.UseSerialization<JsonSerializer>();
            configuration.UseTransport<AzureServiceBusTransport>();
            configuration.UsePersistence<InMemoryPersistence>();
            configuration.EndpointName("AllocationDeliveryDomain.Validation");
            configuration.Conventions()
               .DefiningEventsAs(
                   t => t.Namespace != null && t.Namespace.Equals("SFA.FCT.CrossDomain.Integration.Events"))
               .DefiningMessagesAs(t => null != t.Namespace && t.Namespace.EndsWith("Messages"));

            configuration.ScaleOut().UseSingleBrokerQueue();

            return Bus.Create(configuration);
        }

        private static IBus CreateBusForPayCalc()
        {
            var configuration = new BusConfiguration();
            configuration.AssembliesToScan(
                AllAssemblies.Matching("CrossDomain.Integration.Events.dll")
                    .And("Microsoft.WindowsAzure.Configuration.dll")
                    .And("NServiceBus.Azure.Transports.WindowsAzureServiceBus.dll")
                    .And("CrossDomain.Integration.Messages.dll"));

            configuration.UseSerialization<JsonSerializer>();
            configuration.UseTransport<AzureServiceBusTransport>();
            configuration.UsePersistence<InMemoryPersistence>();
            configuration.EndpointName("PaymentManagementDomain.PaymentSchedule");
            configuration.Conventions()
                .DefiningEventsAs(
                    t => t.Namespace != null && t.Namespace.Equals("SFA.FCT.CrossDomain.Integration.Events"))
                .DefiningMessagesAs(t => null != t.Namespace && t.Namespace.EndsWith("Messages"));

            configuration.ScaleOut().UseSingleBrokerQueue();

            return Bus.Create(configuration);
        }

        private static IList<EnrichedReportedActual> GetEnrichedReportedActualsFromAuditTable(IReadOnlyCollection<string> fsps, string collectionReturnCode)
        {
            return GetActualAuditRows(fsps, TransformAuditToEnrichedActual, collectionReturnCode);
        }

        private static IList<EnrichedReportedActual> GetEnrichedReportedActualsFromAuditTableForAllocations(IReadOnlyCollection<string> allocationNumbers, string collectionReturnCode)
        {
            return GetActualAuditRowsForAllocationNumbers(allocationNumbers, TransformAuditToEnrichedActual, collectionReturnCode);
        }

        private static EnrichedReportedActual TransformAuditToEnrichedActual(
            AllocationDeliverablePeriodActualAudit audit)
        {
            return new EnrichedReportedActual
            {
                Ukprn = audit.Ukprn,
                ContractNumber = audit.ContractNumber,
                ContractVersion = audit.ContractVersion,
                ContractSubVersion = audit.ContractSubVersion,
                AllocationStartDate = audit.AllocationStartDate,
                AllocationEndDate = audit.AllocationEndDate,
                EnrichedDeliverableCode = audit.DeliverableCode.ToString(),
                OrganisationId = audit.OrganisationId,
                PeriodTypeCode = audit.PeriodTypeCode,
                Period = audit.Period,
                FundingStreamPeriodCode = audit.FundingStreamPeriodCode,
                ContractAllocationNumber = audit.ContractAllocationNumber,
                UoPCode = audit.UopCode,
                DeliverableCode = audit.DeliverableCode.ToString(),
                ActualVolume = audit.ActualVolume,
                ActualValue = audit.ActualValue,
                CollectionReturnCode = audit.CollectionReturnCode,
                CollectionType = audit.CollectionType
            };
        }

        private static IList<T> GetActualAuditRows<T>(IReadOnlyCollection<string> fsps, Func<AllocationDeliverablePeriodActualAudit, T> transform, string collectionReturnCode)
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {
                context.Database.CommandTimeout = 60;

                return context.AllocationDeliverablePeriodActualAudits.Where(
                    a => a.CollectionReturnCode == collectionReturnCode && fsps.Contains(a.FundingStreamPeriodCode))
                    .Select(transform).ToList();
            }
        }

        private static IList<T> GetActualAuditRowsForAllocationNumbers<T>(IReadOnlyCollection<string> allocationNumbers, Func<AllocationDeliverablePeriodActualAudit, T> transform, string collectionReturnCode)
        {
            using (var context = new MonitoringDeliverablesDbContext())
            {
                return context.AllocationDeliverablePeriodActualAudits.Where(
                        a => a.CollectionReturnCode == collectionReturnCode && allocationNumbers.Contains(a.ContractAllocationNumber))
                    .Select(transform).ToList();
            }
        }

        private ContractDeliverablePeriodInfo GetContractDeliverablePeriodFromCrm(string allocationNumber, string period, string deliverableCode, int contractVersion, int contractSubVersion)
        {
            using (var xrmContext = new XrmServiceContext(GetConnection()))
            {
                return (from alloc in xrmContext.sfa_contractallocationSet
                        join contract in xrmContext.sfa_contractSet on alloc.sfa_ContractId.Id equals contract.sfa_contractId
                        join cd in xrmContext.sfa_contractdeliverableSet on alloc.sfa_contractallocationId equals cd.sfa_ContractAllocationId.Id
                        join cdp in xrmContext.sfa_contractdeliverableperiodSet on cd.sfa_contractdeliverableId equals cdp.sfa_ContractDeliverableId.Id
                        where alloc.sfa_contractallocationnumber == allocationNumber
                         where cd.sfa_DeliverableCode == deliverableCode
                         where cdp.sfa_PeriodName == period
                        where contract.sfa_Version.Value == contractVersion
                        where contract.sfa_SubVersion.Value == contractSubVersion
                        select new ContractDeliverablePeriodInfo(allocationNumber, period, deliverableCode, contractVersion, contractSubVersion, cdp.sfa_ActualValue.Value)).SingleOrDefault();
            }
        }

        public IOrganizationService GetConnection()
        {
            var xrmConnection =
               CrmConnection.Parse(ConfigurationManager.ConnectionStrings["CrmConnectionString"].ConnectionString);

            return new OrganizationService(xrmConnection);
        }

        private static string TransformToPeriod(string paasPeriod)
        {
            int mm = int.Parse(paasPeriod.Substring(4, 2));
            int yy = int.Parse(paasPeriod.Substring(2, 2));
            int yyyy = int.Parse(paasPeriod.Substring(0, 4));
            string monthName = new DateTime(yyyy, mm, 1).ToString("MMM", CultureInfo.InvariantCulture);

            return $"{monthName}-{yy}";
        }

        private class ContractDeliverablePeriodInfo
        {
            private readonly string _allocationNumber;
            private readonly string _period;
            private readonly string _deliverableCode;
            private readonly int _contractVersion;
            private readonly int _contractSubVersion;

            public ContractDeliverablePeriodInfo(string allocationNumber, string period, string deliverableCode, int contractVersion, int contractSubVersion, decimal actualValue)
            {
                _allocationNumber = allocationNumber;
                _period = period;
                _deliverableCode = deliverableCode;
                _contractVersion = contractVersion;
                _contractSubVersion = contractSubVersion;
                ActualValue = actualValue;
            }

            public decimal ActualValue { get; }

            public override string ToString()
            {
                return $"AllocationNumber: {_allocationNumber}, Period: {_period}, DeliverableCode: {_deliverableCode}, ContractVersion: {_contractVersion}, ContractSubVersion: {_contractSubVersion}, ActualValue: {ActualValue}";
            }
        }
    }
}
